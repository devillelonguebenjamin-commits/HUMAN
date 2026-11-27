import SwiftUI
import SijamaisCore

// Espace enfants (27/11/2026). Règles : aucun lien vers l'extérieur, aucun achat, aucun assistant libre,
// rien n'est envoyé ; sortir de l'espace demande un contrôle parental.

enum PaletteEnfants {
    static func couleur(_ code: String) -> Color {
        switch code {
        case "c-r": Charte.secours
        case "c-v": Charte.securite
        case "c-b": Charte.eau
        case "c-j": Charte.danger
        case "c-o": Charte.feu
        default: Charte.preparation
        }
    }

    static func texte(_ code: String) -> Color { code == "c-j" ? Charte.encre : .white }

    static func symbole(_ picto: String) -> String {
        switch picto {
        case "croix": "cross.case.fill"
        case "coupure": "bolt.slash.fill"
        case "dae": "heart.fill"
        case "eclair": "cloud.bolt.fill"
        case "famille": "figure.2.and.child.holdinghands"
        case "flamme": "flame.fill"
        case "sirene": "megaphone.fill"
        case "vent": "wind"
        case "bulle": "bubble.left.and.bubble.right.fill"
        default: "star.fill"
        }
    }
}

/// L'Espace enfants, ouvert en plein écran depuis l'accueil.
struct EspaceEnfantsView: View {
    @Environment(AppModel.self) private var modele
    let fermer: () -> Void
    @State private var tranche = "6-10"
    @State private var controle = false

    var body: some View {
        NavigationStack {
            Group {
                if let e = modele.enfants {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            NavigationLink { AideEnfantView(espace: e) } label: {
                                HStack(spacing: 14) {
                                    Image(systemName: "hand.raised.fill").font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text(e.aide.titre).font(.title2.bold())
                                        Text("Appeler, montrer ma carte").font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(.white)
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 22).fill(Charte.secours))
                            }
                            .buttonStyle(.plain)

                            Picker("Âge", selection: $tranche) {
                                ForEach(e.tranches) { t in Text(t.titre).tag(t.id) }
                            }
                            .pickerStyle(.segmented)

                            if let t = e.tranches.first(where: { $0.id == tranche }) {
                                Text(t.sousTitre).font(.subheadline).foregroundStyle(.secondary)
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(t.modules) { m in
                                        // Pas d'achat dans l'Espace enfants : un module fermé renvoie vers un parent.
                                        if OffrePremium.moduleOuvert(m, abonne: modele.abonnement.actif) {
                                            NavigationLink { ModuleEnfantView(module: m) } label: { TuileModule(module: m, fait: modele.modulesTermines.contains(m.id), ferme: false) }
                                                .buttonStyle(.plain)
                                        } else {
                                            NavigationLink { ModuleFermeView(module: m) } label: { TuileModule(module: m, fait: false, ferme: true) }
                                                .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                            Text("Contenu en cours de relecture par un enseignant et un formateur aux premiers secours.")
                                .font(.caption2).foregroundStyle(.secondary)
                        }
                        .padding(16)
                    }
                } else {
                    Text("L'Espace enfants est introuvable dans cette version de l'application.").padding()
                }
            }
            .navigationTitle("Espace enfants")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sortir") { controle = true }
                }
            }
            .sheet(isPresented: $controle) {
                ControleParentalView { controle = false; fermer() }
                    .presentationDetents([.medium])
            }
        }
    }
}

private struct TuileModule: View {
    let module: EspaceEnfants.Module
    let fait: Bool
    var ferme = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: PaletteEnfants.symbole(module.picto)).font(.title)
                Spacer()
                if fait { Image(systemName: "star.circle.fill").font(.title2) }
                if ferme { Image(systemName: "lock.fill").font(.title3) }
            }
            Spacer(minLength: 0)
            Text(module.titre).font(.headline).multilineTextAlignment(.leading)
            if ferme { Text("Version famille").font(.caption2.bold()).opacity(0.85) }
        }
        .foregroundStyle(PaletteEnfants.texte(module.couleur))
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 18).fill(PaletteEnfants.couleur(module.couleur)))
        .opacity(ferme ? 0.6 : 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(module.titre + (fait ? ", terminé" : ""))
    }
}

