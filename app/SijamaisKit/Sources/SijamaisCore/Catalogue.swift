import Foundation

/// Écran « S'équiper » (décision de Benjamin du 27/11/2026) : où trouver chaque article des listes des guides,
/// puis, en option, un lien affilié Amazon clairement signalé. Aucune marque : le lien ouvre une recherche.
public struct Catalogue: Decodable, Sendable {
    public struct PartenaireAmazon: Decodable, Sendable {
        /// Identifiant Amazon Partenaires (par exemple « sijamais-21 »). Vide : aucun lien n'est affiché.
        public let tag: String
        public let domaine: String
        /// Mention obligatoire, affichée en tête de l'écran dès qu'un lien existe.
        public let mention: String
    }

    public struct Article: Decodable, Sendable, Identifiable, Hashable {
        public let id: String
        public let guide: String
        public let liste: String
        public let index: Int
        public let nom: String
        public let ouTrouver: [String]
        public let rechercheAmazon: String?
        public let conseil: String?
    }

    public struct Section: Decodable, Sendable, Identifiable {
        public let id: String
        public let titre: String
        public let intro: String
        public let articles: [Article]
    }

    public let version: String
    public let introduction: String
    public let partenaireAmazon: PartenaireAmazon
    public let sections: [Section]

    public init(url: URL) throws {
        self = try JSONDecoder().decode(Catalogue.self, from: Data(contentsOf: url))
    }

    /// Vrai dès qu'un identifiant Amazon Partenaires est renseigné.
    public var liensActifs: Bool { !partenaireAmazon.tag.trimmingCharacters(in: .whitespaces).isEmpty }

    /// Lien affilié vers une recherche Amazon, ou nil (pas d'identifiant, ou article sans lien : médicaments, eau, nourriture...).
    public func lien(_ a: Article) -> URL? {
        guard liensActifs, let recherche = a.rechercheAmazon, !recherche.isEmpty else { return nil }
        var c = URLComponents()
        c.scheme = "https"
        c.host = partenaireAmazon.domaine
        c.path = "/s"
        c.queryItems = [URLQueryItem(name: "k", value: recherche), URLQueryItem(name: "tag", value: partenaireAmazon.tag)]
        return c.url
    }

    /// Le même catalogue avec un autre identifiant (tests, ou identifiant saisi plus tard).
    public func avecTag(_ tag: String) -> Catalogue {
        Catalogue(version: version, introduction: introduction,
                  partenaireAmazon: PartenaireAmazon(tag: tag, domaine: partenaireAmazon.domaine, mention: partenaireAmazon.mention), sections: sections)
    }

    init(version: String, introduction: String, partenaireAmazon: PartenaireAmazon, sections: [Section]) {
        self.version = version
        self.introduction = introduction
        self.partenaireAmazon = partenaireAmazon
        self.sections = sections
    }
}
