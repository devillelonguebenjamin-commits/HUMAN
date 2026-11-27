import SwiftUI
import SijamaisCore

struct AccueilView: View {
    @Environment(AppModel.self) private var modele
    @State private var lampe = Lampe()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                EnTeteSijamais()
                    .padding(.bottom, 4)
                Button { modele.onglet = .urgence } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "cross.fill").font(.title2.bold())
                            .foregroundStyle(Charte.secours)
                            .frame(width: 46, height: 46)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Urgence").font(.title3.bold())
                            Text("Numéros, 7 réflexes, que faire maintenant").font(.footnote)
                        }
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Charte.secours))
                }

                Button { modele.onglet = .assistant } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "bubble.left.and.text.bubble.right").foregroundStyle(Charte.balise)
                        Text("Posez une question à l'assistant").foregroundStyle(.secondary)
                        Spacer()
                        Text("Hors ligne").font(.caption2.weight(.semibold)).foregroundStyle(Charte.securite)
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Charte.balise, lineWidth: 1.5))
                }

                if let score = modele.score {
                    NavigationLink { PreparerView() } label: { CarteScore(score: score) }
                        .buttonStyle(.plain)
                }

                Text("Accès rapides").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    NavigationLink { PreparerView() } label: {
                        Tuile(titre: "Préparer", sousTitre: "Mon kit de 72 heures", symbole: "bag.fill", signal: .preparation)
                    }
                    NavigationLink { FamilleView() } label: {
                        Tuile(titre: "Famille", sousTitre: "Plan familial de mise en sûreté", symbole: "person.2.fill", signal: .securite)
                    }
                    NavigationLink { EquiperView() } label: {
                        Tuile(titre: "S'équiper", sousTitre: "Où trouver le matériel", symbole: "cart.fill", signal: .preparation)
                    }
                    NavigationLink { CommuneView() } label: {
                        Tuile(titre: "Ma commune", sousTitre: modele.commune.isEmpty ? "À renseigner" : modele.commune, symbole: "building.columns.fill", signal: .preparation)
                    }
                    Button { lampe.basculer() } label: {
                        Tuile(titre: lampe.allumee ? "Éteindre la lampe" : "Lampe", sousTitre: lampe.disponible ? "Lampe torche" : "Indisponible sur cet appareil", symbole: lampe.allumee ? "flashlight.on.fill" : "flashlight.off.fill", signal: .danger)
                    }
                    .disabled(!lampe.disponible)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
        // Le titre reste « SIJAMAIS » pour le bouton retour des écrans suivants ; l'en-tête le remplace à l'écran.
        .navigationTitle("SIJAMAIS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { Color.clear.frame(width: 1, height: 1) }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { ReglagesView() } label: { Image(systemName: "gearshape") }
                    .accessibilityLabel("Réglages")
            }
        }
    }
}

struct CarteScore: View {
    let score: ScorePreparation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("Préparation du foyer").font(.headline)
                Spacer()
                Text("\(score.valeur)").font(.title2.bold()) + Text(" / 100").font(.footnote).foregroundColor(.secondary)
            }
            ProgressView(value: Double(score.valeur), total: 100).tint(Charte.balise)
            Text(score.prochainSeuil.map { "Niveau \(score.niveau.rawValue) · prochain niveau à \($0)" } ?? "Niveau \(score.niveau.rawValue)")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}

/// Espace « Ma commune » : en attente des données transmises par la mairie.
struct CommuneView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        List {
            Section {
                Text(modele.commune.isEmpty ? "Commune non renseignée" : modele.commune).font(.headline)
                Text("Quand votre mairie rejoindra SIJAMAIS, vous trouverez ici ses consignes, ses points de rassemblement et ses alertes, consultables sans réseau.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Pour connaître les risques de votre commune") {
                Text("Le document d'information communal sur les risques majeurs (DICRIM), en mairie ou sur son site.")
                Text("georisques.gouv.fr, quand le réseau est disponible.")
            }
        }
        .navigationTitle("Ma commune")
    }
}
