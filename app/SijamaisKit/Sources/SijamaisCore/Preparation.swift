import Foundation

/// Foyer déclaré à la prise en main : sert à calculer le kit et le stock d'eau.
public struct Foyer: Codable, Sendable, Equatable {
    public var adultes: Int
    public var enfants: Int
    public var personnesFragiles: Int
    public var animaux: Int

    public init(adultes: Int = 2, enfants: Int = 0, personnesFragiles: Int = 0, animaux: Int = 0) {
        self.adultes = adultes
        self.enfants = enfants
        self.personnesFragiles = personnesFragiles
        self.animaux = animaux
    }

    public var personnes: Int { max(1, adultes + enfants + personnesFragiles) }

    /// Litres d'eau à stocker pour un nombre de litres par personne (6 L pour 72 heures, guide officiel).
    public func eau(litresParPersonne: Int) -> Int { personnes * litresParPersonne }
}

/// Cases cochées dans les listes des guides (kit, plan d'évacuation...), par identifiant de liste.
public struct EtatListes: Codable, Sendable, Equatable {
    public private(set) var cochees: [String: Set<Int>]

    public init(cochees: [String: Set<Int>] = [:]) { self.cochees = cochees }

    public func estCochee(liste: String, index: Int) -> Bool { cochees[liste]?.contains(index) ?? false }

    public mutating func basculer(liste: String, index: Int) {
        var s = cochees[liste] ?? []
        if s.contains(index) { s.remove(index) } else { s.insert(index) }
        cochees[liste] = s
    }
}

/// Score de préparation du foyer, de 0 à 100, calculé sur les listes du kit de 72 heures.
public struct ScorePreparation: Sendable, Equatable {
    public enum Niveau: String, Sendable {
        case debutant = "Débutant"
        case prevoyant = "Prévoyant"
        case pare = "Paré"
    }

    public let valeur: Int
    public let faits: Int
    public let total: Int

    public var niveau: Niveau {
        switch valeur {
        case ..<40: return .debutant
        case 40..<70: return .prevoyant
        default: return .pare
        }
    }

    /// Seuil du niveau suivant, ou nil au niveau le plus haut.
    public var prochainSeuil: Int? {
        switch niveau {
        case .debutant: return 40
        case .prevoyant: return 70
        case .pare: return nil
        }
    }

    public static func calculer(guideKit: Guide, etat: EtatListes) -> ScorePreparation {
        var total = 0, faits = 0
        for b in guideKit.blocs {
            if case let .check(id, _, items) = b {
                total += items.count
                faits += items.indices.filter { etat.estCochee(liste: id, index: $0) }.count
            }
        }
        let valeur = total == 0 ? 0 : Int((Double(faits) / Double(total) * 100).rounded())
        return ScorePreparation(valeur: valeur, faits: faits, total: total)
    }
}
