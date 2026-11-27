import Foundation
import XCTest
@testable import SijamaisCore

final class EspaceEnfantsTests: XCTestCase {
    let espace = EspaceEnfants.integre!

    func testLeContenuSeLitEntierement() {
        XCTAssertEqual(espace.tranches.count, 2)
        XCTAssertEqual(espace.tranches.flatMap(\.modules).count, 13)
        XCTAssertEqual(espace.aide.boutons.map(\.action).sorted(), ["112", "carte", "parent"])
    }

    /// Chaque mise en situation a une seule bonne réponse, et chaque réponse est expliquée.
    func testChaqueQuizAUneSeuleBonneReponse() {
        for m in espace.tranches.flatMap(\.modules) {
            XCTAssertFalse(m.lecon.isEmpty, m.id)
            XCTAssertFalse(m.quiz.isEmpty, m.id)
            for q in m.quiz {
                XCTAssertEqual(q.choix.filter(\.juste).count, 1, "\(m.id) : \(q.situation)")
                XCTAssertTrue(q.choix.allSatisfy { !$0.pourquoi.isEmpty }, m.id)
            }
        }
    }

    /// Aucune adresse internet dans l'Espace enfants, sauf le tchat du 119 (enfance en danger), qui protège :
    /// il s'affiche en texte simple, jamais en lien cliquable.
    func testAucunLienVersLExterieur() {
        for m in espace.tranches.flatMap(\.modules) {
            let tout = (m.lecon + m.quiz.flatMap { [$0.situation] + $0.choix.flatMap { [$0.t, $0.pourquoi] } }).joined(separator: " ")
                .replacingOccurrences(of: "allo119.gouv.fr", with: "")
            XCTAssertFalse(tout.contains("http") || tout.contains("www.") || tout.contains(".fr"), m.id)
        }
    }

    /// Les modules qui protègent sont gratuits : alerter les secours, et « Besoin d'en parler ».
    func testLesModulesQuiProtegentSontGratuits() {
        let gratuits = Set(espace.tranches.flatMap(\.modules).filter(\.gratuit).map(\.id))
        XCTAssertEqual(gratuits, ["p-appeler", "g-alerter", "g-ecoute"])
    }

    func testCarteEtControleParental() {
        XCTAssertTrue(espace.phraseCarte(prenom: "Léa").contains("Je m'appelle Léa."))
        XCTAssertFalse(espace.phraseCarte(prenom: "").contains("{prenom}"))
        let c = ControleParental(a: 7, b: 14)
        XCTAssertTrue(c.verifier("98"))
        XCTAssertFalse(c.verifier("97"))
        XCTAssertGreaterThanOrEqual(ControleParental.nouveau().reponse, 72)
    }
}
