import Foundation
import XCTest
@testable import SijamaisCore

/// Les 40 cas du cycle 2 (alertes, consignes officielles, risques majeurs), 27/11/2026
/// (contenus/assistant/cycle2/cas_de_test.json ; les écarts avec l'évaluateur y sont expliqués).
final class Cycle2Tests: XCTestCase {
    let assistant = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice())

    func testLes40Cas() async {
        let (total, echecs, connus) = await Cycle1Tests.rejouer("cas_cycle2", avec: assistant)
        XCTAssertEqual(total, 40)
        print("Cycle 2 : \(total - echecs.count - connus)/\(total) cas réussis, \(connus) échecs connus")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// Une consigne de risque majeur n'est jamais reformulée, même quand le modèle d'Apple est disponible.
    func testRisquesMajeursJamaisReformules() async {
        for q in ["corne de brume près du barrage", "accident nucléaire, je prends l'iode ?", "coups de feu dans la gare", "l'eau monte, je prends la voiture ?"] {
            let r = await assistant.repondre(q)
            XCTAssertEqual(r.mode, .passages, q)
            XCTAssertNil(r.texte, q)
        }
    }

    /// Les lignes des consignes sont prises mot pour mot dans les guides.
    func testLesConsignesViennentDesGuides() async {
        let tous = GuidesTests.bibliotheque.guides.flatMap { $0.blocs.flatMap { [$0.titreBloc] + $0.textesRecherche } }
        let url = Bundle.module.url(forResource: "cas_cycle2", withExtension: "json")!
        let cas = try! JSONDecoder().decode([Cycle1Tests.Cas].self, from: Data(contentsOf: url))
        for c in cas {
            let r = await assistant.repondre(c.question)
            guard r.mode == .passages || r.mode == .urgenceSante else { continue }
            for l in r.lignes { XCTAssertTrue(tous.contains(l), "\(c.id) : ligne hors guide « \(l) »") }
        }
    }

    /// Questions nouvelles sur le thème 2, posées après coup (27/11/2026) ; les échecs ont été corrigés par famille de cas.
    let questionsNouvelles: [(String, ReponseAssistant.Mode, String?, String?)] = [
        ("les pompiers passent avec un haut parleur et disent de rester chez soi", .passages, "reflexes", "Rejoignez un bâtiment"),
        ("jai recu un sms de la prefecture qui dit de se confiner", .passages, "reflexes", "N'allez pas chercher vos enfants"),
        ("explosion a lusine a cote de chez moi", .passages, "risques", "bâtiment clos"),
        ("la riviere deborde et ma cave est pleine deau", .passages, "risques", "sous-sols"),
        ("il pleut tres fort ma rue est une piscine", .passages, "risques", "Ne prenez pas votre voiture"),
        ("on voit des flammes sur la colline derriere la maison", .passages, "risques", "bâtiment en dur"),
        ("il y a un tireur dans le lycee de mon fils", .passages, "risques", "Se cacher"),
        ("la sirene sonne et mon fils est dehors", .passages, "alerte", "à l'abri"),
        ("je suis en voiture et il y a de la grele et des eclairs", .passages, "risques", "bâtiment en dur"),
        ("vigilance rouge inondation que faire", .passages, "risques", "le plus haut possible"),
        ("le nuage de lusine arrive vers nous", .passages, "risques", "coupez la ventilation"),
        ("le barrage de mon village fait un bruit bizarre", .passages, "alerte", "corne de brume"),
        ("j'entends la sirène mais je suis en voiture", .passages, "alerte", "ne restez pas dans un véhicule"),
        ("il y a une alerte enlèvement sur mon téléphone", .aucunGuide, nil, "numéro qu'il indique"),
        ("fin d'alerte comment on sait", .passages, "alerte", "signal continu"),
        ("test de la sirene cest quand", .passages, "alerte", "1er mercredi"),
        ("un enfant est tombé dans la piscine il ne respire plus", .urgenceSante, "arret-cardiaque", nil),
    ]

    func testLesQuestionsNouvelles() async {
        let a = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice(estDisponible: false))
        var echecs: [String] = []
        for (q, mode, guide, texte) in questionsNouvelles {
            let r = await a.repondre(q)
            let tout = ([r.texte ?? ""] + r.lignes).joined(separator: " ")
            if r.mode != mode || (guide != nil && r.guideId != guide) || (texte != nil && !tout.contains(texte!)) {
                echecs.append("\(q) -> \(r.mode) \(r.guideId ?? "-") | \(r.lignes.first ?? r.texte ?? "")")
            }
        }
        print("Questions nouvelles (cycle 2) : \(questionsNouvelles.count - echecs.count)/\(questionsNouvelles.count)")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// « Attaque » cardiaque ne déclenche jamais la consigne attentat.
    func testAttaqueCardiaqueNEstPasUnAttentat() async {
        let r = await assistant.repondre("mon père fait une attaque cardiaque")
        XCTAssertEqual(r.guideId, "arret-cardiaque")
        XCTAssertFalse(r.lignes.joined().contains("S'échapper"))
    }
}
