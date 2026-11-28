import XCTest
@testable import SijamaisCore

final class BulletinAvalancheTests: XCTestCase {
    private func belledonne() throws -> BulletinAvalanche {
        try BulletinAvalanche.lire(Data(contentsOf: Bundle.module.url(forResource: "bra_belledonne", withExtension: "xml")!))
    }

    func testLectureDuBulletin() throws {
        let b = try belledonne()
        XCTAssertEqual(b.massifId, 8)
        XCTAssertEqual(b.massifNom, "Belledonne")
        XCTAssertEqual(b.risque1, 2)
        XCTAssertEqual(b.risque2, 3)
        XCTAssertEqual(b.risqueMaxi, 3)
        XCTAssertEqual(b.altitudeLimite, 2100)
        XCTAssertEqual(b.localisation1, "<2100")
        XCTAssertEqual(b.risqueMaxiJ2, 2)
        XCTAssertEqual(b.pentes, ["NE", "S", "NW"])
        XCTAssertTrue(b.resume.hasPrefix("Départs spontanés"))
        XCTAssertTrue(b.stabilite.hasPrefix("Bloc de texte stabilité"))
        XCTAssertTrue(b.qualite.hasPrefix("Bloc de texte qualité"))
        XCTAssertEqual(b.limiteSud, 1800)
        XCTAssertEqual(b.enneigement.count, 3, "les 7 derniers jours (BSH) sont ignorés")
        XCTAssertEqual(b.enneigement.last, .init(altitude: 2500, nord: 40, sud: 15))
        XCTAssertEqual(b.neigeFraiche.count, 6)
        XCTAssertEqual(b.meteo.count, 4)
        XCTAssertEqual(b.meteo[0].ventHaut, "S 20 km/h")
        XCTAssertEqual(b.meteo[3].ventBas, "calme")
        XCTAssertNil(b.meteo[3].pluieNeige, "-1 : temps sec")
        XCTAssertEqual(BulletinAvalanche.temps(b.meteo[1].temps), "très nuageux")
        XCTAssertTrue(b.commentaireMeteo.hasPrefix("Précision"))
        XCTAssertTrue(b.tendanceJ2.hasPrefix("risque limité"))
    }

    func testValiditeEtResume() throws {
        let b = try belledonne()
        let paris = TimeZone(identifier: "Europe/Paris")!
        var c = Calendar(identifier: .gregorian)
        c.timeZone = paris
        let avant = c.date(from: DateComponents(year: 2023, month: 10, day: 27, hour: 17))!
        let apres = c.date(from: DateComponents(year: 2023, month: 10, day: 27, hour: 19))!
        XCTAssertFalse(b.estPerime(maintenant: avant))
        XCTAssertTrue(b.estPerime(maintenant: apres))
        let r = b.resumeCourt(fuseau: paris)
        XCTAssertTrue(r.contains("risque 3 sur 5 (marqué) au-dessus de 2100 m"), r)
        XCTAssertTrue(r.contains("vendredi 27 octobre à 18h00"), r)
        XCTAssertFalse(r.contains("\u{2014}") || r.contains("\u{2013}"))
    }

    func testMassifsEtSaison() {
        XCTAssertEqual(BulletinAvalanche.massifs.count, 36)
        XCTAssertEqual(Set(BulletinAvalanche.massifs.map(\.id)).count, 36)
        XCTAssertEqual(BulletinAvalanche.massifs(departement: "74").map(\.nom), ["Chablais", "Aravis", "Mont-Blanc"])
        XCTAssertEqual(BulletinAvalanche.massifs(departement: "09").count, 3)
        XCTAssertEqual(BulletinAvalanche.libelle(4), "fort")
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        XCTAssertTrue(BulletinAvalanche.enSaison(c.date(from: DateComponents(year: 2026, month: 1, day: 10))!, calendrier: c))
        XCTAssertFalse(BulletinAvalanche.enSaison(c.date(from: DateComponents(year: 2026, month: 7, day: 10))!, calendrier: c))
    }

    func testFichierQuiNEstPasUnBulletin() {
        XCTAssertThrowsError(try BulletinAvalanche.lire(Data("<html></html>".utf8)))
        XCTAssertThrowsError(try BulletinAvalanche.lire(Data("pas du xml".utf8)))
    }
}

final class FicheAvalancheTests: XCTestCase {
    func testLigneAvalancheDansLeMessage() {
        let f = FicheSortie(itineraire: "Lac Blanc")
        XCTAssertFalse(f.message().contains("Avalanche"))
        let m = f.message(avalanche: "Avalanche, Belledonne : risque 3 sur 5 (marqué).")
        XCTAssertTrue(m.contains("Avalanche, Belledonne"))
        XCTAssertTrue(m.hasSuffix("donne-leur ce message."), "la consigne d'alerte reste en dernier")
    }
}
