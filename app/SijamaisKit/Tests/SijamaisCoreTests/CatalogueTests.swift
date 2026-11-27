import Foundation
import XCTest
@testable import SijamaisCore

final class CatalogueTests: XCTestCase {
    static let catalogue: Catalogue = try! Catalogue(url: Bundle.module.url(forResource: "catalogue", withExtension: "json")!)

    /// Chaque article est une ligne exacte d'une liste de guide : le catalogue n'ajoute rien aux listes officielles.
    func testChaqueArticleVientDUnGuide() {
        let b = GuidesTests.bibliotheque
        for s in Self.catalogue.sections {
            for a in s.articles {
                let g = try! XCTUnwrap(b.guide(a.guide), a.id)
                var items: [String] = []
                for bl in g.blocs { if case let .check(id, _, its) = bl, id == a.liste { items = its } }
                XCTAssertEqual(items.indices.contains(a.index) ? items[a.index] : nil, a.nom, a.id)
                XCTAssertFalse(a.ouTrouver.isEmpty, "\(a.id) : aucun commerce indiqué")
            }
        }
    }

    /// Sans identifiant Amazon Partenaires, aucun lien commercial n'apparaît.
    func testAucunLienSansIdentifiant() {
        XCTAssertFalse(Self.catalogue.liensActifs)
        for s in Self.catalogue.sections { for a in s.articles { XCTAssertNil(Self.catalogue.lien(a)) } }
    }

    func testLienAffilieVersUneRechercheSansMarque() throws {
        let c = Self.catalogue.avecTag("sijamais-21")
        let a = try XCTUnwrap(c.sections.flatMap(\.articles).first { $0.nom == "Lampe frontale" })
        let url = try XCTUnwrap(c.lien(a)).absoluteString
        XCTAssertTrue(url.hasPrefix("https://www.amazon.fr/s?"), url)
        XCTAssertTrue(url.contains("tag=sijamais-21"), url)
        XCTAssertTrue(url.contains("k=lampe%20frontale"), url)
    }

    /// Jamais de lien pour les médicaments, le lait infantile, l'eau et la nourriture.
    func testPasDeLienPourLesProduitsSensibles() {
        let c = Self.catalogue.avecTag("sijamais-21")
        for a in c.sections.flatMap(\.articles) where ["Médicament", "lait infantile", "Eau potable", "Conserves", "Nourriture", "Thermomètre", "Masques"].contains(where: { a.nom.contains($0) }) {
            XCTAssertNil(c.lien(a), a.nom)
        }
    }

    /// Le réchaud porte toujours la mise en garde monoxyde.
    func testLeRechaudPorteLaMiseEnGarde() {
        let r = Self.catalogue.sections.flatMap(\.articles).first { $0.nom == "Réchaud" }
        XCTAssertEqual(r?.conseil?.contains("monoxyde"), true)
    }
}
