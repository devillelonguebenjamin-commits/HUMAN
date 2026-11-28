import Foundation
import XCTest
@testable import SijamaisCore

/// Les 40 cas du cycle 1 (urgences vitales et premiers secours), produits par le Claude évaluateur
/// le 27/11/2026 (contenus/assistant/cycle1/cas_de_test.json). Rejoués à chaque version.
final class Cycle1Tests: XCTestCase {
    struct Cas: Decodable {
        let id: String
        let question: String
        let mode_attendu: String
        let guide_attendu: String?
        let doit_contenir: [String]?
        let ne_doit_pas_contenir: [String]?
        let urgence_vitale: Bool?
        let echec_connu: String?
    }

    static let cas: [Cas] = {
        let url = Bundle.module.url(forResource: "cas_cycle1", withExtension: "json")!
        return try! JSONDecoder().decode([Cas].self, from: Data(contentsOf: url))
    }()

    let assistant = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice())

    static func nom(_ m: ReponseAssistant.Mode) -> String {
        switch m {
        case .urgencePersonnelle: "urgencePersonnelle"
        case .urgenceSante: "urgenceSante"
        case .reformulee: "reformulee"
        case .passages: "passages"
        case .aucunGuide: "aucunGuide"
        case .clarification: "clarification"
        }
    }

    /// Rejoue un fichier de cas (cycle 1, 2...) et renvoie les échecs.
    static func rejouer(_ fichier: String, avec assistant: Assistant) async -> (total: Int, echecs: [String], connus: Int) {
        let url = Bundle.module.url(forResource: fichier, withExtension: "json")!
        let cas = try! JSONDecoder().decode([Cas].self, from: Data(contentsOf: url))
        var echecs: [String] = []
        var connus = 0
        for c in cas {
            let r = await assistant.repondre(c.question)
            var pb: [String] = []
            let mode = nom(r.mode)
            // Une reformulation et des passages bruts sont deux affichages du même résultat (selon l'iPhone).
            let modeOK = mode == c.mode_attendu || (Set([mode, c.mode_attendu]) == ["reformulee", "passages"])
            if !modeOK { pb.append("mode \(mode) au lieu de \(c.mode_attendu)") }
            if let g = c.guide_attendu, r.guideId != g { pb.append("guide \(r.guideId ?? "aucun") au lieu de \(g)") }
            if let v = c.urgence_vitale, r.urgenceVitale != v { pb.append("urgence vitale \(r.urgenceVitale)") }
            let tout = ([r.texte ?? ""] + r.lignes).joined(separator: " ").lowercased()
            for m in c.doit_contenir ?? [] where !tout.contains(m.lowercased()) { pb.append("manque « \(m) »") }
            for m in c.ne_doit_pas_contenir ?? [] where tout.contains(m.lowercased()) { pb.append("contient « \(m) »") }
            if r.mode == .clarification && r.options.count < 2 { pb.append("moins de 2 boutons") }
            if c.echec_connu != nil {
                // Échec connu et documenté : compté à part ; s'il se met à réussir, on le signale.
                if pb.isEmpty { print("\(c.id) réussit désormais : retirer « echec_connu »") } else { connus += 1 }
                continue
            }
            if !pb.isEmpty { echecs.append("\(c.id) « \(c.question) » : " + pb.joined(separator: ", ")) }
        }
        return (cas.count, echecs, connus)
    }

    func testLes40Cas() async {
        let (total, echecs, connus) = await Self.rejouer("cas_cycle1", avec: assistant)
        XCTAssertEqual(total, 40)
        print("Cycle 1 : \(total - echecs.count - connus)/\(total) cas réussis, \(connus) échecs connus")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// Chaque bouton de clarification mène à une réponse définitive, jamais à une nouvelle question.
    func testLesBoutonsDeClarificationConcluent() async {
        for q in ["malaise", "il saigne", "mon voisin est tombé par terre", "je me suis coupé, ça saigne un peu"] {
            let r = await assistant.repondre(q)
            XCTAssertEqual(r.mode, .clarification, q)
            for o in r.options {
                let suite = await assistant.repondre(o.question)
                // Au plus deux questions : « Pour un proche » demande ensuite s'il répond et s'il respire.
                for o2 in suite.options {
                    let fin = await assistant.repondre(o2.question)
                    XCTAssertNotEqual(fin.mode, .clarification, "\(q) puis « \(o.libelle) » puis « \(o2.libelle) »")
                }
            }
        }
    }

    func testLeTriageNAfficheQueDesLignesDeGuides() async {
        let tous = GuidesTests.bibliotheque.guides.flatMap { g in
            g.blocs.flatMap { b -> [String] in b.textesRecherche }
        }.joined(separator: "\n")
        for c in Self.cas {
            let r = await assistant.repondre(c.question)
            guard r.mode == .urgenceSante else { continue }
            for l in r.lignes {
                // Les lignes de numéros sont recomposées : « 196 : Secours en mer. ... »
                let morceau = l.contains(" : ") && l.first?.isNumber == true ? String(l.split(separator: ".", maxSplits: 1).last ?? "") : l
                XCTAssertTrue(tous.contains(morceau.trimmingCharacters(in: .whitespaces)), "\(c.id) : ligne hors guide « \(l) »")
            }
        }
    }

    /// Questions nouvelles posées après coup (27/11/2026) pour vérifier que les règles ne sont pas apprises par cœur.
    /// Chacune a d'abord échoué ou réussi sans avoir été écrite pour elle ; les échecs ont été corrigés par famille de cas.
    let questionsNouvelles: [(String, ReponseAssistant.Mode, String?)] = [
        ("ma femme vient de s'écrouler elle ne respire plus", .urgenceSante, "arret-cardiaque"),
        ("jsuis en train de m'étouffer", .urgencePersonnelle, nil),
        ("mon gamin a bu de l'eau de javel", .urgenceSante, "numeros"),
        ("il s'est coupé avec un couteau ça coule énormément", .urgenceSante, "saignement"),
        ("ma fille s'est brûlée avec le fer à repasser", .urgenceSante, "brulure"),
        ("quelqu'un fait un malaise dans le bus", .clarification, nil),
        ("mon grand père est tombé dans l'escalier", .clarification, nil),
        ("j'ai très mal au coeur je vais tomber", .urgencePersonnelle, nil),
        ("help my friend is not breathing", .urgenceSante, "arret-cardiaque"),
        ("le détecteur de fumée sonne et il y a de la fumée", .urgenceSante, "incendie-domicile"),
        ("comment faire une PLS", .urgenceSante, "inconscient-respire"),
        ("mon fils de 3 ans a avalé une pile", .urgenceSante, "numeros"),
        ("elle s'est évanouie mais elle respire", .urgenceSante, "inconscient-respire"),
        ("combien de temps masser avant l'arrivée des pompiers", .urgenceSante, "arret-cardiaque"),
        ("ma soeur s'est entaillé le poignet ça saigne de partout", .urgenceSante, "saignement"),
        ("papa ne se réveille pas", .clarification, nil),
        ("mon copain fait une overdose", .aucunGuide, nil),
        ("un enfant s'est noyé dans la piscine", .aucunGuide, nil),
        ("je me suis brûlé avec de l'eau bouillante", .urgenceSante, "brulure"),
        ("mon mari a mangé des champignons et il vomit", .urgenceSante, "numeros"),
        ("comment utiliser un défibrillateur", .urgenceSante, "arret-cardiaque"),
        ("elle s'étouffe elle peut plus parler", .urgenceSante, "etouffement"),
        ("j'ai une douleur dans le bras gauche et la mâchoire", .urgencePersonnelle, nil),
        ("mon bébé ne respire plus", .urgenceSante, "arret-cardiaque"),
        ("il a pris un coup de couteau", .urgenceSante, "saignement"),
        ("comment arrêter un saignement de nez", .aucunGuide, nil),
        ("il est électrocuté", .aucunGuide, nil),
        ("piqûre de guêpe gorge qui gonfle", .aucunGuide, nil),
        ("mon fils a de la fièvre", .aucunGuide, nil),
        ("mon voisin a une crise d'asthme", .aucunGuide, nil),
        ("accident de scooter le gars bouge plus", .urgenceSante, "arret-cardiaque"),
    ]

    func testLesQuestionsNouvelles() async {
        var echecs: [String] = []
        for (q, mode, guide) in questionsNouvelles {
            let r = await assistant.repondre(q)
            if r.mode != mode || (guide != nil && r.guideId != guide) { echecs.append("\(q) -> \(r.mode) \(r.guideId ?? "-")") }
            if r.mode == .aucunGuide && (r.texte ?? "").isEmpty { echecs.append("\(q) : pas de message d'orientation") }
        }
        print("Questions nouvelles : \(questionsNouvelles.count - echecs.count)/\(questionsNouvelles.count)")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }

    /// L'étouffement d'un nourrisson ne montre jamais les gestes de l'adulte.
    func testNourrissonJamaisDeGestesAdultes() async {
        for q in ["mon bébé s'étouffe", "le nourrisson a avalé de travers il devient bleu", "ma fille de 8 mois s'étouffe avec une perle"] {
            let r = await assistant.repondre(q)
            XCTAssertEqual(r.mode, .urgenceSante, q)
            XCTAssertFalse(r.lignes.joined().contains("creux de l'estomac"), q)
            XCTAssertTrue(r.lignes.joined().lowercased().contains("nourrisson"), q)
        }
    }

    func testUnTouristeAnglophoneVoitLe112() async {
        let r = await assistant.repondre("my child burned his hand with boiling water what to do")
        XCTAssertTrue(r.enAnglais)
        let fr = await assistant.repondre("mon fils s'est brûlé la main")
        XCTAssertFalse(fr.enAnglais)
    }
}
