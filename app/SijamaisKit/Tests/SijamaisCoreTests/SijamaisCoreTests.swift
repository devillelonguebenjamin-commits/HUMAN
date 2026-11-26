import Foundation
import XCTest
@testable import SijamaisCore

final class GuidesTests: XCTestCase {
    static let bibliotheque: GuideLibrary = {
        let url = Bundle.module.url(forResource: "guides", withExtension: "json")!
        return try! GuideLibrary(url: url)
    }()

    func testLeFichierDesGuidesSeLitEntierement() {
        let b = Self.bibliotheque
        XCTAssertEqual(b.guides.count, 46)
        XCTAssertEqual(b.categories.count, 5)
        XCTAssertEqual(Set(b.guides.map(\.id)).count, b.guides.count, "identifiants en double")
    }

    func testChaqueGuideCiteDesSourcesConnues() {
        let b = Self.bibliotheque
        for g in b.guides {
            XCTAssertFalse(g.sources.isEmpty, g.id)
            for s in g.sources { XCTAssertNotNil(b.source(s), "\(g.id) cite \(s)") }
        }
    }

    func testLesGuidesDeSanteSontMarquesSensiblesEtOntDesEtapes() {
        let b = Self.bibliotheque
        for id in ["arret-cardiaque", "saignement", "inconscient-respire", "etouffement", "brulure", "monoxyde"] {
            let g = try! XCTUnwrap(b.guide(id))
            XCTAssertTrue(g.sensible, id)
            XCTAssertFalse(g.premieresEtapes.isEmpty, id)
        }
    }

    func testLes24SchemasSontRattachesAuxGuides() {
        let schemas = Self.bibliotheque.guides.flatMap(\.schemas)
        XCTAssertEqual(schemas.count, 24)
        XCTAssertEqual(schemas.filter(\.relectureSecours).count, 6)
        XCTAssertTrue(schemas.allSatisfy { !$0.alt.isEmpty })
    }

    func testAucunTiretLong() {
        let url = Bundle.module.url(forResource: "guides", withExtension: "json")!
        let texte = try! String(contentsOf: url, encoding: .utf8)
        XCTAssertFalse(texte.contains("\u{2014}") || texte.contains("\u{2013}"))
    }
}

final class RechercheTests: XCTestCase {
    let moteur = MoteurRecherche(bibliotheque: GuidesTests.bibliotheque)

    /// Les mêmes questions que la maquette (prototype/maquette_app), plus quelques cas propres à l'application.
    let cas: [(String, String?, Bool)] = [
        ("Mon voisin ne respire plus", "arret-cardiaque", true),
        ("il saigne beaucoup du bras", "saignement", true),
        ("Plus de courant depuis hier", "coupure-electricite", false),
        ("Que mettre dans le kit ?", "kit72h", false),
        ("La sirène sonne, que faire ?", "alerte", false),
        ("Mon ordinateur demande une rançon", "cyberattaque", false),
        ("Comment rendre l'eau potable ?", "eau", false),
        ("il fait 40 degrés chez moi", "canicule", false),
        ("trouver le nord sans boussole", "orientation", false),
        ("délai pour déclarer à l'assurance après une inondation", "assurance", false),
        ("mon fils s'étouffe avec un bonbon", "etouffement", true),
        ("quand prendre les comprimés d'iode", "risques", false),
        ("l'eau monte dans la rue", "risques", false),
        ("SMS bizarre de ma banque", "cyberattaque", false),
        ("quel champignon puis-je manger", "cueillette", false),
        ("Combien d'eau stocker ?", "stocks", false),
        ("Délai pour déclarer à l'assurance", "assurance", false),
        ("Donne moi le rythme à avoir pour le massage cardiaque", "arret-cardiaque", false),
        ("J'ai peur", "moral", false),
        ("je panique", "moral", false),
    ]

    func testLeRythmeDuMassageEstTrouve() {
        let r = moteur.chercher("Donne moi le rythme à avoir pour le massage cardiaque")
        XCTAssertTrue(r.passages.contains { $0.contains("100 à 120") }, r.passages.joined(separator: " | "))
    }

    func testLesQuestionsCourantesTrouventLeBonGuide() {
        var echecs: [String] = []
        for (q, attendu, sensible) in cas {
            let r = moteur.chercher(q)
            if r.guide?.id != attendu || r.sensible != sensible {
                echecs.append("\(q) -> \(r.guide?.id ?? "aucun") (sensible : \(r.sensible), score : \(r.score))")
            }
        }
        XCTAssertTrue(echecs.isEmpty, echecs.joined(separator: "\n"))
    }

    func testUneQuestionHorsSujetNeTrouveRien() {
        XCTAssertNil(moteur.chercher("recette de la tarte aux pommes").guide)
        XCTAssertNil(moteur.chercher("").guide)
    }

    func testUneQuestionDeSanteAfficheLesEtapesDansLOrdre() {
        let r = moteur.chercher("Mon voisin ne respire plus")
        XCTAssertTrue(r.sensible)
        XCTAssertEqual(r.lignesAAfficher.first?.hasPrefix("Alertez"), true)
    }

    func testNormalisation() {
        XCTAssertEqual(Normalisation.normaliser("Électricité, gaz & cœur !"), "electricite  gaz   coeur  ")
        XCTAssertEqual(MoteurRecherche.racine("inondation"), "inondatio")
        XCTAssertEqual(MoteurRecherche.racine("brulures"), "brulur")
        XCTAssertEqual(MoteurRecherche.racine("kit"), "kit")
    }
}

