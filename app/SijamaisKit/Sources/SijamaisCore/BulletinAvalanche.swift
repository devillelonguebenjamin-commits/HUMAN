import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Bulletin d'estimation du risque d'avalanche (BRA) de Météo-France, un par massif (28/11/2026).
/// Format : « Descriptif technique des informations du bulletin avalanche », Météo-France, version du 26/10/2023.
/// Diffusé chaque jour de début novembre à fin mai, vers 16 h, valable en général jusqu'au lendemain 18 h.
/// L'application ne parle jamais à Météo-France : un petit service (serveur/bulletins-avalanche) dépose
/// chaque soir les 36 bulletins sur notre hébergement, d'où le téléphone les télécharge pour les lire sans réseau.
public struct BulletinAvalanche: Sendable, Equatable {
    public struct Massif: Sendable, Hashable, Identifiable {
        public let id: Int
        public let nom: String
        public let zone: String
        /// Départements concernés (codes INSEE ; vide pour l'Andorre).
        public let departements: [String]
    }

    /// Les 36 massifs (annexe 1 du descriptif technique).
    public static let massifs: [Massif] = [
        Massif(id: 1, nom: "Chablais", zone: "Alpes du Nord", departements: ["74"]),
        Massif(id: 2, nom: "Aravis", zone: "Alpes du Nord", departements: ["74"]),
        Massif(id: 3, nom: "Mont-Blanc", zone: "Alpes du Nord", departements: ["74"]),
        Massif(id: 4, nom: "Bauges", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 5, nom: "Beaufortain", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 6, nom: "Haute-Tarentaise", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 7, nom: "Chartreuse", zone: "Alpes du Nord", departements: ["38"]),
        Massif(id: 8, nom: "Belledonne", zone: "Alpes du Nord", departements: ["38"]),
        Massif(id: 9, nom: "Maurienne", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 10, nom: "Vanoise", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 11, nom: "Haute-Maurienne", zone: "Alpes du Nord", departements: ["73"]),
        Massif(id: 12, nom: "Grandes-Rousses", zone: "Alpes du Nord", departements: ["38"]),
        Massif(id: 13, nom: "Thabor", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 14, nom: "Vercors", zone: "Alpes du Nord", departements: ["38"]),
        Massif(id: 15, nom: "Oisans", zone: "Alpes du Nord", departements: ["38"]),
        Massif(id: 16, nom: "Pelvoux", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 17, nom: "Queyras", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 18, nom: "Dévoluy", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 19, nom: "Champsaur", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 20, nom: "Embrunais Parpaillon", zone: "Alpes du Sud", departements: ["05"]),
        Massif(id: 21, nom: "Ubaye", zone: "Alpes du Sud", departements: ["04"]),
        Massif(id: 22, nom: "Haut-Var Haut-Verdon", zone: "Alpes du Sud", departements: ["04", "06"]),
        Massif(id: 23, nom: "Mercantour", zone: "Alpes du Sud", departements: ["06"]),
        Massif(id: 40, nom: "Cinto Rotondo", zone: "Corse", departements: ["2B", "2A"]),
        Massif(id: 41, nom: "Renoso Incudine", zone: "Corse", departements: ["2B", "2A"]),
        Massif(id: 64, nom: "Pays Basque", zone: "Pyrénées", departements: ["64"]),
        Massif(id: 65, nom: "Aspe Ossau", zone: "Pyrénées", departements: ["64"]),
        Massif(id: 66, nom: "Haute-Bigorre", zone: "Pyrénées", departements: ["65"]),
        Massif(id: 67, nom: "Aure Louron", zone: "Pyrénées", departements: ["65"]),
        Massif(id: 68, nom: "Luchonnais", zone: "Pyrénées", departements: ["31"]),
        Massif(id: 69, nom: "Couserans", zone: "Pyrénées", departements: ["31", "09"]),
        Massif(id: 70, nom: "Haute-Ariège", zone: "Pyrénées", departements: ["09"]),
        Massif(id: 71, nom: "Andorre", zone: "Pyrénées", departements: []),
        Massif(id: 72, nom: "Orlu Saint-Barthélemy", zone: "Pyrénées", departements: ["09"]),
        Massif(id: 73, nom: "Capcir Puymorens", zone: "Pyrénées", departements: ["66"]),
        Massif(id: 74, nom: "Cerdagne Canigou", zone: "Pyrénées", departements: ["66"]),
    ]

