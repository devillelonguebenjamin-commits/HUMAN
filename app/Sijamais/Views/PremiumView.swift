import StoreKit
import SwiftUI
import SijamaisCore

/// Écran Premium : ce qui reste gratuit, les univers premium, les offres, l'achat et la restauration.
struct PremiumView: View {
    @Environment(AppModel.self) private var modele
    @State private var gerer = false

    var body: some View {
        let ab = modele.abonnement
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("SIJAMAIS Premium").font(.title2.bold())
                    Text(ab.actif ? "Votre abonnement est actif. Merci de soutenir SIJAMAIS." : "Des outils en plus pour les loisirs et les enfants. Tout ce qui protège reste gratuit.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Gratuit, toujours") {
                ForEach(OffrePremium.toujoursGratuit, id: \.self) { Label($0, systemImage: "checkmark.shield.fill").foregroundStyle(.primary) }
            }

            Section("Les univers premium") {
                ForEach(OffrePremium.univers) { u in
                    if u.id == "randonnee" {
                        NavigationLink { RandonneeView() } label: { CarteUnivers(univers: u) }
                    } else {
                        CarteUnivers(univers: u)
                    }
                }
            }

            if !ab.actif {
                Section {
                    if ab.produits.isEmpty {
                        Text(ab.message ?? "Chargement des offres…").font(.footnote)
                    }
                    ForEach(ab.produits, id: \.id) { p in
                        Button { Task { await ab.acheter(p) } } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(OffrePremium.offre(p.id)?.titre ?? p.displayName).font(.headline)
                                    if OffrePremium.offre(p.id)?.famille == true {
                                        Text("Jusqu'à 6 personnes avec le Partage familial").font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Text("\(p.displayPrice) / \(OffrePremium.offre(p.id)?.periode ?? "")").font(.subheadline.bold())
                            }
                        }
                        .disabled(ab.enCours)
                    }
                } header: {
                    Text("S'abonner")
                } footer: {
                    Text("L'abonnement se renouvelle automatiquement, sauf résiliation au moins 24 heures avant la fin de la période en cours. Le paiement est prélevé sur votre compte Apple. Vous pouvez gérer ou résilier l'abonnement à tout moment dans les réglages de votre compte Apple.")
                }
            }

            Section {
                Button("Restaurer mes achats") { Task { await ab.restaurer() } }.disabled(ab.enCours)
                if ab.actif { Button("Gérer mon abonnement") { gerer = true } }
                if let m = ab.message, !ab.produits.isEmpty || ab.actif { Text(m).font(.footnote).foregroundStyle(.secondary) }
            }
        }
        .navigationTitle("Premium")
        .manageSubscriptionsSheet(isPresented: $gerer)
    }
}

/// Un univers premium : titre, état, ce qu'il apporte.
private struct CarteUnivers: View {
    let univers: OffrePremium.Univers

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(univers.titre, systemImage: univers.symbole).font(.headline)
                Spacer()
                Text(univers.disponible ? "Disponible" : "Bientôt")
                    .font(.caption.bold())
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(univers.disponible ? Charte.securite.opacity(0.2) : Color.secondary.opacity(0.15)))
            }
            Text(univers.resume).font(.subheadline).foregroundStyle(.secondary)
            ForEach(univers.apports, id: \.self) { Text("• \($0)").font(.footnote) }
        }
        .padding(.vertical, 4)
    }
}
