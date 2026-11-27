import Foundation
import XCTest
@testable import SijamaisCore

final class RandonneeTests: XCTestCase {
    func testCoordonnees() {
        let c = Coordonnees(latitude: 45.123456, longitude: -6.5, altitude: 2350.4)
        XCTAssertEqual(c.decimal, "45.12346, -6.50000")
        XCTAssertEqual(c.dms, "45° 7' 24.4\" N, 6° 30' 0.0\" O")
        XCTAssertEqual(Coordonnees.dms(10.99999999, positif: "N", negatif: "S"), "11° 0' 0.0\" N")
    }

    /// L'ordre demandé par les secours : qui, où, combien, quoi, météo.
    func testMessageAlerteDansLOrdre() {
        let l = MessageAlerte.lignes(nom: "Benjamin", coordonnees: Coordonnees(latitude: 45, longitude: 6, altitude: 1800), lieu: "col du Galibier",
                                     victimes: 2, blessures: "une cheville tordue", meteo: "brouillard")
        XCTAssertEqual(l.count, 6)
        XCTAssertTrue(l[0].contains("Benjamin"))
        XCTAssertTrue(l[1].contains("45.00000, 6.00000") && l[1].contains("1800 mètres"))
        XCTAssertTrue(l[2].contains("Galibier"))
        XCTAssertTrue(l[3].hasPrefix("2 personnes"))
        XCTAssertTrue(l[5].contains("brouillard"))
        XCTAssertEqual(MessageAlerte.lignes(nom: "", coordonnees: nil, lieu: "", victimes: 1, blessures: "", meteo: "").count, 2)
    }

    func testFicheDeSortie() {
        let depart = Date(timeIntervalSince1970: 1_800_000_000)
        var f = FicheSortie(itineraire: "Lac Blanc", depart: depart, retour: depart.addingTimeInterval(3 * 3600), participants: 2,
                            procheNom: "Marie", procheTelephone: "06 12 34 56 78")
        XCTAssertEqual(f.etat(maintenant: depart), .preparation)
        f.enCours = true
        XCTAssertEqual(f.etat(maintenant: depart.addingTimeInterval(3600)), .enCours(minutesRestantes: 120))
        XCTAssertEqual(f.etat(maintenant: depart.addingTimeInterval(4 * 3600)), .enRetard(minutes: 60))
        XCTAssertEqual(f.telephoneNumerique, "0612345678")
        let m = f.message(fuseau: TimeZone(identifier: "Europe/Paris")!)
        XCTAssertTrue(m.contains("Lac Blanc") && m.contains("Nous sommes 2") && m.contains("112"))
        let relu = try! JSONDecoder().decode(FicheSortie.self, from: JSONEncoder().encode(f))
        XCTAssertEqual(relu, f)
    }
}
