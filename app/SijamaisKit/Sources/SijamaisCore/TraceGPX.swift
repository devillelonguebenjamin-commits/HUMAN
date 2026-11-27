import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Pont GPX (premium Randonnée, 27/11/2026) : le format que Komoot, Visorando, Strava, Garmin, IGN et les montres
/// exportent et importent. SIJAMAIS lit la trace, l'analyse et l'attache à la fiche de sortie.
public struct TraceGPX: Sendable, Equatable, Codable {
    public struct Point: Sendable, Equatable, Codable {
        public let latitude: Double
        public let longitude: Double
        public let altitude: Double?
    }

    public let nom: String
    public let points: [Point]

    public init(nom: String, points: [Point]) {
        self.nom = nom
        self.points = points
    }

    public enum Erreur: Error, Equatable { case illisible, vide }

    /// Lit un fichier GPX : points de trace (trkpt), sinon d'itinéraire (rtept), sinon points de passage (wpt).
    public static func lire(_ donnees: Data, nomParDefaut: String = "Trace") throws -> TraceGPX {
        let lecteur = Lecteur()
        let p = XMLParser(data: donnees)
        p.delegate = lecteur
        guard p.parse() else { throw Erreur.illisible }
        let pts = !lecteur.trk.isEmpty ? lecteur.trk : (!lecteur.rte.isEmpty ? lecteur.rte : lecteur.wpt)
        guard pts.count >= 2 else { throw Erreur.vide }
        let nom = lecteur.nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return TraceGPX(nom: nom.isEmpty ? nomParDefaut : nom, points: pts)
    }

    // MARK: Analyse

    /// Distance entre deux points, en mètres (formule de haversine).
    static func distance(_ a: Point, _ b: Point) -> Double {
        let r = 6_371_000.0
        let p1 = a.latitude * .pi / 180, p2 = b.latitude * .pi / 180
        let dp = (b.latitude - a.latitude) * .pi / 180, dl = (b.longitude - a.longitude) * .pi / 180
        let h = sin(dp / 2) * sin(dp / 2) + cos(p1) * cos(p2) * sin(dl / 2) * sin(dl / 2)
        return 2 * r * asin(min(1, sqrt(h)))
    }

    public var distanceMetres: Double {
        zip(points, points.dropFirst()).reduce(0) { $0 + Self.distance($1.0, $1.1) }
    }

    /// Dénivelés positif et négatif, en mètres. Les variations de moins de 3 m sont ignorées (bruit du GPS).
    public var denivele: (positif: Double, negatif: Double) {
        let alts = points.compactMap(\.altitude)
        guard var reference = alts.first else { return (0, 0) }
        var plus = 0.0, moins = 0.0
        for a in alts.dropFirst() {
            let d = a - reference
            if d >= 3 { plus += d; reference = a } else if d <= -3 { moins += -d; reference = a }
        }
        return (plus, moins)
    }

    public var altitudeMin: Double? { points.compactMap(\.altitude).min() }
    public var altitudeMax: Double? { points.compactMap(\.altitude).max() }

    /// Temps de marche estimé, en minutes, sans les pauses : méthode DIN 33466
    /// (4 km/h à plat, 300 m/h en montée, 500 m/h en descente ; le plus long des deux temps plus la moitié du plus court).
    public var minutesDeMarche: Int {
        let horizontal = distanceMetres / 4000 * 60
        let d = denivele
        let vertical = d.positif / 300 * 60 + d.negatif / 500 * 60
        let total = max(horizontal, vertical) + min(horizontal, vertical) / 2
        return Int(total.rounded())
    }

    /// Temps total conseillé : marche, plus 10 minutes de pause par heure de marche.
    public var minutesAvecPauses: Int { minutesDeMarche + minutesDeMarche / 6 }

    /// Profil d'altitude, en au plus `n` points : (distance depuis le départ en km, altitude en m).
    public func profil(points n: Int = 120) -> [(km: Double, altitude: Double)] {
        var cumul = 0.0
        var tout: [(Double, Double)] = []
        for (i, p) in points.enumerated() {
            if i > 0 { cumul += Self.distance(points[i - 1], p) }
            if let a = p.altitude { tout.append((cumul / 1000, a)) }
        }
        guard tout.count > n, n > 1 else { return tout.map { (km: $0.0, altitude: $0.1) } }
        let pas = Double(tout.count - 1) / Double(n - 1)
        return (0..<n).map { i in let t = tout[Int((Double(i) * pas).rounded())]; return (km: t.0, altitude: t.1) }
    }

    /// Résumé lisible, pour la fiche de sortie : « Lac Blanc, 12,4 km, +850 m, environ 4 h 30 de marche ».
    public var resume: String {
        let km = String(format: "%.1f", locale: Locale(identifier: "fr_FR"), distanceMetres / 1000)
        let m = minutesDeMarche
        return "\(nom), \(km) km, +\(Int(denivele.positif.rounded())) m, environ \(m / 60) h \(String(format: "%02d", m % 60)) de marche"
    }

    /// Fichier GPX de la trace, pour la renvoyer vers une montre ou une autre application.
    public func versGPX() -> String {
        func echapper(_ s: String) -> String {
            s.replacingOccurrences(of: "&", with: "&amp;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;")
        }
        var s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gpx version=\"1.1\" creator=\"SIJAMAIS\" xmlns=\"http://www.topografix.com/GPX/1/1\">\n"
        s += "<trk><name>\(echapper(nom))</name><trkseg>\n"
        for p in points {
            s += String(format: "<trkpt lat=\"%.6f\" lon=\"%.6f\">", locale: Locale(identifier: "en_US_POSIX"), p.latitude, p.longitude)
            if let a = p.altitude { s += String(format: "<ele>%.1f</ele>", locale: Locale(identifier: "en_US_POSIX"), a) }
            s += "</trkpt>\n"
        }
        return s + "</trkseg></trk>\n</gpx>\n"
    }
}

/// Lecteur XML du GPX (namespaces ignorés : seuls les noms locaux comptent).
private final class Lecteur: NSObject, XMLParserDelegate {
    var trk: [TraceGPX.Point] = []
    var rte: [TraceGPX.Point] = []
    var wpt: [TraceGPX.Point] = []
    var nom = ""

    private var enCours: (type: String, lat: Double, lon: Double)?
    private var altitude: Double?
    private var texte = ""
    private var profondeurNom = 0
    private var dansPoint = false

    private func local(_ n: String) -> String { n.split(separator: ":").last.map(String.init) ?? n }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String: String] = [:]) {
        let n = local(elementName)
        texte = ""
        if ["trkpt", "rtept", "wpt"].contains(n), let la = attributes["lat"].flatMap(Double.init), let lo = attributes["lon"].flatMap(Double.init) {
            enCours = (n, la, lo)
            altitude = nil
            dansPoint = true
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) { texte += string }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let n = local(elementName)
        if n == "ele", dansPoint { altitude = Double(texte.trimmingCharacters(in: .whitespacesAndNewlines)) }
        if n == "name", !dansPoint, nom.isEmpty { nom = texte }
        if ["trkpt", "rtept", "wpt"].contains(n), let c = enCours {
            let p = TraceGPX.Point(latitude: c.lat, longitude: c.lon, altitude: altitude)
            switch c.type {
            case "trkpt": trk.append(p)
            case "rtept": rte.append(p)
            default: wpt.append(p)
            }
            enCours = nil
            dansPoint = false
        }
    }
}
