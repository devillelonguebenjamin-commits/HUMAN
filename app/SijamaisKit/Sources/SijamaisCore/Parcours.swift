import Foundation

/// Parcours guidé de l'assistant (demande de Benjamin du 27/11/2026, après des essais en famille) :
/// des questions à choix mènent à la bonne consigne, sans dépendre des mots de la personne.
/// Chaque fin de parcours envoie à l'assistant une phrase que le triage comprend sans ambiguïté.
public struct Parcours: Decodable, Sendable {
    public struct Attendu: Decodable, Sendable, Hashable {
        public let guide: String?
        public let mode: String
    }

    public struct Option: Decodable, Sendable, Hashable, Identifiable {
        public let libelle: String
        public let symbole: String?
        /// Question suivante du parcours, ou nil pour une fin de parcours.
        public let suivant: String?
        /// Phrase envoyée à l'assistant en fin de parcours.
        public let question: String?
        /// Résultat vérifié par les tests (guide et mode de réponse).
        public let attendu: Attendu?
        public var id: String { libelle + (suivant ?? question ?? "") }
    }

    public struct Noeud: Decodable, Sendable, Hashable, Identifiable {
        public let id: String
        public let question: String
        public let options: [Option]
    }

    public let version: String
    public let racine: String
    public let noeuds: [Noeud]

    public init(url: URL) throws {
        self = try JSONDecoder().decode(Parcours.self, from: Data(contentsOf: url))
    }

    public func noeud(_ id: String) -> Noeud? { noeuds.first { $0.id == id } }
    public var depart: Noeud? { noeud(racine) }
}
