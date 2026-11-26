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

/// Carte hors ligne : prochaine étape du développement (MapLibre et fichiers PMTiles).
struct CarteView: View {
    var body: some View {
        List {
            Section {
                Label("Carte hors ligne en cours de développement", systemImage: "map")
                    .font(.headline)
                Text("La carte de votre département se téléchargera à l'installation et fonctionnera sans réseau : hôpitaux, pompiers, défibrillateurs, points de rassemblement de la commune.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("En attendant") {
                Text("Les défibrillateurs proches : application Staying Alive.")
                Text("Les risques de votre commune : georisques.gouv.fr, quand le réseau est disponible.")
            }
        }
        .navigationTitle("Carte")
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
            Section("Assistant") {
                Text(modele.modeleAppleDisponible ? "Modèle d'Apple disponible sur cet iPhone." : "Modèle d'Apple indisponible : l'assistant affiche les passages des guides.")
                    .font(.footnote)
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
