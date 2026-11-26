import Foundation

/// Réponse affichée par l'assistant.
public struct ReponseAssistant: Sendable, Equatable {
    public enum Mode: Sendable, Equatable {
        /// Étapes exactes d'un guide de santé, sans reformulation (niveau 3).
        case urgenceSante
        /// Texte rédigé par le modèle d'Apple à partir des passages (niveau 2).
        case reformulee
        /// Passages du guide affichés tels quels (niveau 1).
        case passages
        /// Aucun guide pertinent.
        case aucunGuide
    }

    public let mode: Mode
    public let texte: String?
    public let lignes: [String]
    public let guideId: String?
    public let guideTitre: String?
    public let urgenceVitale: Bool

    public init(mode: Mode, texte: String?, lignes: [String], guideId: String?, guideTitre: String?, urgenceVitale: Bool) {
        self.mode = mode
        self.texte = texte
        self.lignes = lignes
        self.guideId = guideId
        self.guideTitre = guideTitre
        self.urgenceVitale = urgenceVitale
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
        let r = moteur.chercher(question)
        guard let g = r.guide else {
            return ReponseAssistant(mode: .aucunGuide, texte: nil, lignes: [], guideId: nil, guideTitre: nil, urgenceVitale: r.sensible)
        }
        if r.sensible {
            return ReponseAssistant(mode: .urgenceSante, texte: nil, lignes: r.lignesAAfficher, guideId: g.id, guideTitre: g.titre, urgenceVitale: true)
        }
        let passages = ReponseAssistant(mode: .passages, texte: nil, lignes: r.passages, guideId: g.id, guideTitre: g.titre, urgenceVitale: false)
        guard let modele = reformulateur, modele.estDisponible, !g.sensible else { return passages }
        do {
            let ref = try await modele.reformuler(question: question, passages: r.passages, guideId: g.id)
            guard Self.reformulationAcceptable(ref, guideId: g.id) else { return passages }
            return ReponseAssistant(mode: .reformulee, texte: ref.texte, lignes: r.passages, guideId: g.id, guideTitre: g.titre, urgenceVitale: false)
        } catch {
            // Refus des garde-fous, erreur, modèle indisponible : on montre le guide, sans rien inventer.
            return passages
        }
    }
}
