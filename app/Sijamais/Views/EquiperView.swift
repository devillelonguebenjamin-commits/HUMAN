import SwiftUI
import SijamaisCore

/// « S'équiper » : où trouver chaque article des listes des guides, dans les commerces ordinaires d'abord.
/// Un lien affilié Amazon, clairement signalé, n'apparaît que si un identifiant Amazon Partenaires est renseigné.
/// Jamais affiché depuis l'écran Urgence ni dans les réponses de l'assistant.
struct EquiperView: View {
    @Environment(AppModel.self) private var modele
    /// Limiter à une section (identifiant du guide : kit72h, sac-evacuation...), ou tout afficher.
    var section: String? = nil
    @State private var seulementManquants = false

    var body: some View {
        Group {
            if let c = modele.catalogue {
                List {
                    Section {
                        Text(c.introduction).font(.footnote)
                        if c.liensActifs {
                            Label(c.partenaireAmazon.mention, systemImage: "info.circle")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Toggle("Seulement ce qui me manque", isOn: $seulementManquants)
                    }
                    ForEach(c.sections.filter { section == nil || $0.id == section }) { s in
                        let articles = s.articles.filter { !seulementManquants || !modele.estCochee($0.liste, $0.index) }
                        if !articles.isEmpty {
                            Section {
                                ForEach(articles) { a in
                                    LigneArticle(article: a, lien: c.lien(a), pret: modele.estCochee(a.liste, a.index))
                                }
                            } header: {
                                Text(s.titre)
                            } footer: {
                                Text(s.intro)
                            }
                        }
                    }
                }
            } else {
                Text("La liste d'équipement est introuvable.")
            }
        }
        .navigationTitle("S'équiper")
    }
}

private struct LigneArticle: View {
    @Environment(AppModel.self) private var modele
    let article: Catalogue.Article
    let lien: URL?
    let pret: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                Button { modele.basculer(article.liste, article.index) } label: {
                    Image(systemName: pret ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(pret ? Charte.securite : Color.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(pret ? "Déjà prêt, appuyer pour décocher" : "À prévoir, appuyer pour cocher")
                Text(article.nom).font(.subheadline.weight(.semibold))
            }
            Label("Où le trouver : \(article.ouTrouver.joined(separator: ", "))", systemImage: "storefront")
                .font(.caption).foregroundStyle(.secondary)
            if let conseil = article.conseil {
                Label(conseil, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption).foregroundStyle(Charte.feu)
            }
            if let lien {
                Link(destination: lien) {
                    Label("Voir sur Amazon (lien affilié, internet nécessaire)", systemImage: "arrow.up.right.square")
                        .font(.caption.weight(.semibold))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
