import XCTest
@testable import SijamaisCore

final class DocumentLegalTests: XCTestCase {
    func testLesDeuxTextesSontEmbarques() throws {
        for n in DocumentLegal.Nom.allCases {
            let d = try XCTUnwrap(DocumentLegal.integre(n), n.rawValue)
            XCTAssertEqual(d.blocs.first, .titre(n == .conditions ? "Conditions d'utilisation de SIJAMAIS" : "Politique de confidentialité de SIJAMAIS"))
            XCTAssertGreaterThan(d.blocs.count, 20)
        }
    }

    /// Les mentions qu'Apple et le droit de la consommation attendent pour un abonnement.
    func testMentionsObligatoires() throws {
        let cgu = try XCTUnwrap(DocumentLegal.integre(.conditions)).blocs.map { "\($0)" }.joined().lowercased()
        for m in ["renouvel", "24 heures", "résiliation", "112", "ne remplace ni les secours", "médiateur de la consommation"] {
            XCTAssertTrue(cgu.contains(m), m)
        }
        let conf = try XCTUnwrap(DocumentLegal.integre(.confidentialite)).blocs.map { "\($0)" }.joined()
        for m in ["sans compte", "Apple", "Amazon", "CNIL", "Espace enfants"] { XCTAssertTrue(conf.contains(m), m) }
    }

    func testLecture() {
        let d = DocumentLegal(markdown: "# T\n\n## S\n- **a**\ntexte")
        XCTAssertEqual(d.blocs, [.titre("T"), .sousTitre("S"), .puce("a"), .paragraphe("texte")])
    }
}