/// Modèle factice pour tester les règles de l'assistant sans iPhone.
struct ModeleFactice: Reformulateur {
    var estDisponible = true
    var reponse: ReformulationModele?
    var erreur = false
    struct Refus: Error {}

    func reformuler(question: String, passages: [String], guideId: String) async throws -> ReformulationModele {
        if erreur { throw Refus() }
        return reponse ?? ReformulationModele(texte: "Réponse courte.", guidesCites: [guideId])
    }
}

final class AssistantTests: XCTestCase {
    let moteur = MoteurRecherche(bibliotheque: GuidesTests.bibliotheque)

    func testSanteJamaisReformulee() async {
        let a = Assistant(moteur: moteur, reformulateur: ModeleFactice())
        let r = await a.repondre("il saigne beaucoup du bras")
        XCTAssertEqual(r.mode, .urgenceSante)
        XCTAssertTrue(r.urgenceVitale)
        XCTAssertNil(r.texte)
    }

    func testUrgencePersonnelleAppelerTousDeSuite() async {
        let a = Assistant(moteur: moteur, reformulateur: ModeleFactice())
        for q in ["Je n'arrive plus à respirer", "j'ai mal à la poitrine", "je saigne beaucoup"] {
            let r = await a.repondre(q)
            XCTAssertEqual(r.mode, .urgencePersonnelle, q)
            XCTAssertTrue(r.urgenceVitale, q)
        }
        let autre = await a.repondre("Mon voisin ne respire plus")
        XCTAssertEqual(autre.mode, .urgenceSante)
    }

    func testReformulationAccepteeQuandElleCiteLeBonGuide() async {
        let a = Assistant(moteur: moteur, reformulateur: ModeleFactice())
        let r = await a.repondre("Que mettre dans le kit ?")
        XCTAssertEqual(r.mode, .reformulee)
        XCTAssertEqual(r.guideId, "kit72h")
    }

    func testCitationInventeeRefuseeOnAfficheLeGuide() async {
        let faux = ModeleFactice(reponse: ReformulationModele(texte: "Voir le guide.", guidesCites: ["guide-invente"]))
        let r = await Assistant(moteur: moteur, reformulateur: faux).repondre("Que mettre dans le kit ?")
        XCTAssertEqual(r.mode, .passages)
        XCTAssertFalse(r.lignes.isEmpty)
    }

    func testRefusDuModeleOnAfficheLeGuide() async {
        let r = await Assistant(moteur: moteur, reformulateur: ModeleFactice(erreur: true)).repondre("Mon ordinateur demande une rançon")
        XCTAssertEqual(r.mode, .passages)
        XCTAssertEqual(r.guideId, "cyberattaque")
    }

    func testSansModeleCompatibleOnAfficheLeGuide() async {
        let r = await Assistant(moteur: moteur, reformulateur: ModeleFactice(estDisponible: false)).repondre("Que mettre dans le kit ?")
        XCTAssertEqual(r.mode, .passages)
    }

    func testHorsSujet() async {
        let r = await Assistant(moteur: moteur, reformulateur: ModeleFactice()).repondre("recette de la tarte aux pommes")
        XCTAssertEqual(r.mode, .aucunGuide)
    }

    func testInviteNeContientQueLesPassages() {
        let s = Assistant.invite(question: "Q ?", passages: ["un", "deux"], guideId: "kit72h")
        XCTAssertTrue(s.contains("1. un") && s.contains("2. deux") && s.contains("kit72h"))
    }

    func testReformulationTropLongueRefusee() {
        let long = ReformulationModele(texte: String(repeating: "a", count: 2000), guidesCites: ["kit72h"])
        XCTAssertFalse(Assistant.reformulationAcceptable(long, guideId: "kit72h"))
    }
}

final class PreparationTests: XCTestCase {
    func testScoreEtNiveaux() throws {
        let kit = try XCTUnwrap(GuidesTests.bibliotheque.guide("kit72h"))
        var etat = EtatListes()
        let vide = ScorePreparation.calculer(guideKit: kit, etat: etat)
        XCTAssertEqual(vide.valeur, 0)
        XCTAssertEqual(vide.niveau, .debutant)
        XCTAssertGreaterThan(vide.total, 15)
        for b in kit.blocs { if case let .check(id, _, items) = b { for i in items.indices { etat.basculer(liste: id, index: i) } } }
        let plein = ScorePreparation.calculer(guideKit: kit, etat: etat)
        XCTAssertEqual(plein.valeur, 100)
        XCTAssertEqual(plein.niveau, .pare)
        XCTAssertNil(plein.prochainSeuil)
    }

    func testEauDuFoyer() {
        XCTAssertEqual(Foyer(adultes: 2, enfants: 1, personnesFragiles: 0, animaux: 1).eau(litresParPersonne: 6), 18)
        XCTAssertEqual(Foyer(adultes: 0, enfants: 0).personnes, 1)
    }

    func testLesListesSeSauvegardent() throws {
        var etat = EtatListes()
        etat.basculer(liste: "kit-base", index: 2)
        let relu = try JSONDecoder().decode(EtatListes.self, from: JSONEncoder().encode(etat))
        XCTAssertTrue(relu.estCochee(liste: "kit-base", index: 2))
        etat.basculer(liste: "kit-base", index: 2)
        XCTAssertFalse(etat.estCochee(liste: "kit-base", index: 2))
    }
}
