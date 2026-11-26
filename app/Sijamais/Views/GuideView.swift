import SwiftUI
import SijamaisCore

/// Un guide, bloc par bloc.
struct GuideView: View {
    @Environment(AppModel.self) private var modele
    let guide: Guide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    BadgeNiveau(niveau: guide.niveau)
                    Text("\(guide.duree) de lecture").font(.caption).foregroundStyle(.secondary)
                }
                Text(guide.resume).foregroundStyle(.secondary)
                if guide.sensible { BandeauUrgenceVitale() }
                ForEach(Array(guide.blocs.enumerated()), id: \.offset) { _, bloc in
                    BlocView(bloc: bloc, guideId: guide.id)
                }
                Sources(guide: guide)
            }
            .padding(16)
        }
        .navigationTitle(guide.titre)
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct Sources: View {
    @Environment(AppModel.self) private var modele
    let guide: Guide

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Titre(texte: "Sources")
            ForEach(guide.sources, id: \.self) { id in
                if let s = modele.bibliotheque.source(id) {
                    Text("• \(s.titre), \(s.editeur)\(s.date.map { ", \($0)" } ?? "")").font(.caption).foregroundStyle(.secondary)
                }
            }
            Text("Version \(guide.version) du \(guide.maj) · \(guide.relecture.statut)").font(.caption2).foregroundStyle(.secondary)
            if !guide.aVerifier.isEmpty {
                Text("À vérifier avant diffusion : " + guide.aVerifier.joined(separator: " ; "))
                    .font(.caption2).foregroundStyle(Color(hex: 0x9A6A00))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color(hex: 0x9A6A00), style: StrokeStyle(lineWidth: 1, dash: [4])))
            }
        }
        .padding(.top, 8)
    }
}

private struct Titre: View {
    let texte: String
    var body: some View {
        Text(texte).font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase).padding(.top, 6)
    }
}

private struct Carte<Contenu: View>: View {
    @ViewBuilder let contenu: Contenu
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { contenu }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}

/// Rendu de chaque type de bloc du fichier des guides.
struct BlocView: View {
    @Environment(AppModel.self) private var modele
    let bloc: Block
    let guideId: String

    var body: some View {
        switch bloc {
        case let .text(titre, texte):
            if let t = titre { Titre(texte: t) }
            Carte { Text(texte) }

        case let .alert(texte):
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(Charte.danger)
                Text(texte).font(.callout.weight(.semibold))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Charte.secours, lineWidth: 1.5))

        case let .tip(titre, texte):
            VStack(alignment: .leading, spacing: 4) {
                Text(titre ?? "Bon à savoir").font(.subheadline.bold())
                Text(texte).font(.callout)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
            .overlay(alignment: .leading) { Rectangle().fill(Charte.securite).frame(width: 4) }
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case let .steps(titre, items):
            if let t = titre { Titre(texte: t) }
            Carte {
                ForEach(Array(items.enumerated()), id: \.offset) { i, item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(i + 1)").font(.footnote.bold()).foregroundStyle(.white)
                            .frame(width: 26, height: 26).background(Circle().fill(Charte.balise))
                        Text(item)
                    }
                    if i < items.count - 1 { Divider() }
                }
            }

        case let .list(titre, items):
            if let t = titre { Titre(texte: t) }
            Carte { ForEach(items, id: \.self) { Text("• \($0)") } }

        case let .risk(titre, items):
            Carte {
                Text(titre).font(.headline)
                ForEach(items, id: \.self) { Text("• \($0)").font(.callout) }
            }

        case let .check(id, titre, items):
            if let t = titre { Titre(texte: t) }
            Carte {
                ForEach(Array(items.enumerated()), id: \.offset) { i, item in
                    let fait = modele.estCochee(id, i)
                    Button { modele.basculer(id, i) } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: fait ? "checkmark.square.fill" : "square")
                                .foregroundStyle(fait ? Charte.securite : Color.secondary).font(.title3)
                            Text(item).foregroundStyle(.primary).multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(fait ? .isSelected : [])
                }
            }

        case let .keyValue(titre, items):
            if let t = titre { Titre(texte: t) }
            TableauCleValeur(items: items)

        case let .plant(titre, items):
            Titre(texte: titre)
            TableauCleValeur(items: items)

        case let .numbers(titre, items):
            if let t = titre { Titre(texte: t) }
            Carte {
                ForEach(items, id: \.n) { num in
                    HStack(alignment: .top, spacing: 12) {
                        Text(num.n).font(.title3.weight(.heavy)).foregroundStyle(Charte.secours).frame(minWidth: 56, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text(num.label).font(.subheadline.bold())
                            Text(num.desc).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }

        case let .doDont(titre, dont):
            if let t = titre { Titre(texte: t) }
            Carte { ForEach(dont, id: \.self) { Label($0, systemImage: "xmark").foregroundStyle(.primary) } }

        case let .form(id, titre, fields):
            if let t = titre { Titre(texte: t) }
            Carte {
                ForEach(Array(fields.enumerated()), id: \.offset) { i, f in
                    let cle = "\(guideId).\(id).\(i)"
                    TextField(f, text: Binding(get: { modele.champ(cle) }, set: { modele.definirChamp(cle, $0) }))
                        .textFieldStyle(.roundedBorder)
                }
                Text("Enregistré seulement sur ce téléphone.").font(.caption2).foregroundStyle(.secondary)
            }

        case let .calc(titre, texte, parPersonne, unite):
            if let t = titre { Titre(texte: t) }
            Carte {
                Text(texte)
                Text("\(modele.foyer.personnes) personnes : \(modele.foyer.personnes * parPersonne) \(unite) à stocker").font(.headline)
            }

        case let .schema(s):
            VStack(spacing: 4) {
                Image(s.nomImage)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(s.alt)
                Text(s.titre).font(.caption).foregroundStyle(Color(hex: 0x4E5E54))
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(.white))

        }
    }
}

private struct TableauCleValeur: View {
    let items: [[String]]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, kv in
                VStack(alignment: .leading, spacing: 2) {
                    Text(kv.first ?? "").font(.subheadline.bold())
                    Text(kv.dropFirst().joined(separator: " ")).font(.callout).foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}
