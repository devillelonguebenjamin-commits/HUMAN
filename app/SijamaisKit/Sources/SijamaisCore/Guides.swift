import Foundation

/// Fichier des guides (contenus/guides/guides_v1.1.json), embarqué dans l'application.
public struct GuidesFile: Decodable, Sendable {
    public let meta: Meta
    public let categories: [Category]
    public let guides: [Guide]

    public struct Meta: Decodable, Sendable {
        public let version: String
        public let date: String
        public let avertissement: String
        public let sources: [String: Source]
    }
}

public struct Source: Decodable, Sendable, Hashable {
    public let titre: String
    public let editeur: String
    public let date: String?
    public let url: String?
    public let type: String

    public var estOfficielle: Bool { type == "officiel" }
}

public struct Category: Decodable, Sendable, Hashable, Identifiable {
    public let id: String
    public let titre: String
    public let desc: String
    public let icone: String
}

public enum Niveau: String, Decodable, Sendable {
    case officiel
    case pratique
}

public struct Relecture: Decodable, Sendable, Hashable {
    public let statut: String
    public let nom: String?
    public let qualite: String?
    public let date: String?
}

public struct Guide: Decodable, Sendable, Identifiable, Hashable {
    public let id: String
    public let cat: String
    public let titre: String
    public let resume: String
    public let duree: String
    public let prioritaire: Bool
    public let sensible: Bool
    public let niveau: Niveau
    public let version: String
    public let maj: String
    public let relecture: Relecture
    public let aVerifier: [String]
    public let sources: [String]
    public let blocs: [Block]

    enum CodingKeys: String, CodingKey {
        case id, cat, titre, resume, duree, prioritaire, sensible, niveau, version, maj, relecture, sources, blocs
        case aVerifier = "a_verifier"
    }

    public static func == (a: Guide, b: Guide) -> Bool { a.id == b.id }
    public func hash(into h: inout Hasher) { h.combine(id) }

    /// Étapes du premier bloc « étapes », affichées telles quelles pour les sujets de santé.
    public var premieresEtapes: [String] {
        for b in blocs { if case let .steps(_, items) = b { return items } }
        return []
    }

    /// Schémas du guide, dans l'ordre.
    public var schemas: [Schema] {
        blocs.compactMap { if case let .schema(s) = $0 { return s } else { return nil } }
    }
}

public struct Schema: Decodable, Sendable, Hashable {
    public let fichier: String
    public let titre: String
    public let alt: String
    public let relectureSecours: Bool

    enum CodingKeys: String, CodingKey {
        case fichier, titre, alt
        case relectureSecours = "relecture_secours"
    }

    /// Nom de l'image dans le catalogue de l'application (fichier sans extension).
    public var nomImage: String { fichier.replacingOccurrences(of: ".svg", with: "") }
}

public struct NumeroUrgence: Decodable, Sendable, Hashable {
    public let n: String
    public let label: String
    public let desc: String
}

/// Un bloc de contenu. Le champ « t » du JSON indique son type.
public enum Block: Decodable, Sendable, Hashable {
    case text(titre: String?, body: String)
    case alert(body: String)
    case tip(titre: String?, body: String)
    case steps(titre: String?, items: [String])
    case list(titre: String?, items: [String])
    case risk(titre: String, items: [String])
    case check(id: String, titre: String?, items: [String])
    case keyValue(titre: String?, items: [[String]])
    case numbers(titre: String?, items: [NumeroUrgence])
    case plant(titre: String, items: [[String]])
    case doDont(titre: String?, dont: [String])
    case form(id: String, titre: String?, fields: [String])
    case calc(titre: String?, body: String, parPersonne: Int, unite: String)
    case schema(Schema)

    enum K: String, CodingKey {
        case t, titre, body, items, id, fields, dont, parPersonne, unite
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: K.self)
        let t = try c.decode(String.self, forKey: .t)
        let titre = try c.decodeIfPresent(String.self, forKey: .titre)
        switch t {
        case "text": self = .text(titre: titre, body: try c.decode(String.self, forKey: .body))
        case "alert": self = .alert(body: try c.decode(String.self, forKey: .body))
        case "tip": self = .tip(titre: titre, body: try c.decode(String.self, forKey: .body))
        case "steps": self = .steps(titre: titre, items: try c.decode([String].self, forKey: .items))
        case "list": self = .list(titre: titre, items: try c.decode([String].self, forKey: .items))
        case "risk": self = .risk(titre: titre ?? "", items: try c.decode([String].self, forKey: .items))
        case "check": self = .check(id: try c.decode(String.self, forKey: .id), titre: titre, items: try c.decode([String].self, forKey: .items))
        case "kv": self = .keyValue(titre: titre, items: try c.decode([[String]].self, forKey: .items))
        case "numbers": self = .numbers(titre: titre, items: try c.decode([NumeroUrgence].self, forKey: .items))
        case "plant": self = .plant(titre: titre ?? "", items: try c.decode([[String]].self, forKey: .items))
        case "dodont": self = .doDont(titre: titre, dont: try c.decodeIfPresent([String].self, forKey: .dont) ?? [])
        case "form": self = .form(id: try c.decode(String.self, forKey: .id), titre: titre, fields: try c.decode([String].self, forKey: .fields))
        case "calc": self = .calc(titre: titre, body: try c.decode(String.self, forKey: .body), parPersonne: try c.decode(Int.self, forKey: .parPersonne), unite: try c.decode(String.self, forKey: .unite))
        case "schema": self = .schema(try Schema(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(forKey: .t, in: c, debugDescription: "Type de bloc inconnu : \(t)")
        }
    }

    /// Textes du bloc, pour la recherche (mêmes règles que la maquette).
    var textesRecherche: [String] {
        switch self {
        case let .text(_, body), let .alert(body), let .tip(_, body), let .calc(_, body, _, _): return [body]
        case let .steps(_, items), let .list(_, items), let .risk(_, items), let .check(_, _, items): return items
        case let .keyValue(_, items), let .plant(_, items): return items.map { $0.joined(separator: " : ") }
        case let .numbers(_, items): return items.map { "\($0.n) \($0.label) : \($0.desc)" }
        case let .doDont(_, dont): return dont
        case .form, .schema: return []
        }
    }

    var titreBloc: String {
        switch self {
        case let .text(t, _), let .tip(t, _), let .steps(t, _), let .list(t, _), let .check(_, t, _),
             let .keyValue(t, _), let .numbers(t, _), let .doDont(t, _), let .form(_, t, _), let .calc(t, _, _, _):
            return t ?? ""
        case let .risk(t, _), let .plant(t, _): return t
        case .alert, .schema: return ""
        }
    }
}

/// Bibliothèque des guides chargée en mémoire.
public final class GuideLibrary: Sendable {
    public let fichier: GuidesFile
    private let parId: [String: Guide]

    public init(data: Data) throws {
        fichier = try JSONDecoder().decode(GuidesFile.self, from: data)
        parId = Dictionary(uniqueKeysWithValues: fichier.guides.map { ($0.id, $0) })
    }

    public convenience init(url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    public var guides: [Guide] { fichier.guides }
    public var categories: [Category] { fichier.categories }

    public func guide(_ id: String) -> Guide? { parId[id] }

    public func guides(categorie: String) -> [Guide] {
        fichier.guides.filter { $0.cat == categorie }
    }

    public func source(_ id: String) -> Source? { fichier.meta.sources[id] }
}