    public static let zones = ["Alpes du Nord", "Alpes du Sud", "Pyrénées", "Corse"]

    public static func massif(_ id: Int) -> Massif? { massifs.first { $0.id == id } }

    /// Massifs d'un département (pour proposer le bon bulletin d'après la trace ou le département principal).
    public static func massifs(departement: String) -> [Massif] { massifs.filter { $0.departements.contains(departement) } }

    /// Saison de diffusion : de novembre à mai.
    public static func enSaison(_ date: Date, calendrier: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        let mois = calendrier.component(.month, from: date)
        return mois >= 11 || mois <= 5
    }

    // MARK: Échelle européenne du risque d'avalanche

    public static func libelle(_ niveau: Int) -> String {
        switch niveau {
        case 1: return "faible"
        case 2: return "limité"
        case 3: return "marqué"
        case 4: return "fort"
        case 5: return "très fort"
        default: return "non évalué"
        }
    }

    /// Couleurs officielles de l'échelle européenne (vert, jaune, orange, rouge, damier rouge et noir).
    public static func couleur(_ niveau: Int) -> UInt32 {
        switch niveau {
        case 1: return 0xCCFF66
        case 2: return 0xFFFF00
        case 3: return 0xFF9900
        case 4: return 0xFF0000
        case 5: return 0x9B0000
        default: return 0xBBBBBB
        }
    }

    // MARK: Contenu

    public struct Enneigement: Sendable, Equatable {
        public let altitude: Int
        public let nord: Int
        public let sud: Int
    }

    public struct NeigeFraiche: Sendable, Equatable {
        public let date: Date
        public let minimum: Int
        public let maximum: Int
    }

    public struct Echeance: Sendable, Equatable {
        public let date: Date
        public let iso0: Int?
        public let pluieNeige: Int?
        public let ventBas: String
        public let ventHaut: String
        public let temps: Int?
    }

    public let massifId: Int
    public let massifNom: String
    public let redaction: Date?
    public let validite: Date?
    public let amendement: Bool
    /// Risque de la tranche basse (ou unique) et de la tranche haute, avec leur localisation (« <2100 », « >2100 », « N », « S »...).
    public let risque1: Int
    public let localisation1: String
    public let risque2: Int?
    public let localisation2: String
    public let altitudeLimite: Int?
    public let risqueMaxi: Int
    public let commentaireRisque: String
    public let risqueMaxiJ2: Int?
    public let tendanceJ2: String
    /// Orientations des pentes les plus dangereuses (N, NE, E, SE, S, SW, W, NW).
    public let pentes: [String]
    public let commentairePentes: String
    public let resume: String
    public let avis: String
    public let stabilite: String
    public let qualite: String
    public let limiteSud: Int?
    public let limiteNord: Int?
    public let enneigement: [Enneigement]
    public let altitudeNeigeFraiche: Int?
    public let neigeFraiche: [NeigeFraiche]
    public let commentaireMeteo: String
    public let altitudesVent: (bas: Int?, haut: Int?)
    public let meteo: [Echeance]

    public static func == (a: Self, b: Self) -> Bool {
        a.massifId == b.massifId && a.redaction == b.redaction && a.risqueMaxi == b.risqueMaxi && a.resume == b.resume
    }

    public enum Erreur: Error, Equatable { case illisible, pasUnBulletin }

    /// Le bulletin n'est plus valable (après son heure de validité, en général le lendemain 18 h).
    public func estPerime(maintenant: Date = Date()) -> Bool {
        guard let validite else { return true }
        return maintenant > validite
    }

