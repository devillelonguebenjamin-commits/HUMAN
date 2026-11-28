import Foundation

/// Mode Randonnée et montagne (27/11/2026, priorité 2 de 15_premium_rando_mer_voyage_kids.md).
/// Sources : PGHM des Hautes-Alpes et FFME (alerter : le 112, préparer nom, lieu, victimes, blessures, météo,
/// économiser la batterie) ; ministère des Sports (prévenir un proche de son itinéraire et de son heure de retour).

/// Coordonnées GPS, lisibles au téléphone par les secours.
public struct Coordonnees: Sendable, Equatable, Codable {
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double?

    public init(latitude: Double, longitude: Double, altitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }

    /// Degrés décimaux, 5 décimales (environ un mètre) : « 45.12345, 6.12345 ».
    public var decimal: String {
        String(format: "%.5f, %.5f", locale: Locale(identifier: "en_US_POSIX"), latitude, longitude)
    }

    /// Degrés, minutes, secondes : « 45° 7' 24.4" N, 6° 7' 24.4" E ».
    public var dms: String {
        "\(Self.dms(latitude, positif: "N", negatif: "S")), \(Self.dms(longitude, positif: "E", negatif: "O"))"
    }

    static func dms(_ v: Double, positif: String, negatif: String) -> String {
        let a = abs(v)
        var d = Int(a)
        var m = Int((a - Double(d)) * 60)
        var s = ((a - Double(d)) * 60 - Double(m)) * 60
        s = (s * 10).rounded() / 10
        if s >= 60 { s -= 60; m += 1 }
        if m >= 60 { m -= 60; d += 1 }
        return String(format: "%d° %d' %.1f\" %@", locale: Locale(identifier: "en_US_POSIX"), d, m, s, v >= 0 ? positif : negatif)
    }
}

/// Le message à lire au 112, dans l'ordre demandé par les secours de montagne.
public enum MessageAlerte {
    public static let conseils = [
        "Appelez le 112 : c'est le numéro des secours en montagne. Il fonctionne même téléphone verrouillé.",
        "Restez au même endroit si vous le pouvez, et gardez le téléphone allumé : les secours peuvent rappeler.",
        "Économisez la batterie : luminosité au minimum, pas d'autre appel.",
    ]

    public static func lignes(nom: String, coordonnees: Coordonnees?, lieu: String, victimes: Int, blessures: String, meteo: String) -> [String] {
        var l: [String] = []
        let n = nom.trimmingCharacters(in: .whitespaces)
        l.append(n.isEmpty ? "Je demande les secours en montagne." : "Je m'appelle \(n). Je demande les secours en montagne.")
        if let c = coordonnees {
            var p = "Ma position GPS : \(c.decimal), soit \(c.dms)"
            if let alt = c.altitude { p += ", altitude \(Int(alt.rounded())) mètres" }
            l.append(p + ".")
        }
        let li = lieu.trimmingCharacters(in: .whitespaces)
        if !li.isEmpty { l.append("Lieu : \(li).") }
        l.append(victimes <= 1 ? "Une personne a besoin d'aide." : "\(victimes) personnes ont besoin d'aide.")
        let b = blessures.trimmingCharacters(in: .whitespaces)
        if !b.isEmpty { l.append("Ce qui se passe : \(b).") }
        let m = meteo.trimmingCharacters(in: .whitespaces)
        if !m.isEmpty { l.append("Météo sur place : \(m).") }
        return l
    }
}

/// Fiche de sortie : ce qu'un proche doit savoir avant le départ (premium).
public struct FicheSortie: Codable, Sendable, Equatable {
    public var itineraire: String
    public var depart: Date
    public var retour: Date
    public var participants: Int
    public var procheNom: String
    public var procheTelephone: String
    public var vehicule: String
    /// Vrai une fois la sortie commencée (« Je pars ») ; faux après « Je suis rentré ».
    public var enCours: Bool

    public init(itineraire: String = "", depart: Date = Date(), retour: Date = Date().addingTimeInterval(4 * 3600), participants: Int = 1,
                procheNom: String = "", procheTelephone: String = "", vehicule: String = "", enCours: Bool = false) {
        self.itineraire = itineraire
        self.depart = depart
        self.retour = retour
        self.participants = participants
        self.procheNom = procheNom
        self.procheTelephone = procheTelephone
        self.vehicule = vehicule
        self.enCours = enCours
    }

    public enum Etat: Equatable, Sendable {
        case preparation
        case enCours(minutesRestantes: Int)
        case enRetard(minutes: Int)
    }

    public func etat(maintenant: Date = Date()) -> Etat {
        guard enCours else { return .preparation }
        let ecart = Int((retour.timeIntervalSince(maintenant) / 60).rounded(.down))
        return ecart >= 0 ? .enCours(minutesRestantes: ecart) : .enRetard(minutes: -ecart)
    }

    /// Le message à envoyer au proche avant de partir.
    /// `avalanche` : la ligne du bulletin du massif (premium), ajoutée avant la consigne d'alerte.
    public func message(fuseau: TimeZone = .current, avalanche: String? = nil) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.timeZone = fuseau
        f.dateFormat = "EEEE d MMMM 'à' HH'h'mm"
        var l = ["Je pars en randonnée.", "Itinéraire : \(itineraire.isEmpty ? "non précisé" : itineraire).",
                 "Départ : \(f.string(from: depart)).", "Retour prévu : \(f.string(from: retour))."]
        l.append(participants <= 1 ? "Je pars seul(e)." : "Nous sommes \(participants).")
        if !vehicule.isEmpty { l.append("Véhicule garé : \(vehicule).") }
        if let avalanche, !avalanche.isEmpty { l.append(avalanche) }
        l.append("Si tu n'as pas de nouvelles de moi une heure après l'heure de retour, appelle le 112 et donne-leur ce message.")
        return l.joined(separator: "\n")
    }

    /// Téléphone du proche, réduit aux chiffres (et au +), pour un lien d'appel ou de SMS.
    public var telephoneNumerique: String { procheTelephone.filter { $0.isNumber || $0 == "+" } }
}
