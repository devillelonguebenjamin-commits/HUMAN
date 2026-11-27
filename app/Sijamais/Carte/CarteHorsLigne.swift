import CoreLocation
import Foundation
import MapLibre
import SwiftUI
import SijamaisCore

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

/// La carte MapLibre, intégrée à SwiftUI. Peut afficher une trace GPX (premium) par-dessus le fond hors ligne.
struct CarteMapLibre: UIViewRepresentable {
    let styleURL: URL
    var trace: TraceGPX? = nil
    var centre = CLLocationCoordinate2D(latitude: 47.2866, longitude: -2.3920) // La Baule-Escoublac
    var zoom: Double = 12

    func makeCoordinator() -> Coordinateur { Coordinateur() }

    func makeUIView(context: Context) -> MLNMapView {
        let carte = MLNMapView(frame: .zero, styleURL: styleURL)
        carte.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carte.setCenter(centre, zoomLevel: zoom, animated: false)
        carte.showsUserLocation = true
        carte.compassView.compassVisibility = .adaptive
        carte.minimumZoomLevel = 6
        carte.maximumZoomLevel = 17
        carte.delegate = context.coordinator
        context.coordinator.trace = trace
        return carte
    }

    func updateUIView(_ carte: MLNMapView, context: Context) {
        context.coordinator.appliquer(trace, sur: carte)
    }

    /// Dessine la trace (ligne orange balise) une fois le style chargé, et cadre la carte dessus.
    final class Coordinateur: NSObject, MLNMapViewDelegate {
        var trace: TraceGPX?
        private var styleCharge = false

        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            styleCharge = true
            dessiner(mapView)
        }

        func appliquer(_ nouvelle: TraceGPX?, sur carte: MLNMapView) {
            guard nouvelle != trace else { return }
            trace = nouvelle
            if styleCharge { dessiner(carte) }
        }

        private func dessiner(_ carte: MLNMapView) {
            guard let style = carte.style else { return }
            if let couche = style.layer(withIdentifier: "trace-ligne") { style.removeLayer(couche) }
            if let source = style.source(withIdentifier: "trace") { style.removeSource(source) }
            guard let t = trace, t.points.count > 1 else { return }
            let coords = t.points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            let ligne = MLNPolylineFeature(coordinates: coords, count: UInt(coords.count))
            let source = MLNShapeSource(identifier: "trace", shape: ligne, options: nil)
            style.addSource(source)
            let couche = MLNLineStyleLayer(identifier: "trace-ligne", source: source)
            couche.lineColor = NSExpression(forConstantValue: UIColor(red: 0xE0 / 255, green: 0x66 / 255, blue: 0x2A / 255, alpha: 1))
            couche.lineWidth = NSExpression(forConstantValue: 5)
            couche.lineCap = NSExpression(forConstantValue: "round")
            couche.lineJoin = NSExpression(forConstantValue: "round")
            style.addLayer(couche)
            let b = t.bornes
            let cadre = MLNCoordinateBounds(sw: CLLocationCoordinate2D(latitude: b.sud, longitude: b.ouest),
                                            ne: CLLocationCoordinate2D(latitude: b.nord, longitude: b.est))
            carte.setVisibleCoordinateBounds(cadre, edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 200, right: 40), animated: true, completionHandler: nil)
        }
    }
}
