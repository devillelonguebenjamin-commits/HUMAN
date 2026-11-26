import CoreLocation
import Foundation
import MapLibre
import SwiftUI

/// Carte hors ligne : fond OpenStreetMap (Protomaps, format PMTiles) lu sur le téléphone, sans réseau.
enum CarteHorsLigne {
    /// Dossier des ressources de la carte dans l'application (polices, style, fichiers de carte).
    static var dossier: URL? { Bundle.main.url(forResource: "Cartes", withExtension: nil) }

    /// Premier fichier .pmtiles trouvé : dans les documents de l'application (téléchargé), sinon dans l'application.
    static var fichierCarte: URL? {
        let fm = FileManager.default
        var dossiers: [URL] = []
        if let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first { dossiers.append(docs.appendingPathComponent("Cartes")) }
        if let d = dossier { dossiers.append(d) }
        for d in dossiers {
            if let f = (try? fm.contentsOfDirectory(at: d, includingPropertiesForKeys: nil))?.first(where: { $0.pathExtension == "pmtiles" }) {
                return f
            }
        }
        return nil
    }

    /// Points de secours (hôpitaux, pompiers, pharmacies, défibrillateurs...) produits par outils/extraire_points.py.
    /// Sans ce fichier, la carte s'affiche quand même, avec une couche de points vide.
    static var fichierPoints: URL {
        if let d = dossier,
           let f = (try? FileManager.default.contentsOfDirectory(at: d, includingPropertiesForKeys: nil))?
            .first(where: { $0.pathExtension == "geojson" }) {
            return f
        }
        let vide = FileManager.default.temporaryDirectory.appendingPathComponent("points-vides.geojson")
        try? #"{"type":"FeatureCollection","features":[]}"#.write(to: vide, atomically: true, encoding: .utf8)
        return vide
    }

    /// Écrit le style de la carte avec les chemins de ce téléphone, et renvoie son adresse.
    static func styleLocal() -> URL? {
        guard let dossier, let carte = fichierCarte,
              let modele = try? String(contentsOf: dossier.appendingPathComponent("style-modele.json"), encoding: .utf8)
        else { return nil }
        let glyphes = dossier.appendingPathComponent("fonts").absoluteString.replacingOccurrences(of: "%20", with: " ")
        let style = modele
            .replacingOccurrences(of: "__PMTILES__", with: carte.absoluteString)
            .replacingOccurrences(of: "__POINTS__", with: fichierPoints.absoluteString)
            .replacingOccurrences(of: "__GLYPHES__", with: glyphes.hasSuffix("/") ? String(glyphes.dropLast()) : glyphes)
        let sortie = FileManager.default.temporaryDirectory.appendingPathComponent("style-sijamais.json")
        do {
            try style.write(to: sortie, atomically: true, encoding: .utf8)
            return sortie
        } catch {
            return nil
        }
    }
}

/// La carte MapLibre, intégrée à SwiftUI.
struct CarteMapLibre: UIViewRepresentable {
    let styleURL: URL
    var centre = CLLocationCoordinate2D(latitude: 47.2866, longitude: -2.3920) // La Baule-Escoublac
    var zoom: Double = 12

    func makeUIView(context: Context) -> MLNMapView {
        let carte = MLNMapView(frame: .zero, styleURL: styleURL)
        carte.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carte.setCenter(centre, zoomLevel: zoom, animated: false)
        carte.showsUserLocation = true
        carte.compassView.compassVisibility = .adaptive
        carte.minimumZoomLevel = 6
        carte.maximumZoomLevel = 17
        return carte
    }

    func updateUIView(_ carte: MLNMapView, context: Context) {}
}
