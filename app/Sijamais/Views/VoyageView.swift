import LocalAuthentication
import SwiftUI
import SijamaisCore

/// Mode Voyage. Gratuit : numéros d'urgence du pays, phrases vitales, Ariane. Premium : phrases pratiques,
/// liste de départ complète, dossier de voyage chiffré ouvert avec Face ID.
struct VoyageView: View {
    @Environment(AppModel.self) private var modele
    @AppStorage("voyagePays") private var codePays = ""

    var body: some View {
        if let v = modele.voyage {
            List {
                Section {
                    NavigationLink { ChoixPaysView(voyage: v, code: $codePays) } label: {
                        if let p = v.pays(codePays) {
                            Label { Text(p.nom).font(.headline) } icon: { Text(p.drapeau) }
                        } else {
                            Label("Choisir le pays de destination", systemImage: "globe.europe.africa.fill").font(.headline)
                        }
                    }
                }
                if let p = v.pays(codePays) {
                    NumerosPays(pays: p, avertissement: v.avertissement)
                } else {
                    Section {
                        Label("Dans toute l'Union européenne : 112", systemImage: "phone.fill").font(.headline).foregroundStyle(Charte.secours)
                    }
                }
                Section {
                    NavigationLink { PhrasesView(voyage: v, langueInitiale: v.pays(codePays)?.langue) } label: {
                        Label("Phrases d'urgence à montrer", systemImage: "text.bubble.fill")
                    }
                    NavigationLink { DepartView(voyage: v) } label: { Label("Avant de partir", systemImage: "checklist") }
                    if modele.abonnement.actif {
                        NavigationLink { DossierVoyageView(voyage: v, langue: v.pays(codePays)?.langue) } label: {
                            Label("Mon dossier de voyage (Face ID)", systemImage: "lock.doc.fill")
                        }
                    } else {
                        NavigationLink { PremiumView() } label: { Label("Mon dossier de voyage (Face ID)", systemImage: "lock.fill") }
                    }
                } header: { Text("Préparer et se faire comprendre") }
                Section {
                    Link(destination: URL(string: "https://www.diplomatie.gouv.fr/fr/conseils-aux-voyageurs/")!) {
                        Label("Conseils aux voyageurs (diplomatie.gouv.fr)", systemImage: "safari")
                    }
                    Link(destination: URL(string: "https://pastel.diplomatie.gouv.fr/fildariane/")!) {
                        Label("S'inscrire sur Ariane", systemImage: "bell.badge")
                    }
                } footer: {
                    Text("En cas de difficulté grave à l'étranger : l'ambassade ou le consulat de France. Ces deux liens demandent une connexion.")
                }
            }
            .navigationTitle("Voyage")
        } else {
            VStack(spacing: 12) {
                Text("Contenu du mode Voyage indisponible.").font(.headline)
                Text(Voyage.erreurChargement ?? "").font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Voyage")
        }
    }
}

/// Numéros du pays, avec bouton d'appel ; les numéros non encore vérifiés sont signalés.
private struct NumerosPays: View {
    let pays: Voyage.Pays
    let avertissement: String

    var body: some View {
        Section {
            ForEach(pays.numeros, id: \.self) { n in
                if let u = URL(string: "tel:\(n.numero)") {
                    Link(destination: u) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(n.service).font(.subheadline).foregroundStyle(.primary)
                                if !n.verifie { Text("À confirmer").font(.caption2.bold()).foregroundStyle(.orange) }
                            }
                            Spacer()
                            Text(n.numero).font(.title2.monospacedDigit().bold()).foregroundStyle(Charte.secours)
                            Image(systemName: "phone.fill").foregroundStyle(Charte.secours)
                        }
                    }
                    .accessibilityLabel("\(n.service), appeler le \(n.numero.map { String($0) }.joined(separator: " "))")
                }
            }
        } header: {
            Text("Urgences : \(pays.nom)")
        } footer: {
            Text(pays.toutVerifie ? pays.source : avertissement)
        }
    }
}

private struct ChoixPaysView: View {
    let voyage: Voyage
    @Binding var code: String
    @Environment(\.dismiss) private var fermer
    @State private var recherche = ""

