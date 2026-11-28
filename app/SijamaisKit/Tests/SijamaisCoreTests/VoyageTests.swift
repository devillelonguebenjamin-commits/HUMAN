import XCTest
@testable import SijamaisCore

final class VoyageTests: XCTestCase {
    func testContenu() throws {
        let v = try XCTUnwrap(Voyage.integre)
        XCTAssertEqual(v.langues.count, 10)
        XCTAssertEqual(v.phrases.count, 20)
        for p in v.phrases { XCTAssertEqual(Set(p.traductions.keys), Set(v.langues.map(\.code)), p.id) }
        XCTAssertEqual(Set(v.pays.map(\.code)).count, v.pays.count, "pas de pays en double")
        XCTAssertEqual(v.pays.filter { $0.zone == "Union européenne" }.count, 26 + 0, "26 pays de l'UE hors France")
        for p in v.pays {
            XCTAssertFalse(p.numeros.isEmpty, p.nom)
            XCTAssertTrue(Voyage.zones.contains(p.zone), p.nom)
            if let l = p.langue { XCTAssertNotNil(v.langue(l), p.nom) }
            for n in p.numeros { XCTAssertTrue(n.numero.allSatisfy(\.isNumber), "\(p.nom) \(n.numero)") }
        }
        let texte = String(decoding: try JSONSerialization.data(withJSONObject: ["x": v.phrases.map(\.fr)]), as: UTF8.self)
        XCTAssertFalse(texte.contains("\u{2014}") || texte.contains("\u{2013}"))
    }

    func testUnionEuropeenne112Verifie() throws {
        let v = try XCTUnwrap(Voyage.integre)
        let es = try XCTUnwrap(v.pays("ES"))
        XCTAssertEqual(es.principal, .init(service: "Toutes urgences", numero: "112", verifie: true))
        XCTAssertFalse(es.toutVerifie, "le 091 reste à vérifier")
        XCTAssertTrue(try XCTUnwrap(v.pays("IT")).toutVerifie)
        XCTAssertFalse(try XCTUnwrap(v.pays("TH")).toutVerifie, "numéros hors UE : à confirmer")
        XCTAssertEqual(try XCTUnwrap(v.pays("IT")).drapeau, "🇮🇹")
        XCTAssertNil(v.pays("FR"), "la France n'est pas une destination de voyage")
    }

    func testAccesEtRecherche() throws {
        let v = try XCTUnwrap(Voyage.integre)
        XCTAssertEqual(v.phrases(abonne: false).count, 11)
        XCTAssertEqual(v.phrases(abonne: true).count, 20)
        XCTAssertTrue(v.phrases(abonne: false).contains { $0.id == "ambulance" })
        XCTAssertEqual(v.chercher("etats").map(\.code), ["US"])
        XCTAssertEqual(v.chercher("GRECE").map(\.code), ["GR"])
        XCTAssertEqual(v.chercher("").count, v.pays.count)
        XCTAssertTrue(try XCTUnwrap(v.langue("ar")).droiteAGauche)
    }

    func testDossier() throws {
        var d = DossierVoyage()
        XCTAssertTrue(d.estVide)
        d.allergies = "pénicilline"
        d.contactNom = "Claire"
        let v = try XCTUnwrap(Voyage.integre)
        let f = d.ficheSante(phrases: v.phrases, langue: "en")
        XCTAssertEqual(f.count, 2)
        XCTAssertEqual(f[0].traduction, "I have a severe allergy.")
        let ancien = Data(#"{"destination":"Lisbonne"}"#.utf8)
        XCTAssertEqual(try JSONDecoder().decode(DossierVoyage.self, from: ancien).destination, "Lisbonne")
        let rond = try JSONDecoder().decode(DossierVoyage.self, from: JSONEncoder().encode(d))
        XCTAssertEqual(rond, d)
    }
}
