import SwiftUI
import SijamaisCore

/// Bulletins d'estimation du risque d'avalanche de Météo-France : liste des massifs, puis le bulletin.
struct AvalancheView: View {
    @Environment(AppModel.self) private var modele
    @State private var recherche = ""

    private var suggeres: [BulletinAvalanche.Massif] {
        var deps: [String] = []
        if let p = modele.cartes.principal { deps.append(p) }
        if let t = modele.traceSurCarte, let premier = t.points.first,
           let d = modele.cartes.france?.departement(lat: premier.latitude, lon: premier.longitude) {
            deps.append(d.code)
        }
        return BulletinAvalanche.massifs.filter { m in !modele.avalanche.favoris.contains(m.id) && m.departements.contains { deps.contains($0) } }
    }

    private func filtre(_ l: [BulletinAvalanche.Massif]) -> [BulletinAvalanche.Massif] {
        recherche.isEmpty ? l : l.filter { $0.nom.localizedStandardContains(recherche) }
    }

    var body: some View {
        List {
            if !BulletinAvalanche.enSaison(Date()) {
                Section {
                    Text("Météo-France publie les bulletins de début novembre à fin mai. Hors saison, informez-vous auprès des guides et des offices de haute montagne.")
                        .font(.footnote)
                }
            }
            let favoris = filtre(BulletinAvalanche.massifs.filter { modele.avalanche.favoris.contains($0.id) })
            if !favoris.isEmpty {
                Section("Mes massifs") { ForEach(favoris) { LigneMassif(massif: $0) } }
            }
            if !suggeres.isEmpty, recherche.isEmpty {
                Section("Près de chez vous ou de votre trace") { ForEach(suggeres) { LigneMassif(massif: $0) } }
            }
            ForEach(BulletinAvalanche.zones, id: \.self) { zone in
                let l = filtre(BulletinAvalanche.massifs.filter { $0.zone == zone })
                if !l.isEmpty { Section(zone) { ForEach(l) { LigneMassif(massif: $0) } } }
            }
            Section {
                Text("Source : Météo-France, bulletin d'estimation du risque d'avalanche. Le bulletin décrit une situation générale à l'échelle du massif : il ne remplace pas l'observation sur le terrain. En cas d'accident : 112.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .searchable(text: $recherche, prompt: "Massif")
        .navigationTitle("Avalanches")
        .task { await modele.avalanche.actualiserSuivis() }
        .refreshable { await modele.avalanche.actualiserSuivis() }
    }
}

private struct LigneMassif: View {
    @Environment(AppModel.self) private var modele
    let massif: BulletinAvalanche.Massif

    var body: some View {
        NavigationLink { BulletinView(massif: massif) } label: {
            HStack {
                if let b = modele.avalanche.bulletins[massif.id] {
                    PastilleRisque(niveau: b.risqueMaxi, perime: b.estPerime())
                } else {
                    PastilleRisque(niveau: 0, perime: true)
                }
                VStack(alignment: .leading) {
                    Text(massif.nom)
                    if let b = modele.avalanche.bulletins[massif.id] {
                        Text(b.estPerime() ? "Bulletin périmé, à mettre à jour" : "Risque \(BulletinAvalanche.libelle(b.risqueMaxi))")
                            .font(.caption).foregroundStyle(b.estPerime() ? Charte.secours : .secondary)
                    }
                }
                Spacer()
                if modele.avalanche.favoris.contains(massif.id) { Image(systemName: "star.fill").foregroundStyle(.yellow) }
            }
        }
    }
}

/// Pastille du niveau de risque, aux couleurs de l'échelle européenne ; grisée et barrée si le bulletin est périmé.
struct PastilleRisque: View {
    let niveau: Int
    var perime = false
    var taille: CGFloat = 30

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: taille / 5)
                .fill(perime ? Color.gray.opacity(0.3) : Color(hex: BulletinAvalanche.couleur(niveau)))
            Text(niveau > 0 ? "\(niveau)" : "?")
                .font(.system(size: taille * 0.55, weight: .bold))
                .foregroundStyle(niveau >= 4 && !perime ? .white : .black)
        }
        .frame(width: taille, height: taille)
        .accessibilityLabel(niveau > 0 ? "Risque \(niveau) sur 5, \(BulletinAvalanche.libelle(niveau))\(perime ? ", périmé" : "")" : "Pas de bulletin")
    }
}

