import Foundation
import XCTest
@testable import SijamaisCore

final class ParcoursTests: XCTestCase {
    static let parcours: Parcours = try! Parcours(url: Bundle.module.url(forResource: "parcours", withExtension: "json")!)
    let assistant = Assistant(moteur: MoteurRecherche(bibliotheque: GuidesTests.bibliotheque), reformulateur: ModeleFactice(estDisponible: false))

    /// Toutes les questions sont reliées, il n'y a pas de cul-de-sac, et chaque question est atteignable depuis le départ.
    func testLArbreEstComplet() throws {
        let p = Self.parcours
        XCTAssertNotNil(p.depart)
        var vus = Set<String>()
        var aVoir = [p.racine]
        while let id = aVoir.popLast() {
            guard vus.insert(id).inserted else { continue }
            let n = try XCTUnwrap(p.noeud(id), id)
            XCTAssertGreaterThanOrEqual(n.options.count, 2, id)
            for o in n.options {
                XCTAssertTrue((o.suivant != nil) != (o.question != nil), "\(id) / \(o.libelle) : ni suite ni fin, ou les deux")
                if let s = o.suivant { aVoir.append(s) }
            }
        }
        XCTAssertEqual(vus.count, p.noeuds.count, "questions inatteignables")
    }

    /// Chaque fin de parcours mène au guide et au mode attendus, jamais à « pas de guide » par erreur ni à une nouvelle question.
    func testChaqueFinDeParcoursMeneAuBonGuide() async {
        var echecs: [String] = []
        var total = 0
        for n in Self.parcours.noeuds {
            for o in n.options {
                guard let q = o.question, let att = o.attendu else { continue }
                total += 1
                let r = await assistant.repondre(q)
                let mode = Cycle1Tests.nom(r.mode)
                let modeOK = mode == att.mode || Set([mode, att.mode]) == ["reformulee", "passages"]
                if !modeOK || (att.guide != nil && r.guideId != att.guide) || r.mode == .clarification {
                    echecs.append("\(n.id) / \(o.libelle) -> \(mode) \(r.guideId ?? "-") (attendu \(att.mode) \(att.guide ?? "-"))")
                }
                if r.mode == .aucunGuide && (r.texte ?? "").isEmpty { echecs.append("\(n.id) / \(o.libelle) : aucune orientation") }
            }
        }
        print("Parcours guidé : \(total - echecs.count)/\(total) fins de parcours correctes")
        XCTAssertTrue(echecs.isEmpty, "\n" + echecs.joined(separator: "\n"))
    }
}

final class RessourcesIntegreesTests: XCTestCase {
    /// Le parcours et la liste d'équipement sont dans SijamaisCore : jamais absents de l'application.
    func testLesRessourcesSontEmbarquees() {
        XCTAssertNotNil(Parcours.integre?.depart)
        XCTAssertEqual(Catalogue.integre?.sections.isEmpty, false)
    }
}
