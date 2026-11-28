import Foundation

/// Espace enfants (décision de Benjamin du 27/11/2026, contenu de contenus/enfants/parcours_v0.1.json) :
/// deux tranches d'âge, des modules « leçon puis quiz », l'écran « J'ai besoin d'aide » et la carte « Montrer à un adulte ».
/// Règles : aucun lien vers l'extérieur, aucun achat, aucun assistant libre, rien n'est envoyé.
public struct EspaceEnfants: Decodable, Sendable {
    public struct Meta: Decodable, Sendable {
        public let version: String
        public let avertissement: String
    }

    public struct Bouton: Decodable, Sendable, Hashable {
        public let label: String
        /// « parent » (appeler un parent), « 112 », « carte » (montrer la carte à un adulte).
        public let action: String
        public let couleur: String
    }

    public struct CarteAdulte: Decodable, Sendable {
        public let titre: String
        /// Phrase lue par l'adulte ; « {prenom} » est remplacé par le prénom de l'enfant.
        public let phrase: String
        public let champs: [String]
        public let stockage: String
    }

    public struct Aide: Decodable, Sendable {
        public let titre: String
        public let boutons: [Bouton]
        public let carteAdulte: CarteAdulte

        enum CodingKeys: String, CodingKey {
            case titre, boutons
            case carteAdulte = "carte_adulte"
        }
    }

    public struct Choix: Decodable, Sendable, Hashable {
        public let t: String
        public let juste: Bool
        public let pourquoi: String
    }

    public struct Question: Decodable, Sendable, Hashable {
        public let situation: String
        public let choix: [Choix]
    }

    public struct Module: Decodable, Sendable, Hashable, Identifiable {
        public let id: String
        public let titre: String
        public let resume: String
        public let picto: String
        public let couleur: String
        public let gratuit: Bool
        public let lecon: [String]
        public let quiz: [Question]
    }

    public struct Tranche: Decodable, Sendable, Hashable, Identifiable {
        public let id: String
        public let titre: String
        public let sousTitre: String
        public let modules: [Module]

        enum CodingKeys: String, CodingKey {
            case id, titre, modules
            case sousTitre = "sous_titre"
        }
    }

    public let meta: Meta
    public let aide: Aide
    public let tranches: [Tranche]

    public init(url: URL) throws {
        self = try JSONDecoder().decode(EspaceEnfants.self, from: Data(contentsOf: url))
    }

    /// Le contenu embarqué dans SijamaisCore.
    public static var integre: EspaceEnfants? {
        Bundle.module.url(forResource: "enfants", withExtension: "json").flatMap { try? EspaceEnfants(url: $0) }
    }

    /// La phrase de la carte « Montrer à un adulte », avec le prénom (ou sans, s'il manque).
    public func phraseCarte(prenom: String) -> String {
        let p = prenom.trimmingCharacters(in: .whitespaces)
        if p.isEmpty { return aide.carteAdulte.phrase.replacingOccurrences(of: " Je m'appelle {prenom}.", with: "") }
        return aide.carteAdulte.phrase.replacingOccurrences(of: "{prenom}", with: p)
    }
}

/// Contrôle parental (recommandé par Apple pour sortir d'un espace enfants) : une multiplication à deux chiffres.
public struct ControleParental: Sendable, Equatable {
    public let a: Int
    public let b: Int
    public var question: String { "Combien font \(a) × \(b) ?" }
    public var reponse: Int { a * b }

    public init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }

    public static func nouveau() -> ControleParental {
        ControleParental(a: Int.random(in: 6...9), b: Int.random(in: 12...19))
    }

    public func verifier(_ saisie: String) -> Bool {
        Int(saisie.trimmingCharacters(in: .whitespaces)) == reponse
    }
}