/// Module de la version famille, quand le foyer n'est pas abonné : aucun achat ici, l'enfant demande à un parent.
struct ModuleFermeView: View {
    let module: EspaceEnfants.Module

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill").font(.system(size: 50)).foregroundStyle(PaletteEnfants.couleur(module.couleur))
            Text(module.titre).font(.title2.bold())
            Text("Ce module fait partie de la version famille. Demande à un parent : il peut l'ouvrir depuis l'écran Premium de SIJAMAIS.")
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .navigationTitle(module.titre)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Contrôle parental : une multiplication, pour sortir de l'espace ou modifier la carte.
struct ControleParentalView: View {
    let reussi: () -> Void
    @State private var controle = ControleParental.nouveau()
    @State private var saisie = ""
    @State private var erreur = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Pour les parents").font(.headline)
            Text(controle.question).font(.title.bold())
            TextField("Réponse", text: $saisie)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 200)
                .multilineTextAlignment(.center)
            if erreur { Text("Ce n'est pas la bonne réponse.").font(.footnote).foregroundStyle(Charte.secours) }
            Button {
                if controle.verifier(saisie) { reussi() } else { erreur = true; saisie = ""; controle = .nouveau() }
            } label: {
                Text("Valider").bold().padding(.horizontal, 28).padding(.vertical, 10)
                    .background(Capsule().fill(Charte.balise)).foregroundStyle(.white)
            }
        }
        .padding(24)
    }
}

/// « J'ai besoin d'aide » : trois gros boutons, toujours gratuits.
struct AideEnfantView: View {
    @Environment(AppModel.self) private var modele
    let espace: EspaceEnfants
    @State private var controle = false
    @State private var edition = false

    private func champ(_ i: Int) -> String { modele.carteEnfant.indices.contains(i) ? modele.carteEnfant[i] : "" }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(espace.aide.boutons, id: \.self) { b in
                    bouton(b)
                }
                Button("Remplir ou modifier ma carte (pour les parents)") { controle = true }
                    .font(.footnote)
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .navigationTitle(espace.aide.titre)
        .sheet(isPresented: $controle) {
            ControleParentalView { controle = false; edition = true }.presentationDetents([.medium])
        }
        .sheet(isPresented: $edition) { CarteEditionView(espace: espace) }
    }

    @ViewBuilder
    private func bouton(_ b: EspaceEnfants.Bouton) -> some View {
        let fond = PaletteEnfants.couleur(b.couleur)
        let contenu = Text(b.label).font(.title2.bold()).frame(maxWidth: .infinity).padding(.vertical, 26)
            .foregroundStyle(PaletteEnfants.texte(b.couleur))
            .background(RoundedRectangle(cornerRadius: 22).fill(fond))
        switch b.action {
        case "112":
            if let url = URL(string: "tel:112") { Link(destination: url) { contenu } }
        case "parent":
            let tel = champ(1).filter { $0.isNumber || $0 == "+" }
            if !tel.isEmpty, let url = URL(string: "tel:\(tel)") {
                Link(destination: url) { contenu }
            } else {
                VStack(spacing: 6) {
                    contenu.opacity(0.5)
                    Text("Demande à un parent de remplir ta carte.").font(.footnote)
                }
            }
        default:
            NavigationLink { CarteAdulteView(espace: espace) } label: { contenu }.buttonStyle(.plain)
        }
    }
}

/// La carte à montrer à un adulte : grande, lisible, sans rien à toucher.
struct CarteAdulteView: View {
    @Environment(AppModel.self) private var modele
    let espace: EspaceEnfants

    private func champ(_ i: Int) -> String { modele.carteEnfant.indices.contains(i) ? modele.carteEnfant[i] : "" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(espace.phraseCarte(prenom: champ(0))).font(.title2.bold())
                ForEach(Array(espace.aide.carteAdulte.champs.enumerated()).dropFirst(), id: \.offset) { i, titre in
                    if !champ(i).isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(titre).font(.subheadline).foregroundStyle(.secondary)
                            Text(champ(i)).font(.title.bold())
                        }
                    }
                }
                if champ(1).isEmpty {
                    Text("La carte n'est pas encore remplie : demande à un parent.").foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(espace.aide.carteAdulte.titre)
    }
}