struct BulletinView: View {
    @Environment(AppModel.self) private var modele
    let massif: BulletinAvalanche.Massif

    private static let date: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "EEEE d MMMM 'à' HH'h'mm"
        return f
    }()

    private static let heure: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "EEE HH'h'"
        return f
    }()

    var body: some View {
        List {
            switch modele.avalanche.etats[massif.id] {
            case .enCours?: Section { ProgressView("Téléchargement du bulletin...") }
            case let .erreur(message)?: Section { Label(message, systemImage: "wifi.slash").foregroundStyle(Charte.secours) }
            default: EmptyView()
            }
            if let b = modele.avalanche.bulletins[massif.id] {
                contenu(b)
            } else if modele.avalanche.etats[massif.id] != .enCours {
                Section {
                    Button("Télécharger le bulletin") { Task { await modele.avalanche.telecharger(massif.id) } }
                }
            }
        }
        .navigationTitle(massif.nom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if modele.avalanche.favoris.contains(massif.id) { modele.avalanche.favoris.remove(massif.id) } else { modele.avalanche.favoris.insert(massif.id) }
                } label: {
                    Image(systemName: modele.avalanche.favoris.contains(massif.id) ? "star.fill" : "star")
                }
                .accessibilityLabel("Suivre ce massif")
            }
        }
        .task { await modele.avalanche.telecharger(massif.id) }
        .refreshable { await modele.avalanche.telecharger(massif.id) }
    }

    @ViewBuilder
    private func contenu(_ b: BulletinAvalanche) -> some View {
        if b.estPerime() {
            Section {
                Label("Ce bulletin est périmé. Mettez-le à jour avant de partir.", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(Charte.secours).font(.headline)
            }
        }
        if !b.avis.isEmpty {
            Section { Label(b.avis, systemImage: "exclamationmark.octagon.fill").font(.headline).foregroundStyle(Charte.secours) }
        }
        Section {
            HStack(spacing: 14) {
                PastilleRisque(niveau: b.risqueMaxi, perime: b.estPerime(), taille: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Risque \(b.risqueMaxi) sur 5 : \(BulletinAvalanche.libelle(b.risqueMaxi))").font(.headline)
                    if let r2 = b.risque2, r2 != b.risque1, let alt = b.altitudeLimite {
                        Text("\(b.risque1) au-dessous de \(alt) m, \(r2) au-dessus").font(.subheadline)
                    }
                }
            }
            if !b.commentaireRisque.isEmpty { Text(b.commentaireRisque) }
            if let v = b.validite { Text("Valable jusqu'au \(Self.date.string(from: v))").font(.footnote).foregroundStyle(.secondary) }
            if let r = b.redaction { Text("Rédigé le \(Self.date.string(from: r))\(b.amendement ? ", rectifié" : "")").font(.footnote).foregroundStyle(.secondary) }
        } header: { Text("Risque du jour") }

        if !b.pentes.isEmpty {
            Section {
                HStack(spacing: 16) {
                    RosePentes(dangereuses: Set(b.pentes)).frame(width: 90, height: 90)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pentes les plus dangereuses : " + b.pentes.map(Self.orientation).joined(separator: ", ")).font(.subheadline)
                        if !b.commentairePentes.isEmpty { Text(b.commentairePentes).font(.footnote) }
                    }
                }
            } header: { Text("Orientations") }
        }
        if !b.resume.isEmpty { Section("Départs spontanés et déclenchements") { Text(b.resume) } }
        if !b.stabilite.isEmpty { Section("Stabilité du manteau neigeux") { Text(b.stabilite) } }
        if !b.qualite.isEmpty { Section("Qualité de la neige") { Text(b.qualite) } }
        if !b.enneigement.isEmpty {
            Section {
                ForEach(b.enneigement, id: \.altitude) { n in
                    LabeledContent("\(n.altitude) m", value: "nord \(n.nord) cm, sud \(n.sud) cm")
                }
                if let n = b.limiteNord, let s = b.limiteSud { Text("Neige continue dès \(n) m au nord, \(s) m au sud").font(.footnote) }
            } header: { Text("Épaisseur de neige hors piste") }
        }
        if !b.neigeFraiche.isEmpty {
            Section {
                ForEach(b.neigeFraiche, id: \.date) { n in
                    LabeledContent(n.date.formatted(.dateTime.weekday(.wide).day().locale(Locale(identifier: "fr_FR"))),
                                   value: n.maximum == 0 ? "0 cm" : "\(n.minimum) à \(n.maximum) cm")
                }
            } header: { Text("Neige fraîche\(b.altitudeNeigeFraiche.map { " à \($0) m" } ?? "")") }
        }
        if !b.meteo.isEmpty {
            Section {
                ForEach(b.meteo, id: \.date) { e in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Self.heure.string(from: e.date)) : \(BulletinAvalanche.temps(e.temps))").font(.subheadline.bold())
                        Text([e.iso0.map { "isotherme 0 °C à \($0) m" }, e.pluieNeige.map { "pluie-neige à \($0) m" },
                              e.ventHaut.isEmpty ? nil : "vent en altitude \(e.ventHaut)"].compactMap { $0 }.joined(separator: ", "))
                            .font(.footnote)
                    }
                }
                if !b.commentaireMeteo.isEmpty { Text(b.commentaireMeteo).font(.footnote) }
            } header: { Text("Aperçu météo") }
        }
        if !b.tendanceJ2.isEmpty {
            Section("Tendance pour le surlendemain") {
                if let j2 = b.risqueMaxiJ2 { HStack { PastilleRisque(niveau: j2, perime: b.estPerime()); Text(BulletinAvalanche.libelle(j2)) } }
                Text(b.tendanceJ2)
            }
        }
        Section {
            Text("Source : Météo-France. Le bulletin décrit une situation générale à l'échelle du massif : il ne remplace pas l'observation sur le terrain, ni l'avis d'un professionnel. En cas d'accident : 112.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private static func orientation(_ o: String) -> String {
        ["N": "nord", "NE": "nord-est", "E": "est", "SE": "sud-est", "S": "sud", "SW": "sud-ouest", "W": "ouest", "NW": "nord-ouest"][o] ?? o
    }
}

