import Foundation
import XCTest
@testable import SijamaisCore

final class PlanFamilialTests: XCTestCase {
    let plan = PlanFamilial.integre!

    /// Chaque clé correspond à un champ du guide « Mon plan familial » : le parcours et le guide partagent les réponses.
    func testChaqueCleEstUnChampDuGuide() throws {
        let g = try XCTUnwrap(GuidesTests.bibliotheque.guide("pfms"))
        var cles = Set<String>()
        for b in g.blocs { if case let .form(id, _, fields) = b { for i in fields.indices { cles.insert("pfms.\(id).\(i)") } } }
        for e in plan.etapes {
            XCTAssertFalse(e.cles.isEmpty, e.id)
            for c in e.cles { XCTAssertTrue(cles.contains(c), "\(e.id) : \(c)") }
            if e.type != .texte { XCTAssertGreaterThanOrEqual(e.choix.count, 2, e.id) }
        }
    }

    /// Les consignes proposées pour chaque risque sont mot pour mot dans le guide « Que faire selon le risque ».
    func testLesConsignesDesRisquesViennentDuGuide() throws {
        let g = try XCTUnwrap(GuidesTests.bibliotheque.guide("risques"))
        let textes = g.blocs.flatMap(\.textesRecherche)
        let etape = try XCTUnwrap(plan.etapes.first { $0.type == .risques })
        XCTAssertEqual(etape.choix.filter { $0.parDefaut == true }.count, 2, "tempête et matières dangereuses cochées d'office")
        for c in etape.choix {
            let consigne = String(try XCTUnwrap(c.valeur).split(separator: ":", maxSplits: 1)[1]).trimmingCharacters(in: .whitespaces)
            XCTAssertTrue(textes.contains(consigne), c.libelle)
        }
    }

    func testGabaritEtCompte() throws {
        let e = try XCTUnwrap(plan.etapes.first { $0.id == "electricite" })
        XCTAssertEqual(e.texte(pour: e.choix[0]), "Dans l'entrée : basculer le disjoncteur général sur O")
        let gaz = try XCTUnwrap(plan.etapes.first { $0.id == "gaz" })
        XCTAssertEqual(gaz.texte(pour: gaz.choix[0]), "Pas de gaz")
        XCTAssertEqual(plan.remplies { $0 == "pfms.pfms-risques.0" ? "Nantes" : "" }, 1)
    }
}
