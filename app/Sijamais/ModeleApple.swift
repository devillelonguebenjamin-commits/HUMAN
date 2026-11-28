import Foundation
// Imports ciblés : le type « Guide » de SijamaisCore porterait le même nom que la macro @Guide de Foundation Models.
import protocol SijamaisCore.Reformulateur
import struct SijamaisCore.ReformulationModele
import struct SijamaisCore.Assistant

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Accès au modèle de langage d'Apple, sur l'iPhone, sans réseau (niveau 2 de l'assistant).
/// Renvoie nil sur les iPhone qui ne l'ont pas : l'assistant affiche alors les passages des guides.
enum ModeleApple {
    static func creer() -> Reformulateur? {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            return ReformulateurApple()
        }
        #endif
        return nil
    }
}

#if canImport(FoundationModels)
@available(iOS 26.0, *)
@Generable
struct ReponseGeneree {
    @Guide(description: "Réponse en français, en cinq phrases au plus, tirée uniquement des passages fournis.")
    var texte: String

    @Guide(description: "Identifiants des guides utilisés, recopiés exactement depuis la question.")
    var guidesCites: [String]
}

@available(iOS 26.0, *)
struct ReformulateurApple: Reformulateur {
    var estDisponible: Bool {
        if case .available = SystemLanguageModel.default.availability { return true }
        return false
    }

    func reformuler(question: String, passages: [String], guideId: String) async throws -> ReformulationModele {
        let session = LanguageModelSession(instructions: Assistant.consignes)
        let invite = Assistant.invite(question: question, passages: passages, guideId: guideId)
        let reponse = try await session.respond(to: invite, generating: ReponseGeneree.self)
        return ReformulationModele(texte: reponse.content.texte, guidesCites: reponse.content.guidesCites)
    }
}
#endif
