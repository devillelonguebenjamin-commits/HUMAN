import Foundation
import XCTest
@testable import SijamaisCore

/// Cycles 3 à 6 (préparation et coupures ; survie ; après crise, cyber, désinformation ; Espace mairie), 27/11/2026.
final class Cycles3a6Tests: XCTestCase {
    let assistant = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice())

    func verifier(_ n: Int) async {
        let (total, echecs, connus) = await Cycle1Tests.rejouer("cas_cycle\(n)", avec: assistant)
        XCTAssertEqual(total, 40)
        print("Cycle \(n) : \(total - echecs.count - connus)/\(total) cas réussis, \(connus) échecs connus")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// Questions nouvelles posées après coup (27/11/2026), dont la détresse « je veux plus vivre », d'abord manquée.
    let questionsNouvelles: [(String, ReponseAssistant.Mode, String?)] = [
        ("je veux plus vivre", .urgencePersonnelle, "moral"),
        ("ma mere dit quelle veut en finir", .urgenceSante, "moral"),
        ("j'en ai marre de la vie", .urgencePersonnelle, "moral"),
        ("le frigo est coupe depuis ce matin", .passages, "coupure-electricite"),
        ("jai recu un mail de ma banque qui demande mon code", .passages, "cyberattaque"),
        ("mon fils est harcele sur snapchat", .aucunGuide, nil),
        ("je narrive plus a dormir depuis la tempete", .passages, "moral"),
        ("l assurance ne repond pas depuis un mois", .passages, "assurance"),
        ("on a perdu notre maison dans lincendie ou dormir ce soir", .passages, "assurance"),
        ("combien de conserves pour deux semaines pour 3 personnes", .passages, "stocks"),
        ("je me suis perdu en vtt dans les bois", .passages, "orientation"),
        ("comment rendre leau de la mare potable", .passages, "eau"),
        ("notre site internet de mairie est pirate que dire aux habitants", .passages, "cyberattaque-commune"),
    ]

    func testLesQuestionsNouvelles() async {
        let a = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice(estDisponible: false))
        var echecs: [String] = []
        for (q, mode, guide) in questionsNouvelles {
            let r = await a.repondre(q)
            if r.mode != mode || (guide != nil && r.guideId != guide) { echecs.append("\(q) -> \(r.mode) \(r.guideId ?? "-")") }
            if r.mode == .aucunGuide && (r.texte ?? "").isEmpty { echecs.append("\(q) : pas de message d'orientation") }
        }
        print("Questions nouvelles (cycles 3 à 6) : \(questionsNouvelles.count - echecs.count)/\(questionsNouvelles.count)")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// Interrupteur « Espace mairie » : les guides de la commune n'entrent dans la recherche que s'il est activé
    /// (ou si la question vient d'un élu ou d'un agent).
    func testInterrupteurEspaceMairie() {
        let m = MoteurRecherche(bibliotheque: GuidesTests.bibliotheque)
        let q = "trame faits actes empathie engagement transparence"
        XCTAssertFalse(MoteurRecherche.guidesMairie.contains(m.chercher(q).guide?.id ?? ""))
        XCTAssertEqual(m.chercher(q, tous: true).guide?.id, "com-crise")
    }

    func testCycle3() async { await verifier(3) }
    func testCycle4() async { await verifier(4) }
    func testCycle5() async { await verifier(5) }
    func testCycle6() async { await verifier(6) }
}
