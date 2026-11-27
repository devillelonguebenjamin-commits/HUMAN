import ActivityKit
import Foundation

/// Compte à rebours du retour de randonnée (Live Activity) : écran verrouillé et Dynamic Island.
/// Partagé entre l'application et l'extension de widgets. Rien n'est envoyé : tout se passe sur l'iPhone.
struct RetourAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// Heure de retour prévue.
        var retour: Date
        /// Prénom du proche prévenu (vide si aucun).
        var proche: String
    }

    /// Itinéraire, en une ligne.
    var itineraire: String
}