/// Rose des 8 orientations, les pentes dangereuses en noir.
private struct RosePentes: View {
    let dangereuses: Set<String>
    private let ordre = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]

    var body: some View {
        GeometryReader { g in
            let c = CGPoint(x: g.size.width / 2, y: g.size.height / 2)
            let r = min(g.size.width, g.size.height) / 2 - 10
            ZStack {
                ForEach(Array(ordre.enumerated()), id: \.offset) { i, o in
                    Path { p in
                        p.move(to: c)
                        p.addArc(center: c, radius: r, startAngle: .degrees(Double(i) * 45 - 90 - 22.5), endAngle: .degrees(Double(i) * 45 - 90 + 22.5), clockwise: false)
                        p.closeSubpath()
                    }
                    .fill(dangereuses.contains(o) ? Color.primary : Color.gray.opacity(0.25))
                    .overlay(Path { p in
                        p.move(to: c)
                        p.addArc(center: c, radius: r, startAngle: .degrees(Double(i) * 45 - 90 - 22.5), endAngle: .degrees(Double(i) * 45 - 90 + 22.5), clockwise: false)
                        p.closeSubpath()
                    }.stroke(Color(.systemBackground), lineWidth: 1))
                }
                Text("N").font(.caption2.bold()).position(x: c.x, y: 4)
            }
        }
        .accessibilityHidden(true)
    }
}
