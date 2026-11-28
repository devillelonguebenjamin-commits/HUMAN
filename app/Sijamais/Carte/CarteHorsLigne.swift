import CoreLocation
import Foundation
import MapLibre
import SwiftUI
import SijamaisCore

/// Carte hors ligne : fond OpenStreetMap (Protomaps, format PMTiles) lu sur le téléphone, sans réseau.
enum CarteHorsLigne {
    /// Dossier des ressources de la carte dans l'application (polices, style, fichiers de carte).
    static var dossier: URL? { Bundle.main.url(forResource: "Cartes", withExtension: nil) }

    /// Vue d'ensemble de la France embarquée (zoom 0 à 8), produite par outils/construire_cartes_france.sh.
    static var vueEnsemble: URL? { dossier.map { $0.appendingPathComponent("france-vue-ensemble.pmtiles") }.flatMap { FileManager.default.fileExists(atPath: $0.path) ? $0 : nil } }

    /// Fichiers départementaux : téléchargés (Documents/Cartes/<code>.pmtiles), plus l'ancien fichier embarqué de la Loire-Atlantique.
    static func departements(telecharges: [String]) -> [(code: String, fichier: URL)] {
        var l = telecharges.map { (code: $0, fichier: GestionCartes.fichier($0)) }
        if !telecharges.contains("44"), let d = dossier {
            let ancien = d.appendingPathComponent("loire-atlantique.pmtiles")
            if FileManager.default.fileExists(atPath: ancien.path) { l.append((code: "44", fichier: ancien)) }
        }
        return l
    }

    /// Points de secours (hôpitaux, pompiers, pharmacies, défibrillateurs...) : le fichier embarqué
    /// (outils/extraire_points.py) et ceux téléchargés avec chaque département, fusionnés sans doublon.
    /// Sans aucun fichier, la carte s'affiche quand même, avec une couche de points vide.
    static func fichierPoints(telecharges: [String]) -> URL {
        var sources: [Data] = []
        if let d = dossier, let f = (try? FileManager.default.contentsOfDirectory(at: d, includingPropertiesForKeys: nil))?
            .first(where: { $0.pathExtension == "geojson" }), let donnees = try? Data(contentsOf: f) {
            sources.append(donnees)
        }
        sources += telecharges.compactMap { try? Data(contentsOf: GestionCartes.fichierPoints($0, "secours")) }
        return ecrire(PointsCarte.fusionner(sources), nom: "points")
    }

    /// Refuges, cabanes, gîtes, abris et points d'eau (Refuges.info, CC BY-SA) des départements présents ; nil s'il n'y en a pas.
    static func fichierRefuges(telecharges: [String]) -> URL? {
        let sources = telecharges.compactMap { try? Data(contentsOf: GestionCartes.fichierPoints($0, "refuges")) }
        return sources.isEmpty ? nil : ecrire(PointsCarte.fusionner(sources), nom: "refuges")
    }

    private static func ecrire(_ donnees: Data, nom: String) -> URL {
        let f = FileManager.default.temporaryDirectory.appendingPathComponent("\(nom)-\(UUID().uuidString).geojson")
        try? donnees.write(to: f)
        return f
    }

    /// Y a-t-il des refuges dans les départements présents ? (pour la légende)
    static func aDesRefuges(telecharges: [String]) -> Bool {
        telecharges.contains { FileManager.default.fileExists(atPath: GestionCartes.fichierPoints($0, "refuges").path) }
    }

    /// Compose le style avec la vue d'ensemble et les départements présents, et renvoie son adresse (nil s'il n'y a aucune carte).
    /// Les refuges et points d'eau ne s'affichent qu'avec l'abonnement (mode Randonnée).
    static func styleLocal(telecharges: [String] = [], refuges: Bool = false) -> URL? {
        let deps = departements(telecharges: telecharges)
        guard let dossier, vueEnsemble != nil || !deps.isEmpty,
              let modele = try? Data(contentsOf: dossier.appendingPathComponent("style-modele.json")) else { return nil }
        var glyphes = dossier.appendingPathComponent("fonts").absoluteString.replacingOccurrences(of: "%20", with: " ")
        if glyphes.hasSuffix("/") { glyphes.removeLast() }
        guard let style = try? StyleCarte.composer(modele: modele, vueEnsemble: vueEnsemble, departements: deps,
                                                   points: fichierPoints(telecharges: telecharges),
                                                   refuges: refuges ? fichierRefuges(telecharges: telecharges) : nil,
                                                   glyphes: glyphes) else { return nil }
        // Un nom de fichier nouveau à chaque composition : la carte sait qu'elle doit recharger son style.
        let sortie = FileManager.default.temporaryDirectory.appendingPathComponent("style-sijamais-\(UUID().uuidString).json")
        do {
            try style.write(to: sortie)
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
        if carte.styleURL != styleURL {
            context.coordinator.styleRecharge()
            carte.styleURL = styleURL
        }
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

        /// Le style change (département ajouté ou retiré) : la trace sera redessinée au chargement.
        func styleRecharge() { styleCharge = false }

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
