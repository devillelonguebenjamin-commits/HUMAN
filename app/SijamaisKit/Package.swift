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
        .target(name: "SijamaisCore"),
        .testTarget(
            name: "SijamaisCoreTests",
            dependencies: ["SijamaisCore"],
            resources: [.copy("Fixtures/guides.json"), .copy("Fixtures/cas_cycle1.json"), .copy("Fixtures/cas_cycle2.json")]
        ),
    ]
)
