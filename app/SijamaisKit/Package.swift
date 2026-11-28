// swift-tools-version:6.0
// Cœur de l'application SIJAMAIS : modèles des guides, recherche hors ligne,
// règles de l'assistant et score de préparation. Aucune dépendance externe,
// testable sur Mac comme sur Linux (swift test).
import PackageDescription

let package = Package(
    name: "SijamaisKit",
    defaultLocalization: "fr",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SijamaisCore", targets: ["SijamaisCore"]),
    ],
    targets: [
        .target(
            name: "SijamaisCore",
            // Parcours guidé et liste d'équipement : toujours dans l'application, sans relancer XcodeGen.
            resources: [.copy("Ressources/parcours.json"), .copy("Ressources/catalogue.json"), .copy("Ressources/plan_familial.json"), .copy("Ressources/enfants.json"), .copy("Ressources/conditions_utilisation.md"), .copy("Ressources/politique_confidentialite.md"), .copy("Ressources/departements.json")]
        ),
        .testTarget(
            name: "SijamaisCoreTests",
            dependencies: ["SijamaisCore"],
            resources: [.copy("Fixtures/guides.json"), .copy("Fixtures/catalogue.json"), .copy("Fixtures/parcours.json"), .copy("Fixtures/style-modele.json"), .copy("Fixtures/cas_cycle1.json"), .copy("Fixtures/cas_cycle2.json"), .copy("Fixtures/cas_cycle3.json"), .copy("Fixtures/cas_cycle4.json"), .copy("Fixtures/cas_cycle5.json"), .copy("Fixtures/cas_cycle6.json"), .copy("Fixtures/bra_belledonne.xml")]
        ),
    ]
)
