import Foundation
import XCTest
@testable import SijamaisCore

final class TraceGPXTests: XCTestCase {
    /// Une trace de 3 points, comme l'exportent Komoot ou Visorando (avec espace de noms).
    let exemple = """
    <?xml version="1.0" encoding="UTF-8"?>
    <gpx version="1.1" creator="komoot" xmlns="http://www.topografix.com/GPX/1/1">
      <metadata><name>Métadonnées</name></metadata>
      <trk><name>Lac Blanc &amp; retour</name><trkseg>
        <trkpt lat="45.0000" lon="6.0000"><ele>1000</ele></trkpt>
        <trkpt lat="45.0100" lon="6.0000"><ele>1300</ele></trkpt>
        <trkpt lat="45.0200" lon="6.0000"><ele>1100</ele></trkpt>
      </trkseg></trk>
    </gpx>
    """

    func testLectureEtAnalyse() throws {
        let t = try TraceGPX.lire(Data(exemple.utf8))
        XCTAssertEqual(t.points.count, 3)
        XCTAssertEqual(t.nom, "Métadonnées")
        // 2 x 0,01° de latitude, soit environ 2 224 m.
        XCTAssertEqual(t.distanceMetres, 2224, accuracy: 5)
        XCTAssertEqual(t.denivele.positif, 300, accuracy: 0.1)
        XCTAssertEqual(t.denivele.negatif, 200, accuracy: 0.1)
        XCTAssertEqual(t.altitudeMax, 1300)
        // DIN 33466 : horizontal 33,4 min ; vertical 60 + 24 = 84 min ; total 84 + 16,7 = 101 min.
        XCTAssertEqual(t.minutesDeMarche, 101)
        XCTAssertEqual(t.minutesAvecPauses, 117)
        XCTAssertTrue(t.resume.contains("2,2 km") && t.resume.contains("+300 m") && t.resume.contains("1 h 41"), t.resume)
    }

    func testLeBruitDuGPSEstIgnore() {
        let pts = [1000.0, 1001, 999, 1002, 1000, 1010].map { TraceGPX.Point(latitude: 45, longitude: 6, altitude: $0) }
        XCTAssertEqual(TraceGPX(nom: "t", points: pts).denivele.positif, 10, accuracy: 0.01)
    }

    func testAllerRetourEnGPX() throws {
        let t = try TraceGPX.lire(Data(exemple.utf8))
        let relu = try TraceGPX.lire(Data(t.versGPX().utf8))
        XCTAssertEqual(relu.points, t.points)
        XCTAssertEqual(relu.nom, t.nom)
    }

    func testItineraireSansTraceEtFichierInvalide() throws {
        let rte = "<gpx><rte><rtept lat=\"45\" lon=\"6\"/><rtept lat=\"45.1\" lon=\"6\"/></rte></gpx>"
        XCTAssertEqual(try TraceGPX.lire(Data(rte.utf8), nomParDefaut: "Itinéraire").nom, "Itinéraire")
        XCTAssertThrowsError(try TraceGPX.lire(Data("pas du xml <".utf8)))
        XCTAssertThrowsError(try TraceGPX.lire(Data("<gpx></gpx>".utf8))) { XCTAssertEqual($0 as? TraceGPX.Erreur, .vide) }
    }

    func testProfilReduit() {
        let pts = (0..<1000).map { TraceGPX.Point(latitude: 45 + Double($0) * 0.0001, longitude: 6, altitude: Double($0)) }
        let p = TraceGPX(nom: "t", points: pts).profil(points: 100)
        XCTAssertEqual(p.count, 100)
        XCTAssertEqual(p.first?.altitude, 0)
        XCTAssertEqual(p.last?.altitude, 999)
    }
}
