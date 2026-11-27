import Foundation
import Security

/// Petit coffre chiffré (trousseau de l'iPhone), pour les données sensibles de l'enfant :
/// téléphone des parents, allergies. Jamais envoyé, jamais sauvegardé hors de l'appareil.
enum Coffre {
    private static let service = "fr.sijamais.app.coffre"

    static func lire(_ cle: String) -> String? {
        let requete: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: cle,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var resultat: AnyObject?
        guard SecItemCopyMatching(requete as CFDictionary, &resultat) == errSecSuccess, let d = resultat as? Data else { return nil }
        return String(data: d, encoding: .utf8)
    }

    static func ecrire(_ cle: String, _ valeur: String) {
        let base: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: cle,
        ]
        SecItemDelete(base as CFDictionary)
        var ajout = base
        ajout[kSecValueData as String] = Data(valeur.utf8)
        // Lisible seulement quand l'iPhone a été déverrouillé une fois, et jamais copié vers un autre appareil.
        ajout[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(ajout as CFDictionary, nil)
    }
}
