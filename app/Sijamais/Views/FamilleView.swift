import SwiftUI
import SijamaisCore

/// Onglet d'accès « Famille » : avancement du plan familial, parcours pas à pas, carte d'urgence à partager.
struct FamilleView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        Group {
            if let plan = modele.planFamilial {
                let faites = plan.remplies(modele.champ)
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mon plan familial de mise en sûreté").font(.headline)
                            Text("\(faites) étape\(faites > 1 ? "s" : "") sur \(plan.etapes.count) remplie\(faites > 1 ? "s" : "")")
                                .font(.subheadline).foregroundStyle(.secondary)
                            ProgressView(value: Double(faites), total: Double(plan.etapes.count)).tint(Charte.securite)
                        }
                        .padding(.vertical, 4)
                        NavigationLink { AssistantPlanView(plan: plan) } label: {
                            Label(faites == 0 ? "Construire mon plan pas à pas" : "Continuer pas à pas", systemImage: "list.bullet.rectangle.fill")
                                .font(.headline).foregroundStyle(Charte.balise)
                        }
                        NavigationLink { if let g = modele.guide(plan.guide) { GuideView(guide: g) } } label: {
                            Label("Voir et modifier tout le plan", systemImage: "doc.text")
                        }
                    } footer: {
                        Text("Tout reste sur ce téléphone, disponible sans réseau.")
                    }
                    Section {
                        Text(carte(plan)).font(.footnote).textSelection(.enabled)
                        ShareLink(item: carte(plan)) { Label("Partager, imprimer ou envoyer à mes proches", systemImage: "square.and.arrow.up") }
                    } header: {
                        Text("Ma carte d'urgence")
                    } footer: {
                        Text("Recopiez l'essentiel sur une carte pour chaque membre de la famille, à garder dans le portefeuille ou le cartable des enfants.")
                    }
                }
            } else {
                Text("Le plan familial est introuvable dans cette version de l'application.")
            }
        }
        .navigationTitle("Famille")
    }

    /// Texte de la carte d'urgence, à partir des réponses enregistrées.
    private func carte(_ plan: PlanFamilial) -> String {
        var l = ["PLAN FAMILIAL DE MISE EN SÛRETÉ", "Urgences : 112 · SAMU 15 · Pompiers 18 · Police 17 · SMS 114"]
        for e in plan.etapes {
            let valeurs = e.cles.map { modele.champ($0) }.filter { !$0.isEmpty }
            guard !valeurs.isEmpty else { continue }
            l.append("\(e.question.replacingOccurrences(of: " ?", with: "")) : \(valeurs.joined(separator: " / "))")
        }
        return l.joined(separator: "\n")
    }
}

/// Assistant pas à pas : une question par écran, des choix rapides, un champ pour compléter.
struct AssistantPlanView: View {
    @Environment(AppModel.self) private var modele
    @Environment(\.dismiss) private var fermer
    let plan: PlanFamilial

    @State private var rang = 0
    @State private var reponse = ""
    @State private var risques: [String] = []
    @State private var termine = false

    private var etape: PlanFamilial.Etape { plan.etapes[rang] }

