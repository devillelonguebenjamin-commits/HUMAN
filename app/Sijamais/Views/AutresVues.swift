import SwiftUI
import SijamaisCore

/// Onglet Savoir : les guides par catégorie.
struct SavoirView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        List {
            Section {
                Text("\(modele.bibliotheque.guides.count) guides gratuits, consultables sans réseau. En situation réelle, les consignes des autorités priment toujours.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            ForEach(modele.bibliotheque.categories) { c in
                Section(c.titre) {
                    ForEach(modele.bibliotheque.guides(categorie: c.id)) { g in
                        NavigationLink { GuideView(guide: g) } label: { LigneGuide(guide: g) }
                    }
                }
            }
        }
        .navigationTitle("Savoir")
    }
}

/// Préparer : le kit de 72 heures du guide officiel, adapté au foyer.
struct PreparerView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        if let kit = modele.guide("kit72h") {
            GuideView(guide: kit)
        } else {
            Text("Le guide du kit est introuvable.")
        }
    }
}

/// Onglet Carte : la carte hors ligne si un fichier de carte est présent, sinon un écran d'explication.
struct CarteView: View {
    @State private var style: URL? = CarteHorsLigne.styleLocal()

    var body: some View {
        Group {
            if let style {
                ZStack(alignment: .bottom) {
                    CarteMapLibre(styleURL: style).ignoresSafeArea(edges: .top)
                    Legende()
                }
            } else {
                List {
                    Section {
                        Label("Aucune carte téléchargée", systemImage: "map")
                            .font(.headline)
                        Text("La carte de votre département se téléchargera une fois, puis fonctionnera sans réseau : hôpitaux, pompiers, pharmacies, défibrillateurs, points de rassemblement de la commune.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Section("En attendant") {
                        Text("Les défibrillateurs proches : application Staying Alive.")
                        Text("Les risques de votre commune : georisques.gouv.fr, quand le réseau est disponible.")
                    }
                }
            }
        }
        .navigationTitle("Carte")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct Legende: View {
    private let elements: [(String, Color)] = [
        ("Hôpital", Charte.secours), ("Pompiers", Color(hex: 0xC2410C)), ("Défibrillateur", Color(hex: 0x00A651)),
        ("Pharmacie", Charte.securite), ("Police", Charte.eau), ("Mairie", Charte.foret),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            FlowLayout(spacing: 10) {
                ForEach(elements, id: \.0) { nom, couleur in
                    HStack(spacing: 4) {
                        Circle().fill(couleur).frame(width: 10, height: 10)
                        Text(nom).font(.caption2)
                    }
                }
            }
            Text("Hors ligne · © les contributeurs d'OpenStreetMap, Géo'DAE. Positions à vérifier sur place. En urgence vitale, appelez le 15 ou le 112.")
                .font(.caption2).foregroundStyle(.secondary)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14).fill(.regularMaterial))
        .padding(10)
    }
}

/// Réglages : foyer, commune, données, à propos.
struct ReglagesView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        @Bindable var modele = modele
        Form {
            Section("Mon foyer") {
                Stepper("Adultes : \(modele.foyer.adultes)", value: $modele.foyer.adultes, in: 0...12)
                Stepper("Enfants : \(modele.foyer.enfants)", value: $modele.foyer.enfants, in: 0...12)
                Stepper("Personnes fragiles : \(modele.foyer.personnesFragiles)", value: $modele.foyer.personnesFragiles, in: 0...12)
                Stepper("Animaux : \(modele.foyer.animaux)", value: $modele.foyer.animaux, in: 0...12)
            }
            Section("Ma commune") {
                TextField("Commune", text: $modele.commune)
            }
            Section("Données personnelles") {
                Text("Aucune donnée n'est envoyée. Vos réponses, vos listes et vos formulaires restent sur ce téléphone.")
                    .font(.footnote)
            }
            Section {
                Toggle("Espace mairie", isOn: $modele.espaceMairie)
            } header: {
                Text("Élus et agents")
            } footer: {
                Text("Ajoute aux réponses de l'assistant les 5 guides de la commune : poste de commandement, pilotage, communication de crise, cyberattaque de la commune, exercices. Les questions posées en tant qu'élu ou agent (« notre mairie », « le PCC »...) les trouvent même sans cet interrupteur.")
            }
            Section("Assistant") {
                Text(modele.modeleAppleDisponible ? "Modèle d'Apple disponible sur cet iPhone." : "Modèle d'Apple indisponible : l'assistant affiche les passages des guides.")
                    .font(.footnote)
            }
            Section("Abonnement") {
                NavigationLink { PremiumView() } label: {
                    Label(modele.abonnement.actif ? "Premium : abonnement actif" : "Découvrir Premium", systemImage: "star.fill")
                }
            }
            Section("À propos") {
                Text("Guides version \(modele.bibliotheque.fichier.meta.version) du \(modele.bibliotheque.fichier.meta.date)")
                Text(modele.bibliotheque.fichier.meta.avertissement).font(.footnote).foregroundStyle(.secondary)
                Button("Revoir la prise en main") { modele.recommencerPriseEnMain() }
            }
        }
        .navigationTitle("Réglages")
    }
}
