import SwiftUI
import SijamaisCore

struct AssistantView: View {
    @Environment(AppModel.self) private var modele
    @State private var question = ""
    @FocusState private var saisieActive: Bool

    private let groupes: [(String, Signal, [String])] = [
        ("Urgence", .secours, ["Mon voisin ne respire plus", "Il s'étouffe avec un bonbon", "La sirène sonne, que faire ?"]),
        ("Coupures et crises", .danger, ["Plus de courant depuis hier", "Mon ordinateur demande une rançon", "Il fait 40 degrés chez moi"]),
        ("Se préparer", .preparation, ["Que mettre dans le kit ?", "Comment couper le gaz ?", "Combien d'eau stocker ?"]),
        ("Dehors, sans réseau", .neutre, ["Comment rendre l'eau potable ?", "Trouver le nord sans boussole"]),
        ("Après la crise", .eau, ["Délai pour déclarer à l'assurance"]),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { defilement in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Etat(disponible: modele.modeleAppleDisponible)
                        Bulle(estQuestion: false) {
                            Text("Posez votre question avec vos mots : je cherche dans les \(modele.bibliotheque.guides.count) guides de l'application et je cite toujours ma source. Pour une urgence vitale, appelez d'abord le 15 ou le 112.")
                        }
                        if modele.echanges.isEmpty { carteParcours }
                        ForEach(modele.echanges) { e in
                            Bulle(estQuestion: true) { Text(e.question) }
                            if let n = e.noeud {
                                EtapeParcours(noeud: n)
                            } else if let r = e.reponse {
                                ReponseVue(reponse: r)
                            } else {
                                ProgressView().padding(.leading, 12)
                            }
                        }
                        .id("fil")
                        if modele.echanges.isEmpty { suggestions; fonctionnement }
                    }
                    .padding(16)
                    Color.clear.frame(height: 1).id("fin")
                }
                .onChange(of: modele.echanges.count) { _, _ in
                    withAnimation { defilement.scrollTo("fin", anchor: .bottom) }
                }
            }
            saisie
        }
        .navigationTitle("Assistant")
    }

    /// Entrée principale : le parcours guidé, avant la saisie libre.
    private var carteParcours: some View {
        Button { modele.ouvrirParcours() } label: {
            HStack(spacing: 14) {
                Image(systemName: "list.bullet.rectangle.fill").font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Être guidé pas à pas").font(.headline)
                    Text("Quelques choix simples mènent à la bonne consigne").font(.footnote)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(.white)
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 18).fill(Charte.balise))
        }
        .buttonStyle(.plain)
    }

    private var saisie: some View {
        HStack(spacing: 8) {
            Button { modele.ouvrirParcours() } label: {
                Image(systemName: "list.bullet.rectangle").font(.system(size: 24))
            }
            .accessibilityLabel("Être guidé pas à pas")
            TextField("Que voulez-vous savoir ?", text: $question, axis: .vertical)
                .lineLimit(1...4)
                .focused($saisieActive)
                .submitLabel(.send)
                .onSubmit(envoyer)
            Button(action: envoyer) {
                Image(systemName: "arrow.up.circle.fill").font(.system(size: 32))
            }
            .disabled(question.trimmingCharacters(in: .whitespaces).isEmpty)
            .accessibilityLabel("Envoyer")
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Charte.balise, lineWidth: 1.5))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var suggestions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Questions fréquentes").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
            ForEach(groupes, id: \.0) { titre, signal, questions in
                VStack(alignment: .leading, spacing: 6) {
                    Text(titre).font(.caption2.bold()).padding(.horizontal, 8).padding(.vertical, 3)
                        .background(RoundedRectangle(cornerRadius: 6).fill(signal.fond)).foregroundStyle(signal.texte)
                    FlowLayout(spacing: 6) {
                        ForEach(questions, id: \.self) { q in
                            Button(q) { modele.demander(q) }
                                .font(.footnote)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(Capsule().strokeBorder(Color.secondary.opacity(0.4)))
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }

    private var fonctionnement: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Comment je fonctionne").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
            Label("Je cherche uniquement dans les guides relus de l'application.", systemImage: "book.closed.fill")
            Label("Je reformule sur votre iPhone, avec le modèle d'Apple, sans internet.", systemImage: "iphone")
            Label("Rien ne quitte votre téléphone.", systemImage: "lock.fill")
            Label("Santé : je vous renvoie au 15 ou au 112 et j'affiche les gestes du guide, mot pour mot.", systemImage: "cross.case.fill")
        }
        .font(.footnote)
        .padding(.top, 8)
    }

    private func envoyer() {
        modele.demander(question)
        question = ""
    }
}

private struct Etat: View {
    let disponible: Bool
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(disponible ? Charte.securite : Charte.danger).frame(width: 8, height: 8)
            Text(disponible ? "Modèle d'Apple, sur cet iPhone · hors ligne" : "Recherche dans les guides, sans IA, sur cet iPhone")
                .font(.caption)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Capsule().fill(Color(.secondarySystemBackground)))
    }
}

