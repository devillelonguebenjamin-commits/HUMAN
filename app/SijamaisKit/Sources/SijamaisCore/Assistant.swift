import Foundation

/// Réponse affichée par l'assistant.
public struct ReponseAssistant: Sendable, Equatable {
    public enum Mode: Sendable, Equatable {
        /// La personne décrit sa propre urgence de santé : appeler les secours, tout de suite.
        case urgencePersonnelle
        /// Étapes exactes d'un guide de santé, sans reformulation (niveau 3).
        case urgenceSante
        /// Texte rédigé par le modèle d'Apple à partir des passages (niveau 2).
        case reformulee
        /// Passages du guide affichés tels quels (niveau 1).
        case passages
        /// Aucun guide pertinent, ou hors périmètre : `texte` donne alors l'orientation (15, pharmacien, mairie...).
        case aucunGuide
        /// Demande ambiguë : `texte` est la question posée en retour, `options` les boutons de réponse.
        case clarification
    }

    public let mode: Mode
    public let texte: String?
    public let lignes: [String]
    public let guideId: String?
    public let guideTitre: String?
    public let urgenceVitale: Bool
    /// Boutons de réponse rapide (mode clarification).
    public let options: [OptionClarification]
    /// Question écrite en anglais : l'écran ajoute « Emergency: call 112 ».
    public let enAnglais: Bool

    public init(mode: Mode, texte: String?, lignes: [String], guideId: String?, guideTitre: String?, urgenceVitale: Bool,
                options: [OptionClarification] = [], enAnglais: Bool = false) {
        self.mode = mode
        self.texte = texte
        self.lignes = lignes
        self.guideId = guideId
        self.guideTitre = guideTitre
        self.urgenceVitale = urgenceVitale
        self.options = options
        self.enAnglais = enAnglais
    }

    func enAnglais(_ oui: Bool) -> ReponseAssistant {
        ReponseAssistant(mode: mode, texte: texte, lignes: lignes, guideId: guideId, guideTitre: guideTitre, urgenceVitale: urgenceVitale, options: options, enAnglais: oui)
    }
}

/// Ce que le modèle de langage doit renvoyer (génération guidée côté iPhone).
public struct ReformulationModele: Sendable, Equatable {
    public let texte: String
    public let guidesCites: [String]

    public init(texte: String, guidesCites: [String]) {
        self.texte = texte
        self.guidesCites = guidesCites
    }
}

/// Un modèle capable de reformuler des passages. Sur iPhone : le modèle d'Apple (Foundation Models).
public protocol Reformulateur: Sendable {
    /// Vrai si le modèle est utilisable sur cet appareil (iPhone compatible, Apple Intelligence activée).
    var estDisponible: Bool { get }
    func reformuler(question: String, passages: [String], guideId: String) async throws -> ReformulationModele
}

/// Règles de l'assistant (voir 12_assistant_ia_local.md) :
/// rien qui ne soit pas dans un guide ; santé : jamais de reformulation ; tout refus ou doute : passages du guide.
public struct Assistant: Sendable {
    public static let consignes = """
    Tu es l'assistant de l'application SIJAMAIS. Tu réponds en français, en cinq phrases au plus, \
    uniquement à partir des passages fournis. Si les passages ne répondent pas à la question, dis-le. \
    Tu cites l'identifiant de chaque guide utilisé. Tu ne donnes aucun conseil médical au-delà des passages.
    """

    public static let longueurMaxReformulation = 900

    public static let messageUrgencePersonnelle = "Appelez le 15 ou le 112 maintenant. Si vous ne pouvez pas parler, envoyez un SMS au 114. Restez en ligne et suivez les consignes des secours."

    private let moteur: MoteurRecherche
    private let reformulateur: Reformulateur?

    public init(moteur: MoteurRecherche, reformulateur: Reformulateur?) {
        self.moteur = moteur
        self.reformulateur = reformulateur
    }