/// Remplissage de la carte par un parent.
struct CarteEditionView: View {
    @Environment(AppModel.self) private var modele
    @Environment(\.dismiss) private var fermer
    let espace: EspaceEnfants
    @State private var valeurs: [String] = []

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(Array(espace.aide.carteAdulte.champs.enumerated()), id: \.offset) { i, titre in
                        TextField(titre, text: Binding(get: { valeurs.indices.contains(i) ? valeurs[i] : "" },
                                                       set: { if valeurs.indices.contains(i) { valeurs[i] = $0 } }))
                            .keyboardType(titre.lowercased().contains("téléphone") ? .phonePad : .default)
                    }
                } footer: {
                    Text(espace.aide.carteAdulte.stockage)
                }
            }
            .navigationTitle("Carte de l'enfant")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") { modele.carteEnfant = valeurs; fermer() }
                }
                ToolbarItem(placement: .cancellationAction) { Button("Annuler") { fermer() } }
            }
            .onAppear {
                let n = espace.aide.carteAdulte.champs.count
                valeurs = (0..<n).map { modele.carteEnfant.indices.contains($0) ? modele.carteEnfant[$0] : "" }
            }
        }
    }
}

/// Un module : la leçon phrase par phrase, puis le quiz, puis un badge.
struct ModuleEnfantView: View {
    @Environment(AppModel.self) private var modele
    let module: EspaceEnfants.Module
    @State private var etape = 0
    @State private var choisi: Int? = nil
    @State private var bonnes = 0

    private var nbLecon: Int { module.lecon.count }
    private var total: Int { nbLecon + module.quiz.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ProgressView(value: Double(min(etape, total)), total: Double(total)).tint(PaletteEnfants.couleur(module.couleur))
                if etape < nbLecon {
                    lecon(module.lecon[etape])
                } else if etape < total {
                    question(module.quiz[etape - nbLecon])
                } else {
                    fin
                }
            }
            .padding(20)
        }
        .navigationTitle(module.titre)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func lecon(_ phrase: String) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: PaletteEnfants.symbole(module.picto)).font(.system(size: 44))
                .foregroundStyle(PaletteEnfants.couleur(module.couleur))
            Text(phrase).font(.title2)
            boutonSuite("Suivant") { etape += 1 }
        }
    }

    private func question(_ q: EspaceEnfants.Question) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Que fais-tu ?").font(.subheadline.bold()).foregroundStyle(.secondary)
            Text(q.situation).font(.title3.bold())
            ForEach(Array(q.choix.enumerated()), id: \.offset) { i, c in
                Button {
                    guard choisi == nil else { return }
                    choisi = i
                    if c.juste { bonnes += 1 }
                } label: {
                    HStack {
                        Text(c.t).multilineTextAlignment(.leading)
                        Spacer()
                        if choisi == i { Image(systemName: c.juste ? "checkmark.circle.fill" : "arrow.uturn.left.circle.fill") }
                    }
                    .font(.headline)
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(fond(c, i)))
                }
                .buttonStyle(.plain)
            }
            if let i = choisi {
                let c = q.choix[i]
                Text(c.pourquoi).font(.body).padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill((c.juste ? Charte.securite : Charte.danger).opacity(0.18)))
                if c.juste {
                    boutonSuite("Continuer") { choisi = nil; etape += 1 }
                } else {
                    boutonSuite("Réessayer") { choisi = nil }
                }
            }
        }
    }

    private func fond(_ c: EspaceEnfants.Choix, _ i: Int) -> Color {
        guard choisi == i else { return Color(.secondarySystemBackground) }
        return (c.juste ? Charte.securite : Charte.danger).opacity(0.3)
    }

    private var fin: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill").font(.system(size: 80)).foregroundStyle(Charte.danger)
            Text("Bravo !").font(.largeTitle.bold())
            Text("Tu as terminé « \(module.titre) ».").font(.title3).multilineTextAlignment(.center)
            boutonSuite("Recommencer") { etape = 0; bonnes = 0 }
        }
        .frame(maxWidth: .infinity)
        .onAppear { modele.modulesTermines.insert(module.id) }
    }

    private func boutonSuite(_ titre: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(titre).font(.headline).frame(maxWidth: .infinity).padding(14)
                .background(Capsule().fill(Charte.balise)).foregroundStyle(.white)
        }
    }
}
