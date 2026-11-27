import SwiftUI
import SijamaisCore

/// Affiche un texte juridique embarqué (conditions d'utilisation, politique de confidentialité).
struct LegalView: View {
    let nom: DocumentLegal.Nom

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let d = DocumentLegal.integre(nom) {
                    ForEach(Array(d.blocs.enumerated()), id: \.offset) { _, b in
                        switch b {
                        case let .titre(t): Text(t).font(.title2.bold())
                        case let .sousTitre(t): Text(t).font(.headline).padding(.top, 8)
                        case let .puce(t): Text("• \(t)")
                        case let .paragraphe(t): Text(t)
                        }
                    }
                } else {
                    Text("Texte introuvable dans cette version de l'application.")
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(nom.titre)
        .navigationBarTitleDisplayMode(.inline)
    }
}