    var body: some View {
        List {
            ForEach(Voyage.zones, id: \.self) { zone in
                let l = voyage.chercher(recherche).filter { $0.zone == zone }
                if !l.isEmpty {
                    Section(zone) {
                        ForEach(l) { p in
                            Button {
                                code = p.code
                                fermer()
                            } label: {
                                HStack {
                                    Text(p.drapeau)
                                    Text(p.nom).foregroundStyle(.primary)
                                    Spacer()
                                    if p.code == code { Image(systemName: "checkmark") }
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $recherche, prompt: "Pays")
        .navigationTitle("Destination")
    }
}

struct PhrasesView: View {
    @Environment(AppModel.self) private var modele
    let voyage: Voyage
    @State private var langue: String
    @State private var montree: Voyage.Phrase?

    init(voyage: Voyage, langueInitiale: String?) {
        self.voyage = voyage
        _langue = State(initialValue: langueInitiale ?? UserDefaults.standard.string(forKey: "voyageLangue") ?? "en")
    }

    var body: some View {
        let l = voyage.langue(langue)
        List {
            Section {
                Picker("Langue", selection: $langue) {
                    ForEach(voyage.langues) { Text("\($0.nom) (\($0.autonyme))").tag($0.code) }
                }
            } footer: {
                if l?.relu == false {
                    Text("Traduction en cours de relecture par un locuteur natif.")
                }
            }
            Section("Touchez une phrase pour l'afficher en grand") {
                ForEach(voyage.phrases) { p in
                    if p.gratuit || modele.abonnement.actif {
                        Button { montree = p } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(p.traductions[langue] ?? "").font(.headline).foregroundStyle(.primary)
                                    .environment(\.layoutDirection, l?.droiteAGauche == true ? .rightToLeft : .leftToRight)
                                Text(p.fr).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        NavigationLink { PremiumView() } label: {
                            Label(p.fr, systemImage: "lock.fill").foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Phrases")
        .onChange(of: langue) { _, n in UserDefaults.standard.set(n, forKey: "voyageLangue") }
        .fullScreenCover(item: $montree) { p in
            PhraseEnGrand(texte: p.traductions[langue] ?? "", francais: p.fr, droiteAGauche: l?.droiteAGauche == true)
        }
    }
}

/// Une phrase en très grand, à montrer à quelqu'un ; luminosité au maximum le temps de l'affichage.
private struct PhraseEnGrand: View {
    let texte: String
    let francais: String
    let droiteAGauche: Bool
    @Environment(\.dismiss) private var fermer
    @State private var luminosite: CGFloat = UIScreen.main.brightness

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text(texte)
                .font(.system(size: 44, weight: .bold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.4)
                .environment(\.layoutDirection, droiteAGauche ? .rightToLeft : .leftToRight)
            Text(francais).font(.title3).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Spacer()
            Button("Fermer") { fermer() }.buttonStyle(.borderedProminent).controlSize(.large)
        }
        .padding(24)
        .onAppear {
            luminosite = UIScreen.main.brightness
            UIScreen.main.brightness = 1
        }
        .onDisappear { UIScreen.main.brightness = luminosite }
    }
}

private struct DepartView: View {
    @Environment(AppModel.self) private var modele
    let voyage: Voyage
    @AppStorage("voyageDepartFait") private var faitsTexte = ""

    private var faits: Set<String> { Set(faitsTexte.split(separator: ",").map(String.init)) }

    private func basculer(_ id: String) {
        var f = faits
        if f.contains(id) { f.remove(id) } else { f.insert(id) }
        faitsTexte = f.sorted().joined(separator: ",")
    }

    var body: some View {
        List {
            Section {
                ForEach(voyage.depart) { d in
                    if d.gratuit || modele.abonnement.actif {
                        Button { basculer(d.id) } label: {
                            HStack(alignment: .top) {
                                Image(systemName: faits.contains(d.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(faits.contains(d.id) ? Charte.securite : .secondary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(d.titre).foregroundStyle(.primary)
                                    if !d.detail.isEmpty { Text(d.detail).font(.caption).foregroundStyle(.secondary) }
                                }
                            }
                        }
                    } else {
                        NavigationLink { PremiumView() } label: { Label(d.titre, systemImage: "lock.fill").foregroundStyle(.secondary) }
                    }
                }
            } footer: {
                Text("\(faits.count) sur \(voyage.depart.count) fait\(faits.count > 1 ? "s" : "")")
            }
        }
        .navigationTitle("Avant de partir")
    }
}

/// Dossier de voyage : chiffré dans le trousseau, ouvert avec Face ID (ou le code de l'iPhone).
private struct DossierVoyageView: View {
    let voyage: Voyage
    let langue: String?
    @State private var ouvert = false
    @State private var dossier = DossierVoyage()
    @State private var erreur: String?
    @State private var ficheMontree = false

    var body: some View {
        Group {
            if ouvert {
                Form {
                    Section("Le voyage") {
                        TextField("Destination", text: $dossier.destination)
                        TextField("Dates", text: $dossier.dates)
                        TextField("Hébergement (adresse, téléphone)", text: $dossier.hebergement, axis: .vertical)
                    }
                    Section("Papiers et assurance") {
                        TextField("Numéro de passeport", text: $dossier.passeport)
                        TextField("Assurance assistance", text: $dossier.assuranceNom)
                        TextField("Numéro de contrat", text: $dossier.assuranceContrat)
                        TextField("Téléphone d'assistance", text: $dossier.assuranceTelephone).keyboardType(.phonePad)
                        TextField("Opposition carte bancaire (téléphone)", text: $dossier.oppositionCarte).keyboardType(.phonePad)
                    }
                    Section("Santé") {
                        TextField("Groupe sanguin", text: $dossier.groupeSanguin)
                        TextField("Allergies", text: $dossier.allergies, axis: .vertical)
                        TextField("Traitements", text: $dossier.traitements, axis: .vertical)
                    }
                    Section("Contact en France") {
                        TextField("Nom", text: $dossier.contactNom)
                        TextField("Téléphone", text: $dossier.contactTelephone).keyboardType(.phonePad)
                    }
                    Section("Notes") { TextField("Notes", text: $dossier.notes, axis: .vertical) }
                    if !dossier.ficheSante(phrases: voyage.phrases, langue: langue).isEmpty {
                        Section { Button("Montrer ma fiche santé à un soignant") { ficheMontree = true } }
                    }
                    Section {
                        Text("Gardé chiffré sur ce téléphone seulement, jamais envoyé ni sauvegardé ailleurs.").font(.caption).foregroundStyle(.secondary)
                    }
                }
                .onChange(of: dossier) { _, d in
                    if let data = try? JSONEncoder().encode(d) { Coffre.ecrire("dossierVoyage", String(decoding: data, as: UTF8.self)) }
                }
                .sheet(isPresented: $ficheMontree) { FicheSanteView(lignes: dossier.ficheSante(phrases: voyage.phrases, langue: langue)) }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "lock.doc.fill").font(.system(size: 56)).foregroundStyle(Charte.securite)
                    Text("Dossier protégé").font(.title3.bold())
                    if let erreur { Text(erreur).font(.footnote).foregroundStyle(Charte.secours).multilineTextAlignment(.center) }
                    Button("Ouvrir avec Face ID") { deverrouiller() }.buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .navigationTitle("Dossier de voyage")
        .onAppear { deverrouiller() }
    }

    private func deverrouiller() {
        let contexte = LAContext()
        var e: NSError?
        // Face ID ou Touch ID, sinon le code de l'iPhone.
        guard contexte.canEvaluatePolicy(.deviceOwnerAuthentication, error: &e) else {
            erreur = "Activez un code sur l'iPhone pour protéger ce dossier."
            return
        }
        contexte.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Ouvrir votre dossier de voyage") { ok, _ in
            Task { @MainActor in
                if ok {
                    if let t = Coffre.lire("dossierVoyage"), let d = try? JSONDecoder().decode(DossierVoyage.self, from: Data(t.utf8)) { dossier = d }
                    ouvert = true
                    erreur = nil
                } else {
                    erreur = "Ouverture annulée."
                }
            }
        }
    }
}

private struct FicheSanteView: View {
    let lignes: [(fr: String, traduction: String?)]
    @Environment(\.dismiss) private var fermer

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(lignes.enumerated()), id: \.offset) { _, l in
                    VStack(alignment: .leading, spacing: 4) {
                        if let t = l.traduction { Text(t).font(.title3.bold()) }
                        Text(l.fr).font(.title3)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Fiche santé")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fermer") { fermer() } } }
        }
    }
}
