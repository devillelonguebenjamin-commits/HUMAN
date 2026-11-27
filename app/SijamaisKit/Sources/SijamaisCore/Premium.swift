import Foundation

/// Offre premium de SIJAMAIS (décisions du journal : prix validés ; tout ce qui protège reste gratuit).
/// Le paiement passe par Apple (StoreKit 2, dans l'application) ; ce fichier décrit l'offre, sans dépendre d'Apple.
public enum OffrePremium {
    public struct Offre: Sendable, Hashable, Identifiable {
        public let id: String
        public let titre: String
        /// Prix de référence (le prix affiché vient d'Apple, selon le pays).
        public let prix: String
        public let periode: String
        /// Partage familial d'Apple : jusqu'à 6 personnes du foyer.
        public let famille: Bool
    }

    /// Les 4 abonnements, du plus complet au plus simple (ordre du groupe d'abonnement chez Apple).
    public static let offres: [Offre] = [
        Offre(id: "fr.sijamais.premium.famille.annuel", titre: "Famille, à l'année", prix: "44,99 €", periode: "an", famille: true),
        Offre(id: "fr.sijamais.premium.famille.mensuel", titre: "Famille, au mois", prix: "5,99 €", periode: "mois", famille: true),
        Offre(id: "fr.sijamais.premium.annuel", titre: "Individuel, à l'année", prix: "29,99 €", periode: "an", famille: false),
        Offre(id: "fr.sijamais.premium.mensuel", titre: "Individuel, au mois", prix: "3,99 €", periode: "mois", famille: false),
    ]

    public static var identifiants: [String] { offres.map(\.id) }

    public static func offre(_ id: String) -> Offre? { offres.first { $0.id == id } }

    /// Rang d'affichage d'un produit (les offres famille d'abord).
    public static func rang(_ id: String) -> Int { offres.firstIndex { $0.id == id } ?? offres.count }

    public struct Univers: Sendable, Hashable, Identifiable {
        public let id: String
        public let titre: String
        public let resume: String
        public let symbole: String
        /// Vrai si l'univers est dans l'application ; sinon « bientôt disponible ».
        public let disponible: Bool
        public let apports: [String]
    }

    public static let univers: [Univers] = [
        Univers(id: "enfants", titre: "Espace enfants", resume: "Apprendre à alerter et à se protéger, en jouant", symbole: "figure.2.and.child.holdinghands", disponible: true,
                apports: ["11 modules de jeu en plus des modules gratuits", "Deux tranches d'âge : 6 à 10 ans et 10 à 14 ans", "Badges et suivi par le parent"]),
        Univers(id: "randonnee", titre: "Randonnée et montagne", resume: "Partir préparé, être retrouvé", symbole: "mountain.2.fill", disponible: true,
                apports: ["Fiche de sortie envoyée à un proche", "Compte à rebours du retour, avec rappel si vous tardez", "Bientôt : bulletin avalanche du massif, carte de France entière hors ligne"]),
        Univers(id: "voyage", titre: "Voyage à l'étranger", resume: "Se faire comprendre et retrouver l'ambassade", symbole: "airplane", disponible: false,
                apports: ["Phrases d'urgence à montrer, dans la langue du pays", "Dossier de voyage hors ligne, protégé par Face ID", "Ambassades et hôpitaux sur la carte"]),
        Univers(id: "mer", titre: "Navigation en mer", resume: "Le bon matériel et le bon message", symbole: "sailboat.fill", disponible: false,
                apports: ["« Mon bateau » : le matériel obligatoire à cocher", "Message MAYDAY prérempli", "Homme à la mer : fiche et chronomètre"]),
    ]

    /// Ce qui reste gratuit, toujours : tout ce qui protège.
    public static let toujoursGratuit: [String] = [
        "Les 46 guides et l'assistant",
        "L'écran Urgence et les numéros d'urgence",
        "La carte hors ligne et les points de secours",
        "Le plan familial et la carte d'urgence",
        "« J'ai besoin d'aide » et les modules qui protègent, dans l'Espace enfants",
        "« Alerter les secours en montagne » : position GPS et message prêt à lire",
    ]

    /// Un module de l'Espace enfants est ouvert s'il est gratuit, ou si le foyer est abonné.
    public static func moduleOuvert(_ m: EspaceEnfants.Module, abonne: Bool) -> Bool { m.gratuit || abonne }
}
