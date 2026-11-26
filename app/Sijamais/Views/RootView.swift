import SwiftUI

struct RootView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        if modele.priseEnMainTerminee {
            OngletsView()
        } else {
            PriseEnMainView()
        }
    }
}

/// Les cinq onglets, avec l'assistant au centre (variante A retenue le 26/11/2026).
struct OngletsView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch modele.onglet {
                case .accueil: NavigationStack { AccueilView() }
                case .urgence: NavigationStack { UrgenceView() }
                case .assistant: NavigationStack { AssistantView() }
                case .carte: NavigationStack { CarteView() }
                case .savoir: NavigationStack { SavoirView() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            BarreOnglets()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct BarreOnglets: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            bouton(.accueil, "Accueil", "house")
            bouton(.urgence, "Urgence", "exclamationmark.triangle")
            boutonAssistant
            bouton(.carte, "Carte", "map")
            bouton(.savoir, "Savoir", "book.closed")
        }
        .padding(.top, 6)
        .padding(.bottom, 2)
        .background(.bar)
        .overlay(alignment: .top) { Divider() }
    }

    private func bouton(_ o: Onglet, _ titre: String, _ symbole: String) -> some View {
        Button { modele.onglet = o } label: {
            VStack(spacing: 3) {
                Image(systemName: symbole).font(.system(size: 21, weight: .medium))
                Text(titre).font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(modele.onglet == o ? Charte.balise : Color.secondary)
        }
        .accessibilityAddTraits(modele.onglet == o ? .isSelected : [])
    }

    private var boutonAssistant: some View {
        Button { modele.onglet = .assistant } label: {
            VStack(spacing: 3) {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(Circle().fill(Charte.balise))
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 5))
                    .offset(y: -14)
                    .padding(.bottom, -14)
                Text("Assistant").font(.caption2.weight(.semibold))
                    .foregroundStyle(modele.onglet == .assistant ? Charte.balise : Color.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityLabel("Assistant")
    }
}