    /// Invite envoyée au modèle : la question et les passages, rien d'autre.
    public static func invite(question: String, passages: [String], guideId: String) -> String {
        var s = "Question : \(question)\n\nPassages du guide « \(guideId) » :\n"
        for (i, p) in passages.enumerated() { s += "\(i + 1). \(p)\n" }
        return s
    }

    /// Une reformulation n'est acceptée que si elle cite le guide fourni, et lui seul, et reste courte.
    public static func reformulationAcceptable(_ r: ReformulationModele, guideId: String) -> Bool {
        let texte = r.texte.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texte.isEmpty, texte.count <= longueurMaxReformulation else { return false }
        guard !r.guidesCites.isEmpty, r.guidesCites.allSatisfy({ $0 == guideId }) else { return false }
        return true
    }

    public func repondre(_ question: String) async -> ReponseAssistant {
        let anglais = Triage.semblerAnglais(question)
        return await repondreSansLangue(question).enAnglais(anglais)
    }

    private func repondreSansLangue(_ question: String) async -> ReponseAssistant {
        let guides = moteur.guidesParId
        switch Triage.decider(question, guides: guides) {
        case let .horsPerimetre(message, vital):
            return ReponseAssistant(mode: .aucunGuide, texte: message, lignes: [], guideId: nil, guideTitre: nil, urgenceVitale: vital)
        case let .clarification(q, options):
            return ReponseAssistant(mode: .clarification, texte: q, lignes: [], guideId: nil, guideTitre: nil, urgenceVitale: true, options: options)
        case .urgencePersonnelle:
            return ReponseAssistant(mode: .urgencePersonnelle, texte: Self.messageUrgencePersonnelle, lignes: [], guideId: nil, guideTitre: nil, urgenceVitale: true)
        case let .sante(id, lignes):
            return ReponseAssistant(mode: .urgenceSante, texte: nil, lignes: lignes, guideId: id, guideTitre: guides[id]?.titre, urgenceVitale: true)
        case let .guide(id):
            let r = moteur.chercher(question, dans: id)
            guard let g = r.guide ?? guides[id] else { return await rechercher(question) }
            let passages = r.passages.isEmpty ? Array(Triage.listes(id, guides).prefix(3)) : r.passages
            return await informer(question: question, guide: g, passages: passages)
        case let .recherche(texte):
            return await rechercher(texte)
        }
    }

    private func rechercher(_ question: String) async -> ReponseAssistant {
        let r = moteur.chercher(question)
        if r.sensible && MoteurRecherche.parleDeSoi(question) {
            return ReponseAssistant(mode: .urgencePersonnelle, texte: Self.messageUrgencePersonnelle, lignes: [], guideId: r.guide?.id, guideTitre: r.guide?.titre, urgenceVitale: true)
        }
        guard let g = r.guide else {
            return ReponseAssistant(mode: .aucunGuide, texte: nil, lignes: [], guideId: nil, guideTitre: nil, urgenceVitale: r.sensible)
        }
        if r.sensible {
            return ReponseAssistant(mode: .urgenceSante, texte: nil, lignes: r.lignesAAfficher, guideId: g.id, guideTitre: g.titre, urgenceVitale: true)
        }
        return await informer(question: question, guide: g, passages: r.passages)
    }

    /// Question d'information : passages du guide, reformulés par le modèle d'Apple quand c'est permis.
    private func informer(question: String, guide g: Guide, passages lignes: [String]) async -> ReponseAssistant {
        let passages = ReponseAssistant(mode: .passages, texte: nil, lignes: lignes, guideId: g.id, guideTitre: g.titre, urgenceVitale: false)
        guard let modele = reformulateur, modele.estDisponible, !g.sensible else { return passages }
        do {
            let ref = try await modele.reformuler(question: question, passages: lignes, guideId: g.id)
            guard Self.reformulationAcceptable(ref, guideId: g.id) else { return passages }
            return ReponseAssistant(mode: .reformulee, texte: ref.texte, lignes: lignes, guideId: g.id, guideTitre: g.titre, urgenceVitale: false)
        } catch {
            // Refus des garde-fous, erreur, modèle indisponible : on montre le guide, sans rien inventer.
            return passages
        }
    }
}
