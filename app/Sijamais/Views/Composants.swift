import SwiftUI
import SijamaisCore

/// Grande tuile de couleur à pictogramme (signalétique de sécurité).
struct Tuile: View {
    let titre: String
    var sousTitre: String? = nil
    let symbole: String
    let signal: Signal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbole).font(.system(size: 30, weight: .semibold))
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 2) {
                Text(titre).font(.subheadline.bold()).multilineTextAlignment(.leading)
                if let s = sousTitre { Text(s).font(.caption).opacity(0.9).multilineTextAlignment(.leading) }
            }
        }
        .foregroundStyle(signal.texte)
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(signal.fond))
    }
}

/// Petit carré de couleur à pictogramme, en tête de ligne.
struct Pastille: View {
    let symbole: String
    let signal: Signal

    var body: some View {
        Image(systemName: symbole)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(signal.texte)
            .frame(width: 34, height: 34)
            .background(RoundedRectangle(cornerRadius: 9).fill(signal.fond))
    }
}

/// Bandeau « Urgence vitale » avec les boutons d'appel du 15 et du 112.
struct BandeauUrgenceVitale: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "cross.case.fill").font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text("Urgence vitale").font(.headline)
                Text("114 par SMS").font(.caption)
            }
            Spacer()
            BoutonAppel(numero: "15")
            BoutonAppel(numero: "112")
        }
        .foregroundStyle(.white)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(Charte.secours))
    }
}

struct BoutonAppel: View {
    let numero: String

    var body: some View {
        if let url = URL(string: "tel:\(numero)") {
            Link(destination: url) {
                Text(numero).font(.title3.weight(.heavy))
                    .foregroundStyle(Charte.secours)
                    .frame(minWidth: 52).padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            }
            .accessibilityLabel("Appeler le \(numero)")
        }
    }
}

/// Badge « Consigne officielle » ou « Conseil pratique ».
struct BadgeNiveau: View {
    let niveau: Niveau

    var body: some View {
        Text(niveau == .officiel ? "Consigne officielle" : "Conseil pratique")
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(niveau == .officiel ? Charte.securite.opacity(0.18) : Color.secondary.opacity(0.18)))
            .foregroundStyle(niveau == .officiel ? Charte.securite : Color.secondary)
    }
}

/// Ligne de liste vers un guide.
struct LigneGuide: View {
    let guide: Guide

    var body: some View {
        let p = Pictos.pour(guide: guide.id, categorie: guide.cat)
        HStack(spacing: 12) {
            Pastille(symbole: p.symbole, signal: p.signal)
            VStack(alignment: .leading, spacing: 2) {
                Text(guide.titre).font(.body)
                Text(guide.resume).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
}
