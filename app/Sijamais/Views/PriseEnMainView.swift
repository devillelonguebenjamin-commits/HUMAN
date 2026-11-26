import SwiftUI
import SijamaisCore

/// Prise en main en trois questions : aucun compte, aucune donnée envoyée.
struct PriseEnMainView: View {
    @Environment(AppModel.self) private var modele
    @State private var etape = 0

    private let usagesPossibles: [(String, String)] = [
        ("maison", "La maison et les crises"), ("randonnee", "Randonnée et montagne"), ("mer", "Mer et voile"),
        ("voyage", "Voyage à l'étranger"), ("camping", "Camping et van"), ("coupure", "Coupure prolongée"),
    ]

    var body: some View {
        @Bindable var modele = modele
        VStack(alignment: .leading, spacing: 18) {
            if etape > 0 {
                Text("Question \(etape) sur 3").font(.footnote).foregroundStyle(.secondary)
            }
            switch etape {
            case 0: accueil
            case 1: questionUsages
            case 2: questionCommune(commune: $modele.commune)
            default: questionFoyer(foyer: $modele.foyer)
            }
            Spacer()
            Button(action: suivant) {
                Text(etape == 0 ? "Commencer" : (etape == 3 ? "C'est prêt" : "Continuer"))
                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(Charte.balise)
        }
        .padding(24)
    }

    private var accueil: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 40)
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(Charte.lichen)
                .frame(width: 110, height: 110)
                .background(RoundedRectangle(cornerRadius: 26).fill(Charte.foret))
            (Text("SI").foregroundColor(Charte.balise) + Text("JAMAIS"))
                .font(.system(size: 36, weight: .bold))
            Text("Prêt, même hors réseau.").font(.title3).foregroundStyle(.secondary)
            Text("Trois questions, une minute. Aucun compte, aucune donnée envoyée.")
                .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center).padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
    }

    private var questionUsages: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pour quoi voulez-vous être prêt ?").font(.title.bold())
            Text("Plusieurs choix possibles. Vous pourrez changer plus tard.").foregroundStyle(.secondary)
            ForEach(usagesPossibles, id: \.0) { (cle, libelle) in
                let choisi = modele.usages.contains(cle)
                Button {
                    if choisi { modele.usages.remove(cle) } else { modele.usages.insert(cle) }
                } label: {
                    HStack {
                        Text(libelle)
                        Spacer()
                        Image(systemName: choisi ? "checkmark.circle.fill" : "circle")
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(choisi ? Charte.balise : Color.secondary.opacity(0.3), lineWidth: 1.5))
                }
                .foregroundStyle(choisi ? Charte.balise : Color.primary)
            }
        }
    }

    private func questionCommune(commune: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Où habitez-vous ?").font(.title.bold())
            TextField("Votre commune", text: commune)
                .textFieldStyle(.roundedBorder)
                .textContentType(.addressCity)
            Text("Sert à afficher les risques et les consignes de votre commune. Reste sur votre téléphone.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private func questionFoyer(foyer: Binding<Foyer>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Votre foyer").font(.title.bold())
            Stepper("Adultes : \(foyer.wrappedValue.adultes)", value: foyer.adultes, in: 0...12)
            Stepper("Enfants : \(foyer.wrappedValue.enfants)", value: foyer.enfants, in: 0...12)
            Stepper("Personnes âgées ou fragiles : \(foyer.wrappedValue.personnesFragiles)", value: foyer.personnesFragiles, in: 0...12)
            Stepper("Animaux : \(foyer.wrappedValue.animaux)", value: foyer.animaux, in: 0...12)
            Text("Pour calculer votre kit de 72 heures : \(foyer.wrappedValue.eau(litresParPersonne: 6)) litres d'eau à stocker.")
                .font(.footnote).foregroundStyle(.secondary)
            Text(modele.modeleAppleDisponible
                 ? "L'assistant hors ligne est disponible sur cet iPhone."
                 : "Sur cet iPhone, l'assistant affichera les passages des guides, sans reformulation.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private func suivant() {
        if etape < 3 { withAnimation { etape += 1 } } else { modele.priseEnMainTerminee = true }
    }
}
