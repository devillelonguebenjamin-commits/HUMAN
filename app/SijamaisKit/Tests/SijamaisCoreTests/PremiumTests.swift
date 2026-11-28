import Foundation
import XCTest
@testable import SijamaisCore

final class PremiumTests: XCTestCase {
    /// Les prix de référence sont ceux décidés (journal) ; les offres famille sont partageables.
    func testLesOffresDecidees() {
        XCTAssertEqual(OffrePremium.offres.map(\.prix), ["44,99 €", "5,99 €", "29,99 €", "3,99 €"])
        XCTAssertEqual(OffrePremium.offres.filter(\.famille).count, 2)
        XCTAssertEqual(Set(OffrePremium.identifiants).count, 4)
        XCTAssertLessThan(OffrePremium.rang("fr.sijamais.premium.famille.annuel"), OffrePremium.rang("fr.sijamais.premium.mensuel"))
    }

    /// Ce qui protège n'est jamais derrière le paiement : les modules gratuits des enfants s'ouvrent sans abonnement.
    func testCeQuiProtegeResteGratuit() throws {
        let e = try XCTUnwrap(EspaceEnfants.integre)
        let modules = e.tranches.flatMap(\.modules)
        for id in ["p-appeler", "g-alerter", "g-ecoute"] {
            let m = try XCTUnwrap(modules.first { $0.id == id })
            XCTAssertTrue(OffrePremium.moduleOuvert(m, abonne: false), id)
        }
        XCTAssertTrue(modules.allSatisfy { OffrePremium.moduleOuvert($0, abonne: true) })
        XCTAssertEqual(modules.filter { !OffrePremium.moduleOuvert($0, abonne: false) }.count, 10)
    }

    /// Les univers annoncés : l'Espace enfants est disponible, les autres annoncés « bientôt ».
    func testLesUnivers() {
        XCTAssertEqual(OffrePremium.univers.map(\.id), ["enfants", "randonnee", "voyage", "mer"])
        XCTAssertEqual(OffrePremium.univers.filter(\.disponible).map(\.id), ["enfants", "randonnee", "voyage"])
    }
}
