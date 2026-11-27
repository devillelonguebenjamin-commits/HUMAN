import Foundation
import Observation
import SijamaisCore

/// Les onglets de l'application (variante A : l'assistant au centre).
enum Onglet: Hashable {
    case accueil, urgence, assistant, carte, savoir
}

/// Un échange avec l'assistant.
struct Echange: Identifiable {
    let id = UUID()
    let question: String
    var reponse: ReponseAssistant?
}

/// État de l'application. Tout est enregistré sur le téléphone, rien n'est envoyé.
@Observable
@MainActor
final class AppModel {
    let bibliotheque: GuideLibrary
    let moteur: MoteurRecherche
    private let assistant: Assistant
    let modeleAppleDisponible: Bool

    var onglet: Onglet = .accueil
    var echanges: [Echange] = []

    var priseEnMainTerminee: Bool { didSet { stockage.set(priseEnMainTerminee, forKey: Cle.priseEnMain) } }
    var commune: String { didSet { stockage.set(commune, forKey: Cle.commune) } }
    var usages: Set<String> { didSet { stockage.set(Array(usages), forKey: Cle.usages) } }
    var foyer: Foyer { didSet { enregistrer(foyer, cle: Cle.foyer) } }
    var listes: EtatListes { didSet { enregistrer(listes, cle: Cle.listes) } }
    var formulaires: [String: String] { didSet { stockage.set(formulaires, forKey: Cle.formulaires) } }
    /// Espace mairie (élus et agents) : ajoute les 5 guides de la commune aux réponses de l'assistant.
    var espaceMairie: Bool { didSet { stockage.set(espaceMairie, forKey: Cle.espaceMairie) } }

    private let stockage = UserDefaults.standard
    private enum Cle {
        static let priseEnMain = "priseEnMainTerminee"
        static let commune = "commune"
        static let usages = "usages"
        static let foyer = "foyer"
        static let listes = "listes"
        static let formulaires = "formulaires"
        static let espaceMairie = "espaceMairie"
    }

    init() {
        guard let url = Bundle.main.url(forResource: "guides", withExtension: "json"),
              let b = try? GuideLibrary(url: url) else {
            fatalError("Le fichier guides.json est absent ou illisible : il doit être dans les ressources de l'application.")
        }
        bibliotheque = b
        moteur = MoteurRecherche(bibliotheque: b)
        let reformulateur = ModeleApple.creer()
        modeleAppleDisponible = reformulateur?.estDisponible ?? false
        assistant = Assistant(moteur: moteur, reformulateur: reformulateur)

        let s = UserDefaults.standard
        priseEnMainTerminee = s.bool(forKey: Cle.priseEnMain)
        commune = s.string(forKey: Cle.commune) ?? ""
        usages = Set(s.stringArray(forKey: Cle.usages) ?? ["maison"])
        foyer = Self.lire(Foyer.self, cle: Cle.foyer) ?? Foyer()
        listes = Self.lire(EtatListes.self, cle: Cle.listes) ?? EtatListes()
        formulaires = (s.dictionary(forKey: Cle.formulaires) as? [String: String]) ?? [:]
        espaceMairie = s.bool(forKey: Cle.espaceMairie)
    }

    // MARK: Guides et préparation

    func guide(_ id: String) -> Guide? { bibliotheque.guide(id) }

    var score: ScorePreparation? {
        guard let kit = bibliotheque.guide("kit72h") else { return nil }
        return ScorePreparation.calculer(guideKit: kit, etat: listes)
    }

    func estCochee(_ liste: String, _ index: Int) -> Bool { listes.estCochee(liste: liste, index: index) }
    func basculer(_ liste: String, _ index: Int) { listes.basculer(liste: liste, index: index) }

    func champ(_ cle: String) -> String { formulaires[cle] ?? "" }
    func definirChamp(_ cle: String, _ valeur: String) { formulaires[cle] = valeur }

    // MARK: Assistant

    /// Réponse à un bouton de clarification : on affiche le libellé, on envoie la phrase prévue.
    func choisir(_ option: OptionClarification) {
        demander(option.question, affichage: option.libelle)
    }

    func demander(_ question: String, affichage: String? = nil) {
        let q = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        let echange = Echange(question: affichage ?? q)
        echanges.append(echange)
        let assistant = self.assistant
        let mairie = espaceMairie
        Task {
            let r = await assistant.repondre(q, espaceMairie: mairie)
            if let i = echanges.firstIndex(where: { $0.id == echange.id }) { echanges[i].reponse = r }
        }
    }

    // MARK: Prise en main

    func recommencerPriseEnMain() {
        priseEnMainTerminee = false
        onglet = .accueil
    }

    // MARK: Enregistrement

    private func enregistrer<T: Encodable>(_ valeur: T, cle: String) {
        if let data = try? JSONEncoder().encode(valeur) { stockage.set(data, forKey: cle) }
    }

    private static func lire<T: Decodable>(_ type: T.Type, cle: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: cle) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