    /// Une ligne pour la fiche de sortie : « Avalanche, Belledonne : risque 3 (marqué) au-dessus de 2100 m, valable jusqu'au vendredi 27 octobre à 18h00 ».
    public func resumeCourt(fuseau: TimeZone = .current) -> String {
        var t = "Avalanche, \(massifNom) : risque \(risqueMaxi) sur 5 (\(Self.libelle(risqueMaxi)))"
        if let r2 = risque2, r2 != risque1, let alt = altitudeLimite {
            t += r2 > risque1 ? " au-dessus de \(alt) m" : " au-dessous de \(alt) m"
        }
        if let v = validite {
            let f = DateFormatter()
            f.locale = Locale(identifier: "fr_FR")
            f.timeZone = fuseau
            f.dateFormat = "EEEE d MMMM 'à' HH'h'mm"
            t += ", bulletin valable jusqu'au \(f.string(from: v))"
        }
        return t + " (Météo-France)."
    }

    // MARK: Lecture du XML

    public static func lire(_ donnees: Data) throws -> BulletinAvalanche {
        let l = LecteurBRA()
        let p = XMLParser(data: donnees)
        p.delegate = l
        guard p.parse() else { throw Erreur.illisible }
        guard let racine = l.racine, racine["TYPEBULLETIN"] == "BRA", let id = racine["ID"].flatMap(Int.init) else { throw Erreur.pasUnBulletin }
        let r = l.risque
        func entier(_ s: String?) -> Int? { s.flatMap { Int($0.trimmingCharacters(in: .whitespaces)) } }
        let orientations = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let r1 = entier(r["RISQUE1"]) ?? 0
        return BulletinAvalanche(
            massifId: id,
            massifNom: massif(id)?.nom ?? racine["MASSIF"] ?? "Massif \(id)",
            redaction: LecteurBRA.date(racine["DATEBULLETIN"]),
            validite: LecteurBRA.date(racine["DATEVALIDITE"]) ?? LecteurBRA.date(l.textes["DateValidite"]),
            amendement: racine["AMENDEMENT"] == "true",
            risque1: r1,
            localisation1: r["LOC1"] ?? "",
            risque2: entier(r["RISQUE2"]),
            localisation2: r["LOC2"] ?? "",
            altitudeLimite: entier(r["ALTITUDE"]),
            risqueMaxi: entier(r["RISQUEMAXI"]) ?? r1,
            commentaireRisque: r["COMMENTAIRE"] ?? "",
            risqueMaxiJ2: entier(r["RISQUEMAXIJ2"]),
            tendanceJ2: [l.textes["RisqueJ2"], l.textes["CommentaireRisqueJ2"]].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: ". "),
            pentes: orientations.filter { l.pente[$0] == "true" },
            commentairePentes: l.pente["COMMENTAIRE"] ?? "",
            resume: l.textes["RESUME"] ?? [l.textes["NATUREL"], l.textes["ACCIDENTEL"]].compactMap { $0 }.joined(separator: "\n"),
            avis: l.textes["AVIS"] ?? "",
            stabilite: l.textes["STABILITE/TEXTE"] ?? "",
            qualite: l.textes["QUALITE/TEXTE"] ?? "",
            limiteSud: entier(l.enneigementAttributs["LimiteSud"]),
            limiteNord: entier(l.enneigementAttributs["LimiteNord"]),
            enneigement: l.niveaux,
            altitudeNeigeFraiche: entier(l.neigeFraicheAltitude),
            neigeFraiche: l.neige24h,
            commentaireMeteo: l.textes["METEO/COMMENTAIRE"] ?? "",
            altitudesVent: (entier(l.meteoAttributs["ALTITUDEVENT1"]), entier(l.meteoAttributs["ALTITUDEVENT2"])),
            meteo: l.echeances
        )
    }

    /// Libellé du temps sensible (table du descriptif technique).
    public static func temps(_ code: Int?) -> String {
        guard let code else { return "" }
        let t: [Int: String] = [0: "clair", 1: "peu nuageux", 2: "nuageux", 3: "très nuageux", 4: "couvert", 6: "voilé", 7: "mer de nuages",
                                32: "brouillard", 38: "brouillard givrant", 51: "pluie faible", 53: "pluie forte", 58: "pluie et neige mêlées",
                                59: "pluie verglaçante", 61: "neige faible", 63: "neige forte", 70: "averses", 71: "rares averses",
                                77: "averses de pluie et neige mêlées", 80: "averses de neige", 85: "averses de grêle", 90: "orages", 99: "orages violents"]
        return t[code] ?? ""
    }
}