private struct Bulle<Contenu: View>: View {
    let estQuestion: Bool
    @ViewBuilder let contenu: Contenu
    var body: some View {
        HStack {
            if estQuestion { Spacer(minLength: 40) }
            VStack(alignment: .leading, spacing: 8) { contenu }
                .padding(12)
                .foregroundStyle(estQuestion ? Color.white : Color.primary)
                .background(RoundedRectangle(cornerRadius: 16).fill(estQuestion ? Charte.balise : Color(.secondarySystemBackground)))
            if !estQuestion { Spacer(minLength: 40) }
        }
    }
}

/// Une étape du parcours guidé : la question et un bouton par choix.
private struct EtapeParcours: View {
    @Environment(AppModel.self) private var modele
    let noeud: Parcours.Noeud

    var body: some View {
        Bulle(estQuestion: false) {
            Text(noeud.question).font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(noeud.options) { o in
                    Button { modele.suivre(o) } label: {
                        HStack(spacing: 10) {
                            if let s = o.symbole { Image(systemName: s).frame(width: 22) }
                            Text(o.libelle).multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                            if o.suivant != nil { Image(systemName: "chevron.right").font(.caption) }
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14).padding(.vertical, 11)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Charte.balise.opacity(0.12)))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct ReponseVue: View {
    @Environment(AppModel.self) private var modele
    let reponse: ReponseAssistant

    var body: some View {
        Bulle(estQuestion: false) {
            if reponse.urgenceVitale { BandeauUrgenceVitale() }
            if reponse.enAnglais {
                Label("Emergency: call 112 (free, works everywhere in Europe).", systemImage: "phone.fill")
                    .font(.subheadline.bold()).foregroundStyle(Charte.secours)
            }
            switch reponse.mode {
            case .aucunGuide:
                Text(reponse.texte ?? "Je n'ai pas trouvé de guide sur ce sujet. Je ne réponds qu'à partir des guides de l'application : essayez avec d'autres mots, ou ouvrez l'onglet Savoir.")
            case .clarification:
                Text(reponse.texte ?? "").font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(reponse.options, id: \.self) { o in
                        Button { modele.choisir(o) } label: {
                            Text(o.libelle).font(.subheadline.bold()).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Charte.balise.opacity(0.12)))
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Envoie cette réponse à l'assistant")
                    }
                }
            case .urgencePersonnelle:
                Text(reponse.texte ?? "").font(.headline)
                ForEach(reponse.lignes, id: \.self) { Text("• \($0)") }
            case .urgenceSante:
                Text("Étapes du guide relu, sans reformulation :").font(.subheadline.bold())
                ForEach(Array(reponse.lignes.enumerated()), id: \.offset) { i, l in Text("\(i + 1). \(l)") }
            case .reformulee:
                Text(reponse.texte ?? "")
            case .passages:
                Text("Extrait du guide, mot pour mot :").font(.subheadline.bold())
                ForEach(reponse.lignes, id: \.self) { Text("• \($0)") }
            }
            if reponse.guideId == "moral" && reponse.urgenceVitale, let tel = URL(string: "tel:3114") {
                Link(destination: tel) {
                    Label("Appeler le 3114 (gratuit, 24 h sur 24)", systemImage: "phone.fill")
                        .font(.subheadline.bold()).foregroundStyle(.white)
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Charte.secours))
                }
            }
                        if let id = reponse.guideId, let g = modele.guide(id) {
                NavigationLink { GuideView(guide: g) } label: {
                    HStack(spacing: 6) {
                        BadgeNiveau(niveau: g.niveau)
                        Text(Self.libelleOutil(g)).font(.footnote.bold()).foregroundStyle(Charte.balise)
                    }
                }
            }
        }
    }
}

extension ReponseVue {
    /// Lien vers l'outil du guide quand il en a un (calculateur, formulaire, liste à cocher), sinon vers le guide.
    static func libelleOutil(_ g: Guide) -> String {
        for b in g.blocs { if case let .calc(titre, _, _, _) = b { return "Calculer : \(titre ?? g.titre)" } }
        for b in g.blocs { if case .form = b { return "Remplir dans « \(g.titre) »" } }
        for b in g.blocs { if case .check = b { return "Cocher ma liste dans « \(g.titre) »" } }
        return "Ouvrir « \(g.titre) »"
    }
}

/// Disposition en lignes qui passent à la ligne, pour les suggestions.
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let largeur = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, hauteurLigne: CGFloat = 0, largeurMax: CGFloat = 0
        for v in subviews {
            let t = v.sizeThatFits(.unspecified)
            if x > 0, x + t.width > largeur { x = 0; y += hauteurLigne + spacing; hauteurLigne = 0 }
            x += t.width + spacing
            hauteurLigne = max(hauteurLigne, t.height)
            largeurMax = max(largeurMax, x)
        }
        return CGSize(width: min(largeurMax, largeur), height: y + hauteurLigne)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, hauteurLigne: CGFloat = 0
        for v in subviews {
            let t = v.sizeThatFits(.unspecified)
            if x > bounds.minX, x + t.width > bounds.maxX { x = bounds.minX; y += hauteurLigne + spacing; hauteurLigne = 0 }
            v.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(t))
            x += t.width + spacing
            hauteurLigne = max(hauteurLigne, t.height)
        }
    }
}