    var body: some View {
        ScrollView {
            if termine { fin } else { contenu }
        }
        .navigationTitle(termine ? "Plan terminé" : etape.titre)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: charger)
        .onChange(of: rang) { _, _ in charger() }
    }

    private var contenu: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Étape \(rang + 1) sur \(plan.etapes.count)").font(.caption).foregroundStyle(.secondary)
                ProgressView(value: Double(rang + 1), total: Double(plan.etapes.count)).tint(Charte.balise)
            }
            Text(etape.question).font(.title3.bold())
            if let aide = etape.aide {
                Label(aide, systemImage: "lightbulb.fill")
                    .font(.footnote)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            }
            switch etape.type {
            case .risques: listeRisques
            case .choix: choixRapides
            case .texte: EmptyView()
            }
            if etape.type != .risques {
                VStack(alignment: .leading, spacing: 4) {
                    if etape.type == .choix { Text("Vous pouvez compléter ou corriger :").font(.caption).foregroundStyle(.secondary) }
                    TextField(etape.exemple ?? "Votre réponse", text: $reponse, axis: .vertical)
                        .lineLimit(1...4)
                        .textFieldStyle(.roundedBorder)
                }
            }
            HStack {
                if rang > 0 { Button("Précédent") { rang -= 1 } }
                Spacer()
                Button("Passer") { avancer(enregistrer: false) }.foregroundStyle(.secondary)
                Button { avancer(enregistrer: true) } label: {
                    Text(rang == plan.etapes.count - 1 ? "Terminer" : "Suivant").bold()
                        .padding(.horizontal, 18).padding(.vertical, 10)
                        .background(Capsule().fill(Charte.balise)).foregroundStyle(.white)
                }
            }
            .padding(.top, 8)
        }
        .padding(16)
    }

    private var choixRapides: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(etape.choix) { c in
                let texte = etape.texte(pour: c)
                Button { reponse = texte } label: {
                    HStack {
                        Image(systemName: reponse == texte ? "largecircle.fill.circle" : "circle")
                        Text(c.libelle)
                        Spacer()
                    }
                    .font(.subheadline.bold())
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Charte.balise.opacity(reponse == texte ? 0.25 : 0.1)))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var listeRisques: some View {
        let max = etape.max ?? 4
        return VStack(alignment: .leading, spacing: 8) {
            Text("\(risques.count) sur \(max) au plus").font(.caption).foregroundStyle(.secondary)
            ForEach(etape.choix) { c in
                let v = etape.texte(pour: c)
                let coche = risques.contains(v)
                Button {
                    if coche { risques.removeAll { $0 == v } } else if risques.count < max { risques.append(v) }
                } label: {
                    HStack {
                        Image(systemName: coche ? "checkmark.square.fill" : "square")
                        Text(c.libelle)
                        Spacer()
                    }
                    .font(.subheadline.bold())
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Charte.balise.opacity(coche ? 0.25 : 0.1)))
                }
                .buttonStyle(.plain)
                .disabled(!coche && risques.count >= max)
            }
        }
    }

    private var fin: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Votre plan familial est prêt", systemImage: "checkmark.seal.fill").font(.title3.bold()).foregroundStyle(Charte.securite)
            Text("Montrez-le à chaque membre du foyer, testez l'itinéraire d'évacuation, et partagez la carte d'urgence avec vos proches depuis l'écran Famille.")
            Button { fermer() } label: {
                Text("Revenir à l'écran Famille").bold().frame(maxWidth: .infinity).padding(12)
                    .background(Capsule().fill(Charte.balise)).foregroundStyle(.white)
            }
        }
        .padding(16)
    }

    /// Reprend ce qui est déjà enregistré (dans le parcours ou dans le guide).
    private func charger() {
        switch etape.type {
        case .risques:
            let deja = etape.cles.map { modele.champ($0) }.filter { !$0.isEmpty }
            risques = deja.isEmpty ? etape.choix.filter { $0.parDefaut == true }.map { etape.texte(pour: $0) } : deja
        case .texte, .choix:
            let deja = modele.champ(etape.champ ?? "")
            reponse = deja.isEmpty && etape.id == "commune" ? modele.commune : deja
        }
    }

    private func avancer(enregistrer: Bool) {
        if enregistrer {
            switch etape.type {
            case .risques:
                for (i, cle) in etape.cles.enumerated() { modele.definirChamp(cle, i < risques.count ? risques[i] : "") }
            case .texte, .choix:
                if let c = etape.champ { modele.definirChamp(c, reponse.trimmingCharacters(in: .whitespacesAndNewlines)) }
                if etape.id == "commune", modele.commune.isEmpty { modele.commune = reponse }
            }
        }
        if rang < plan.etapes.count - 1 { rang += 1 } else { termine = true }
    }
}
