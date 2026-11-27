import SwiftUI
import SijamaisCore

/// « Cartes de France » : télécharger les départements pour le hors ligne.
/// Gratuit : un département (le sien). Abonnement : toute la France.
struct CartesFranceView: View {
    @Environment(AppModel.self) private var modele
    @State private var recherche = ""

    var body: some View {
        let g = modele.cartes
        let abonne = modele.abonnement.actif
        List {
            Section {
                Label(abonne ? "Abonnement : toute la France, hors ligne" : "Gratuit : votre département. Abonnement : toute la France.", systemImage: "map.fill")
                Text("Place utilisée : \(ByteCountFormatter.string(fromByteCount: g.octetsUtilises, countStyle: .file))").font(.footnote).foregroundStyle(.secondary)
                if !g.hebergementPret {
                    Text("Le téléchargement ouvrira dès que les cartes seront hébergées. En attendant, la vue d'ensemble de la France et la Loire-Atlantique sont dans l'application.")
                        .font(.footnote).foregroundStyle(Charte.feu)
                }
            } footer: {
                Text("Chaque département se télécharge une fois, de préférence en Wi-Fi, puis fonctionne sans réseau. © les contributeurs d'OpenStreetMap, Protomaps.")
            }
            if let france = g.france {
                ForEach(france.regions, id: \.self) { region in
                    let deps = france.departements.filter { $0.region == region && (recherche.isEmpty || $0.nom.localizedCaseInsensitiveContains(recherche) || $0.code.hasPrefix(recherche)) }
                    if !deps.isEmpty {
                        Section(region) {
                            ForEach(deps) { d in LigneDepartement(departement: d) }
                        }
                    }
                }
            }
        }
        .searchable(text: $recherche, prompt: "Département ou numéro")
        .navigationTitle("Cartes de France")
        .onAppear { g.actualiser() }
    }
}

private struct LigneDepartement: View {
    @Environment(AppModel.self) private var modele
    let departement: CartesFrance.Departement

    var body: some View {
        let g = modele.cartes
        let abonne = modele.abonnement.actif
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(departement.code) · \(departement.nom)").font(.subheadline.weight(.semibold))
                    if g.principal == departement.code { Text("Mon département").font(.caption2.bold()).foregroundStyle(Charte.securite) }
                }
                switch g.etats[departement.code] ?? .absent {
                case let .present(o): Text("Sur le téléphone · \(ByteCountFormatter.string(fromByteCount: o, countStyle: .file))").font(.caption).foregroundStyle(.secondary)
                case let .enCours(p): ProgressView(value: p).tint(Charte.balise)
                case let .erreur(m): Text(m).font(.caption).foregroundStyle(Charte.secours)
                case .absent: EmptyView()
                }
            }
            Spacer()
            switch g.etats[departement.code] ?? .absent {
            case .present:
                Button(role: .destructive) { g.supprimer(departement.code) } label: { Image(systemName: "trash") }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Supprimer la carte \(departement.nom)")
            case .enCours:
                EmptyView()
            default:
                if g.peutTelecharger(departement.code, abonne: abonne) {
                    Button { g.telecharger(departement.code) } label: { Image(systemName: "arrow.down.circle.fill").font(.title2) }
                        .buttonStyle(.borderless)
                        .disabled(!g.hebergementPret)
                        .accessibilityLabel("Télécharger la carte \(departement.nom)")
                } else {
                    NavigationLink { PremiumView() } label: { Image(systemName: "lock.fill").foregroundStyle(.secondary) }
                        .frame(width: 30)
                        .accessibilityLabel("Avec l'abonnement")
                }
            }
        }
        .swipeActions {
            if g.principal != departement.code {
                Button("Mon département") { g.principal = departement.code }.tint(Charte.securite)
            }
        }
    }
}
