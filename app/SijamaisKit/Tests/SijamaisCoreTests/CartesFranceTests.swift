import Foundation
import XCTest
@testable import SijamaisCore

final class CartesFranceTests: XCTestCase {
    let cartes = CartesFrance.integre!

    func testLesDepartements() throws {
        XCTAssertEqual(cartes.departements.count, 101)
        XCTAssertEqual(cartes.regions.count, 14)
        XCTAssertEqual(cartes.regions.last, "Outre-mer")
        XCTAssertEqual(cartes.departement("44")?.nom, "Loire-Atlantique")
        XCTAssertEqual(Set(cartes.departements.map(\.code)).count, 101)
        for d in cartes.departements { XCTAssertTrue(d.cadre[0] < d.cadre[2] && d.cadre[1] < d.cadre[3], d.code) }
    }

    /// Le département se retrouve à partir d'une position (La Baule, Brest, Ajaccio, Pointe-à-Pitre).
    func testDepartementDUnePosition() {
        XCTAssertEqual(cartes.departement(latitude: 47.2866, longitude: -2.392)?.code, "44")
        XCTAssertEqual(cartes.departement(latitude: 48.39, longitude: -4.49)?.code, "29")
        XCTAssertEqual(cartes.departement(latitude: 41.92, longitude: 8.74)?.code, "2A")
        XCTAssertEqual(cartes.departement(latitude: 16.24, longitude: -61.53)?.code, "971")
    }

    func testRegleDAcces() {
        XCTAssertTrue(CartesFrance.peutTelecharger("44", principal: "44", abonne: false))
        XCTAssertFalse(CartesFrance.peutTelecharger("29", principal: "44", abonne: false))
        XCTAssertTrue(CartesFrance.peutTelecharger("29", principal: "44", abonne: true))
        XCTAssertNil(cartes.adresse("44"), "pas d'hébergement tant que l'adresse est vide")
    }

    func testCompositionDuStyle() throws {
        let modele = try Data(contentsOf: Bundle.module.url(forResource: "style-modele", withExtension: "json")!)
        let d = try StyleCarte.composer(modele: modele, vueEnsemble: URL(fileURLWithPath: "/c/france.pmtiles"),
                                        departements: [("44", URL(fileURLWithPath: "/c/44.pmtiles")), ("29", URL(fileURLWithPath: "/c/29.pmtiles"))],
                                        points: URL(fileURLWithPath: "/c/points.geojson"), glyphes: "file:///fonts")
        let s = try XCTUnwrap(try JSONSerialization.jsonObject(with: d) as? [String: Any])
        let sources = try XCTUnwrap(s["sources"] as? [String: Any])
        XCTAssertEqual(Set(sources.keys), ["vue", "fond-44", "fond-29", "secours"])
        XCTAssertEqual((sources["fond-44"] as? [String: Any])?["url"] as? String, "pmtiles://file:///c/44.pmtiles")
        let couches = try XCTUnwrap(s["layers"] as? [[String: Any]])
        let ids = couches.compactMap { $0["id"] as? String }
        XCTAssertEqual(ids.first, "ocean")
        XCTAssertEqual(ids.last, "secours-noms", "les points de secours restent au-dessus")
        XCTAssertEqual(ids.count, 1 + 24 * 3 + 4)
        let vueNoms = try XCTUnwrap(couches.first { $0["id"] as? String == "vue-noms-communes" })
        XCTAssertEqual(vueNoms["maxzoom"] as? Int, 9)
        let depNoms = try XCTUnwrap(couches.first { $0["id"] as? String == "44-noms-communes" })
        XCTAssertEqual(depNoms["minzoom"] as? Double, 9)
        XCTAssertEqual(s["glyphs"] as? String, "file:///fonts/{fontstack}/{range}.pbf")
    }
}
