import Foundation
import Observation
import SijamaisCore

/// Bulletins avalanche téléchargés depuis notre hébergement (déposés chaque soir par serveur/bulletins-avalanche),
/// gardés sur le téléphone pour être lus sans réseau. Lecture gratuite : c'est une information qui protège.
@Observable
@MainActor
final class BulletinsAvalanche {
    enum Etat: Equatable { case absent, enCours, pret, erreur(String) }

    private(set) var bulletins: [Int: BulletinAvalanche] = [:]
    private(set) var etats: [Int: Etat] = [:]

    /// Massifs suivis : mis à jour à chaque ouverture de l'écran.
    var favoris: Set<Int> { didSet { UserDefaults.standard.set(Array(favoris), forKey: "avalancheFavoris") } }
    /// Massif de la sortie prévue : sa ligne s'ajoute au message de la fiche de sortie (premium).
    var massifSortie: Int? { didSet { UserDefaults.standard.set(massifSortie, forKey: "avalancheMassifSortie") } }

    /// Dossier « bulletins/ » à la racine de l'hébergement des cartes.
    let adresse: URL?

    nonisolated static var dossier: URL {
        let d = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Bulletins", isDirectory: true)
        try? FileManager.default.createDirectory(at: d, withIntermediateDirectories: true)
        return d
    }

    nonisolated static func fichier(_ id: Int) -> URL { dossier.appendingPathComponent("BRA-\(id).xml") }

    init(adresseCartes: String?) {
        if let a = adresseCartes, !a.isEmpty, let u = URL(string: a) {
            adresse = u.deletingLastPathComponent().appendingPathComponent("bulletins", isDirectory: true)
        } else {
            adresse = nil
        }
        favoris = Set((UserDefaults.standard.array(forKey: "avalancheFavoris") as? [Int]) ?? [])
        massifSortie = UserDefaults.standard.object(forKey: "avalancheMassifSortie") as? Int
        for m in BulletinAvalanche.massifs {
            if let d = try? Data(contentsOf: Self.fichier(m.id)), let b = try? BulletinAvalanche.lire(d) {
                bulletins[m.id] = b
                etats[m.id] = .pret
            }
        }
    }

    func telecharger(_ id: Int) async {
        guard let adresse else {
            etats[id] = .erreur("Les bulletins ne sont pas encore hébergés.")
            return
        }
        etats[id] = .enCours
        do {
            var requete = URLRequest(url: adresse.appendingPathComponent("BRA-\(id).xml"))
            requete.cachePolicy = .reloadIgnoringLocalCacheData
            let (d, r) = try await URLSession.shared.data(for: requete)
            guard (r as? HTTPURLResponse)?.statusCode == 200 else {
                etats[id] = bulletins[id] == nil ? .erreur("Bulletin indisponible pour l'instant.") : .pret
                return
            }
            let b = try BulletinAvalanche.lire(d)
            try? d.write(to: Self.fichier(id), options: .atomic)
            bulletins[id] = b
            etats[id] = .pret
        } catch {
            // Sans réseau, on garde le dernier bulletin enregistré (affiché « périmé » s'il l'est).
            etats[id] = bulletins[id] == nil ? .erreur("Pas de réseau. Téléchargez le bulletin avant de partir.") : .pret
        }
    }

    /// Met à jour les massifs suivis et celui de la sortie.
    func actualiserSuivis() async {
        for id in favoris.union(massifSortie.map { [$0] } ?? []).sorted() { await telecharger(id) }
    }

    /// Ligne pour la fiche de sortie, si le bulletin du massif choisi est encore valable.
    var ligneSortie: String? {
        guard let id = massifSortie, let b = bulletins[id], !b.estPerime() else { return nil }
        return b.resumeCourt()
    }
}
