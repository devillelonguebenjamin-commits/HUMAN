import CryptoKit
import Foundation
import Observation
import SijamaisCore

/// Téléchargement des cartes départementales (Documents/Cartes/<code>.pmtiles), avec progression,
/// vérification de l'empreinte SHA-256 publiée dans le catalogue, et suppression.
/// Règle : un département gratuit (le principal), tous les autres avec l'abonnement.
@Observable
@MainActor
final class GestionCartes: NSObject, URLSessionDownloadDelegate {
    enum Etat: Equatable {
        case absent
        case enCours(Double)
        case present(Int64)
        case erreur(String)
    }

    let france: CartesFrance?
    private(set) var etats: [String: Etat] = [:]
    /// Change à chaque téléchargement ou suppression : la carte se recompose.
    private(set) var version = 0
    private var catalogue: CatalogueCartes?
    @ObservationIgnored private var taches: [Int: String] = [:]
    @ObservationIgnored private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

    var principal: String? {
        didSet { UserDefaults.standard.set(principal, forKey: "departementPrincipal") }
    }

    nonisolated static var dossier: URL {
        let d = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Cartes", isDirectory: true)
        try? FileManager.default.createDirectory(at: d, withIntermediateDirectories: true)
        return d
    }

    nonisolated static func fichier(_ code: String) -> URL { dossier.appendingPathComponent("\(code).pmtiles") }

    /// Points d'un département, téléchargés avec sa carte : "secours" (gratuit) ou "refuges" (mode Randonnée).
    nonisolated static func fichierPoints(_ code: String, _ genre: String) -> URL { dossier.appendingPathComponent("\(code)-\(genre).geojson") }

    override init() {
        france = CartesFrance.integre
        principal = UserDefaults.standard.string(forKey: "departementPrincipal")
        super.init()
        actualiser()
    }

    /// Départements présents sur le téléphone.
    var telecharges: [String] {
        (france?.departements ?? []).map(\.code).filter { if case .present = etats[$0] { return true } else { return false } }
    }

    var octetsUtilises: Int64 {
        etats.values.reduce(0) { if case let .present(o) = $1 { return $0 + o } else { return $0 } }
    }

    var hebergementPret: Bool { !(france?.adresseBase.isEmpty ?? true) }

    func actualiser() {
        for d in france?.departements ?? [] {
            if case .enCours = etats[d.code] { continue }
            let f = Self.fichier(d.code)
            if let attributs = try? FileManager.default.attributesOfItem(atPath: f.path), let taille = attributs[.size] as? NSNumber {
                etats[d.code] = .present(taille.int64Value)
            } else {
                etats[d.code] = .absent
            }
        }
    }

    func peutTelecharger(_ code: String, abonne: Bool) -> Bool {
        // Sans abonnement : un seul département à la fois, le principal (ou le premier choisi).
        CartesFrance.peutTelecharger(code, principal: principal ?? code, abonne: abonne)
            && (abonne || telecharges.allSatisfy { $0 == code })
    }

    func telecharger(_ code: String) {
        guard let url = france?.adresse(code) else {
            etats[code] = .erreur("Les cartes ne sont pas encore hébergées.")
            return
        }
        if principal == nil { principal = code }
        Task {
            if catalogue == nil, let base = france?.adresseBase, let u = URL(string: base.hasSuffix("/") ? base + "catalogue.json" : base + "/catalogue.json") {
                catalogue = try? JSONDecoder().decode(CatalogueCartes.self, from: try await URLSession.shared.data(from: u).0)
            }
            let tache = session.downloadTask(with: url)
            taches[tache.taskIdentifier] = code
            etats[code] = .enCours(0)
            tache.resume()
        }
    }

    func supprimer(_ code: String) {
        try? FileManager.default.removeItem(at: Self.fichier(code))
        for g in ["secours", "refuges"] { try? FileManager.default.removeItem(at: Self.fichierPoints(code, g)) }
        etats[code] = .absent
        version += 1
    }

    // MARK: URLSessionDownloadDelegate

    nonisolated func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        let p = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        let id = downloadTask.taskIdentifier
        Task { @MainActor in if let c = self.taches[id] { self.etats[c] = .enCours(p) } }
    }

    nonisolated func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Le fichier temporaire disparaît au retour de cette fonction : on le déplace tout de suite.
        let attente = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".pmtiles")
        try? FileManager.default.moveItem(at: location, to: attente)
        let id = downloadTask.taskIdentifier
        let statut = (downloadTask.response as? HTTPURLResponse)?.statusCode ?? 0
        Task { @MainActor in await self.terminer(id: id, fichier: attente, statut: statut) }
    }

    nonisolated func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error != nil else { return }
        let id = task.taskIdentifier
        Task { @MainActor in
            if let c = self.taches.removeValue(forKey: id) { self.etats[c] = .erreur("Téléchargement interrompu. Réessayez avec une bonne connexion.") }
        }
    }

    private func terminer(id: Int, fichier: URL, statut: Int) async {
        guard let code = taches.removeValue(forKey: id) else { return }
        guard statut == 200 else {
            try? FileManager.default.removeItem(at: fichier)
            etats[code] = .erreur("Fichier indisponible chez l'hébergeur (code \(statut)).")
            return
        }
        if let attendu = catalogue?.fichiers[code]?.sha256 {
            let obtenu = await Task.detached { Self.empreinte(fichier) }.value
            guard obtenu == attendu else {
                try? FileManager.default.removeItem(at: fichier)
                etats[code] = .erreur("Fichier abîmé pendant le téléchargement. Réessayez.")
                return
            }
        }
        let cible = Self.fichier(code)
        try? FileManager.default.removeItem(at: cible)
        do {
            try FileManager.default.moveItem(at: fichier, to: cible)
            var valeurs = URLResourceValues()
            valeurs.isExcludedFromBackup = true // inutile de saturer iCloud : la carte se retélécharge
            var c = cible
            try? c.setResourceValues(valeurs)
        } catch {
            etats[code] = .erreur("Place insuffisante sur le téléphone.")
            return
        }
        await telechargerPoints(code)
        actualiser()
        version += 1
    }

    /// Fichiers de points du département (quelques centaines de kilo-octets), vérifiés comme la carte.
    /// Un échec n'empêche pas la carte : les points seront repris au prochain téléchargement.
    private func telechargerPoints(_ code: String) async {
        guard let base = france?.adresseBase, let points = catalogue?.points?[code] else { return }
        for (genre, f) in [("secours", points.secours), ("refuges", points.refuges)] {
            guard let f, let u = URL(string: (base.hasSuffix("/") ? base : base + "/") + f.fichier),
                  let resultat = try? await URLSession.shared.data(from: u),
                  (resultat.1 as? HTTPURLResponse)?.statusCode == 200,
                  SHA256.hash(data: resultat.0).map({ String(format: "%02x", $0) }).joined() == f.sha256 else { continue }
            let cible = Self.fichierPoints(code, genre)
            try? resultat.0.write(to: cible, options: .atomic)
            var valeurs = URLResourceValues()
            valeurs.isExcludedFromBackup = true
            var c = cible
            try? c.setResourceValues(valeurs)
        }
    }

    nonisolated static func empreinte(_ url: URL) -> String {
        guard let h = try? FileHandle(forReadingFrom: url) else { return "" }
        defer { try? h.close() }
        var sha = SHA256()
        while let bloc = try? h.read(upToCount: 4 << 20), !bloc.isEmpty { sha.update(data: bloc) }
        return sha.finalize().map { String(format: "%02x", $0) }.joined()
    }
}
