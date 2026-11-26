import SwiftUI
import SijamaisCore

struct UrgenceView: View {
    @Environment(AppModel.self) private var modele

    /// Tuiles « Que se passe-t-il ? » : titre, sous-titre, symbole, signal, guide ouvert.
    private let scenarios: [(String, String, String, Signal, String)] = [
        ("Coupure d'électricité", "ou de réseau", "bolt.slash.fill", .danger, "coupure-electricite"),
        ("Inondation", "ou submersion marine", "water.waves", .eau, "risques"),
        ("Tempête", "vent violent", "wind", .danger, "risques"),
        ("Canicule", "fortes chaleurs", "thermometer.sun.fill", .feu, "canicule"),
        ("Grand froid", "se chauffer sans danger", "thermometer.snowflake", .eau, "grand-froid"),
        ("Feu de forêt", "se protéger, évacuer", "flame.fill", .feu, "risques"),
        ("Séisme", "pendant, après", "house.lodge.fill", .danger, "risques"),
        ("Accident industriel", "ou nucléaire", "building.2.fill", .danger, "risques"),
        ("Conflit ou attaque", "se mettre à l'abri", "shield.lefthalf.filled", .neutre, "risques"),
        ("Évacuation", "partir vite et bien", "figure.walk.departure", .securite, "abri-evacuation"),
        ("Cyberattaque", "rançon, piratage, arnaque", "lock.trianglebadge.exclamationmark.fill", .eau, "cyberattaque"),
        ("Monoxyde de carbone", "gaz invisible, mortel", "aqi.high", .danger, "monoxyde"),
    ]

    private let secours = ["arret-cardiaque", "saignement", "inconscient-respire", "etouffement", "brulure"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    ForEach([("112", "Urgences"), ("15", "Samu"), ("18", "Pompiers"), ("17", "Police")], id: \.0) { n, libelle in
                        if let url = URL(string: "tel:\(n)") {
                            Link(destination: url) {
                                VStack(spacing: 2) {
                                    Text(n).font(.title2.weight(.heavy)).foregroundStyle(Charte.secours)
                                    Text(libelle).font(.caption2).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                            }
                            .accessibilityLabel("Appeler le \(n), \(libelle)")
                        }
                    }
                }
                if let sms = URL(string: "sms:114") {
                    Link("114 par SMS pour les personnes sourdes ou malentendantes, ou pour alerter en silence", destination: sms)
                        .font(.footnote)
                }

                if let g = modele.guide("reflexes") {
                    NavigationLink { GuideView(guide: g) } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "light.beacon.max.fill").font(.title)
                            VStack(alignment: .leading) {
                                Text("La sirène retentit").font(.headline)
                                Text("Les 7 réflexes du guide officiel").font(.footnote)
                            }
                            Spacer()
                        }
                        .foregroundStyle(Charte.encre)
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Charte.danger))
                    }
                }

                Text("Que se passe-t-il ?").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(scenarios, id: \.0) { titre, sous, symbole, signal, guideId in
                        if let g = modele.guide(guideId) {
                            NavigationLink { GuideView(guide: g) } label: {
                                Tuile(titre: titre, sousTitre: sous, symbole: symbole, signal: signal)
                            }
                        }
                    }
                }
                Text("Tous les scénarios sont gratuits, pour toujours.").font(.caption).foregroundStyle(.secondary)

                Text("Premiers secours").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
                VStack(spacing: 0) {
                    ForEach(secours, id: \.self) { id in
                        if let g = modele.guide(id) {
                            NavigationLink { GuideView(guide: g) } label: {
                                HStack { LigneGuide(guide: g); Spacer(); Image(systemName: "chevron.right").foregroundStyle(.tertiary) }
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                            }
                            Divider().padding(.leading, 58)
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                Text("D'après les recommandations PSC1 et « gestes qui sauvent » du ministère de l'Intérieur, décembre 2023.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .padding(16)
        }
        .navigationTitle("Urgence")
    }
}