/// Lecteur du XML du BRA. Ne garde que le bulletin du jour (les blocs « 7 derniers jours », BSH, sont ignorés).
private final class LecteurBRA: NSObject, XMLParserDelegate {
    var racine: [String: String]?
    var risque: [String: String] = [:]
    var pente: [String: String] = [:]
    var textes: [String: String] = [:]
    var enneigementAttributs: [String: String] = [:]
    var niveaux: [BulletinAvalanche.Enneigement] = []
    var neigeFraicheAltitude: String?
    var neige24h: [BulletinAvalanche.NeigeFraiche] = []
    var meteoAttributs: [String: String] = [:]
    var echeances: [BulletinAvalanche.Echeance] = []

    private var pile: [String] = []
    private var texte = ""

    static func date(_ s: String?) -> Date? {
        guard let s = s?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty else { return nil }
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "Europe/Paris") // heures légales françaises, sans fuseau dans le fichier [A VERIFIER]
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f.date(from: s)
    }

    private var dansBSH: Bool { pile.contains("BSH") }

    func parser(_ parser: XMLParser, didStartElement e: String, namespaceURI: String?, qualifiedName: String?, attributes a: [String: String] = [:]) {
        pile.append(e)
        texte = ""
        guard !dansBSH else { return }
        switch e {
        case "BULLETINS_NEIGE_AVALANCHE": racine = a
        case "RISQUE" where pile.contains("CARTOUCHERISQUE"): risque = a
        case "PENTE": pente = a
        case "ENNEIGEMENT": enneigementAttributs = a
        case "NIVEAU":
            if let alt = a["ALTI"].flatMap(Int.init) {
                niveaux.append(.init(altitude: alt, nord: a["N"].flatMap(Int.init) ?? 0, sud: a["S"].flatMap(Int.init) ?? 0))
            }
        case "NEIGEFRAICHE": neigeFraicheAltitude = a["ALTITUDESS"]
        case "NEIGE24H":
            if let d = Self.date(a["DATE"]) {
                neige24h.append(.init(date: d, minimum: a["SS24Min"].flatMap(Int.init) ?? 0, maximum: a["SS24Max"].flatMap(Int.init) ?? 0))
            }
        case "METEO": meteoAttributs = a
        case "ECHEANCE":
            if let d = Self.date(a["DATE"]) {
                func n(_ k: String) -> Int? { a[k].flatMap(Int.init).flatMap { $0 < 0 ? nil : $0 } }
                func vent(_ ff: String, _ dd: String) -> String {
                    guard let f = a[ff].flatMap(Int.init) else { return "" }
                    let dir = (a[dd] ?? "").replacingOccurrences(of: "Vrb", with: "variable").replacingOccurrences(of: "_", with: "variable")
                    return f == 0 ? "calme" : "\(dir) \(f) km/h"
                }
                echeances.append(.init(date: d, iso0: n("ISO0"), pluieNeige: n("PLUIENEIGE"), ventBas: vent("FF1", "DD1"), ventHaut: vent("FF2", "DD2"),
                                       temps: a["TEMPSSENSIBLE"].flatMap(Int.init)))
            }
        default: break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters s: String) { texte += s }

    func parser(_ parser: XMLParser, didEndElement e: String, namespaceURI: String?, qualifiedName: String?) {
        defer { pile.removeLast() }
        guard !dansBSH else { return }
        let t = texte.trimmingCharacters(in: .whitespacesAndNewlines)
        texte = ""
        guard !t.isEmpty else { return }
        let parent = pile.dropLast().last ?? ""
        let cle = (e == "TEXTE" || e == "COMMENTAIRE") ? "\(parent)/\(e)" : e
        if textes[cle] == nil { textes[cle] = t }
    }
}
