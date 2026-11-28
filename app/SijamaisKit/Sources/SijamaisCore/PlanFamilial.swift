import Foundation

/// Parcours pas à pas du plan familial de mise en sûreté (demande de Benjamin du 27/11/2026).
/// Chaque étape remplit un champ du guide « Mon plan familial » : les mêmes clés, les mêmes réponses.
public struct PlanFamilial: Decodable, Sendable {
    public struct Choix: Decodable, Sendable, Hashable, Identifiable {
        public let libelle: String
        /// Texte enregistré ; à défaut, le libellé (passé dans le gabarit de l'étape).
        public let valeur: String?
        public let parDefaut: Bool?
        public var id: String { libelle }
    }

    public struct Etape: Decodable, Sendable, Hashable, Identifiable {
        public enum Genre: String, Decodable, Sendable { case texte, choix, risques }
        public let id: String
        public let titre: String
        public let type: Genre
        public let question: String
        public let aide: String?
        /// Clé du champ rempli (« pfms.<formulaire>.<rang> »), pour les étapes texte et choix.
        public let champ: String?
        /// Clés remplies par l'étape « risques », dans l'ordre.
        public let champs: [String]?
        public let gabarit: String?
        public let exemple: String?
        public let max: Int?
        public let choix: [Choix]

        /// Texte enregistré pour un choix.
        public func texte(pour c: Choix) -> String {
            let base = c.valeur ?? c.libelle
            guard c.valeur == nil, let g = gabarit else { return base }
            return g.replacingOccurrences(of: "{choix}", with: base)
        }

        /// Toutes les clés remplies par l'étape.
        public var cles: [String] { champs ?? (champ.map { [$0] } ?? []) }
    }

    public let version: String
    public let guide: String
    public let etapes: [Etape]

    public init(url: URL) throws {
        self = try JSONDecoder().decode(PlanFamilial.self, from: Data(contentsOf: url))
    }

    /// Le parcours embarqué dans SijamaisCore.
    public static var integre: PlanFamilial? {
        Bundle.module.url(forResource: "plan_familial", withExtension: "json").flatMap { try? PlanFamilial(url: $0) }
    }

    /// Nombre d'étapes déjà remplies, d'après les champs enregistrés.
    public func remplies(_ valeur: (String) -> String) -> Int {
        etapes.filter { e in e.cles.contains { !valeur($0).trimmingCharacters(in: .whitespaces).isEmpty } }.count
    }
}
