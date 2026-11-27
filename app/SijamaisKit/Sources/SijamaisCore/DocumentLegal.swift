import Foundation

/// Textes juridiques embarqués (contenus/legal) : conditions d'utilisation et politique de confidentialité.
/// Apple exige qu'ils soient consultables dans l'application pour tout abonnement.
public struct DocumentLegal: Sendable {
    public enum Bloc: Sendable, Equatable {
        case titre(String)
        case sousTitre(String)
        case puce(String)
        case paragraphe(String)
    }

    public enum Nom: String, Sendable, CaseIterable {
        case conditions = "conditions_utilisation"
        case confidentialite = "politique_confidentialite"

        public var titre: String { self == .conditions ? "Conditions d'utilisation" : "Politique de confidentialité" }
    }

    public let blocs: [Bloc]

    /// Lecture d'un Markdown simple : « # », « ## », « - » et paragraphes ; le gras « ** » est retiré.
    public init(markdown: String) {
        blocs = markdown.split(separator: "\n", omittingEmptySubsequences: true).map { ligne in
            let l = String(ligne).replacingOccurrences(of: "**", with: "")
            if l.hasPrefix("## ") { return .sousTitre(String(l.dropFirst(3))) }
            if l.hasPrefix("# ") { return .titre(String(l.dropFirst(2))) }
            if l.hasPrefix("- ") { return .puce(String(l.dropFirst(2))) }
            return .paragraphe(l)
        }
    }

    public static func integre(_ nom: Nom) -> DocumentLegal? {
        guard let url = Bundle.module.url(forResource: nom.rawValue, withExtension: "md"),
              let texte = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return DocumentLegal(markdown: texte)
    }
}
