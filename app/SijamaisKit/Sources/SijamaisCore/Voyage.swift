import Foundation

/// Mode Voyage (28/11/2026) : numéros d'urgence par pays, phrases à montrer, liste de départ, dossier de voyage.
/// Gratuit : ce qui protège (numéros, phrases vitales, inscription Ariane). Premium : phrases pratiques,
/// liste de départ complète, dossier de voyage chiffré.
public struct Voyage: Decodable, Sendable {
    public struct Langue: Decodable, Sendable, Hashable, Identifiable {
        public let code: String
        public let nom: String
        public let autonyme: String
        /// Faux tant qu'un locuteur natif n'a pas relu les traductions.
        public let relu: Bool
        public var id: String { code }
        /// L'arabe s'écrit de droite à gauche.
        public var droiteAGauche: Bool { code == "ar" }
    }

    public struct Phrase: Decodable, Sendable, Hashable, Identifiable {
        public let id: String
        public let gratuit: Bool
        public let fr: String
        public let traductions: [String: String]
    }

    public struct Numero: Decodable, Sendable, Hashable {
        public let service: String
        public let numero: String
        public let verifie: Bool
    }

    public struct Pays: Decodable, Sendable, Hashable, Identifiable {
        public let code: String
        public let nom: String
        public let zone: String
        public let langue: String?
        public let numeros: [Numero]
        public let source: String
        public var id: String { code }
        public var toutVerifie: Bool { numeros.allSatisfy(\.verifie) }
        /// Le numéro à composer en premier (le premier de la liste).
        public var principal: Numero? { numeros.first }
        /// Drapeau, à partir du code ISO du pays.
        public var drapeau: String {
            code.uppercased().unicodeScalars.compactMap { UnicodeScalar(127_397 + $0.value) }.map { String($0) }.joined()
        }
    }

    public struct Depart: Decodable, Sendable, Hashable, Identifiable {
        public let id: String
        public let gratuit: Bool
        public let titre: String
        public let detail: String
    }

    public let version: String
    public let avertissement: String
    public let langues: [Langue]
    public let phrases: [Phrase]
    public let pays: [Pays]
    public let depart: [Depart]

    public static let integre: Voyage? = {
        guard let u = Bundle.module.url(forResource: "voyage", withExtension: "json"), let d = try? Data(contentsOf: u) else { return nil }
        return try? JSONDecoder().decode(Voyage.self, from: d)
    }()

    public static let zones = ["Union européenne", "Europe", "Afrique", "Amériques", "Asie", "Océanie"]

    public func pays(_ code: String) -> Pays? { pays.first { $0.code == code } }
    public func langue(_ code: String?) -> Langue? { langues.first { $0.code == code } }

    /// Phrases accessibles : les vitales pour tous, toutes avec l'abonnement.
    public func phrases(abonne: Bool) -> [Phrase] { phrases.filter { $0.gratuit || abonne } }

    /// Recherche d'un pays par son nom, sans tenir compte des accents ni des majuscules.
    public func chercher(_ texte: String) -> [Pays] {
        let t = texte.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "fr_FR")).trimmingCharacters(in: .whitespaces)
        guard !t.isEmpty else { return pays }
        return pays.filter { $0.nom.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "fr_FR")).contains(t) }
    }
}

/// Dossier de voyage : gardé chiffré dans le trousseau de l'iPhone, ouvert avec Face ID (premium).
public struct DossierVoyage: Codable, Sendable, Equatable {
    public var destination = ""
    public var dates = ""
    public var hebergement = ""
    public var passeport = ""
    public var assuranceNom = ""
    public var assuranceContrat = ""
    public var assuranceTelephone = ""
    public var oppositionCarte = ""
    public var groupeSanguin = ""
    public var allergies = ""
    public var traitements = ""
    public var contactNom = ""
    public var contactTelephone = ""
    public var notes = ""

    public init() {}

    /// Lecture tolérante : un champ absent (ancienne version) reste vide.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        func v(_ k: CodingKeys) -> String { (try? c.decode(String.self, forKey: k)) ?? "" }
        destination = v(.destination); dates = v(.dates); hebergement = v(.hebergement); passeport = v(.passeport)
        assuranceNom = v(.assuranceNom); assuranceContrat = v(.assuranceContrat); assuranceTelephone = v(.assuranceTelephone)
        oppositionCarte = v(.oppositionCarte); groupeSanguin = v(.groupeSanguin); allergies = v(.allergies); traitements = v(.traitements)
        contactNom = v(.contactNom); contactTelephone = v(.contactTelephone); notes = v(.notes)
    }

    public var estVide: Bool { self == DossierVoyage() }

    /// Fiche santé à montrer à un soignant, traduite si la langue est connue.
    public func ficheSante(phrases: [Voyage.Phrase], langue: String?) -> [(fr: String, traduction: String?)] {
        func tr(_ id: String) -> String? { langue.flatMap { l in phrases.first { $0.id == id }?.traductions[l] } }
        var l: [(String, String?)] = []
        if !allergies.isEmpty { l.append(("Allergies : \(allergies)", tr("allergie"))) }
        if !traitements.isEmpty { l.append(("Traitements : \(traitements)", tr("medicament"))) }
        if !groupeSanguin.isEmpty { l.append(("Groupe sanguin : \(groupeSanguin)", nil)) }
        if !contactNom.isEmpty || !contactTelephone.isEmpty { l.append(("Contact en France : \(contactNom) \(contactTelephone)".trimmingCharacters(in: .whitespaces), nil)) }
        return l.map { (fr: $0.0, traduction: $0.1) }
    }
}
