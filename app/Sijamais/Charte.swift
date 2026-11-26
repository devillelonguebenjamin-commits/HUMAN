import SwiftUI

/// Couleurs de la charte SIJAMAIS et code couleur de la signalétique de sécurité.
enum Charte {
    static let foret = Color(hex: 0x1F3B2D)
    static let balise = Color(hex: 0xE0662A)
    static let lichen = Color(hex: 0xF3F4EF)
    static let nuit = Color(hex: 0x17241C)

    // Signalétique (voir prototype/maquette_app/README.md)
    static let secours = Color(hex: 0xC8102E)
    static let danger = Color(hex: 0xF6C700)
    static let feu = Color(hex: 0xE0662A)
    static let eau = Color(hex: 0x005EB8)
    static let securite = Color(hex: 0x00843D)
    static let preparation = Color(hex: 0x2E5A43)
    static let neutre = Color(hex: 0x4A5A51)
    static let encre = Color(hex: 0x17241C)
}

/// Une couleur de tuile et la couleur du texte qui va dessus.
struct Signal {
    let fond: Color
    let texte: Color

    static let secours = Signal(fond: Charte.secours, texte: .white)
    static let danger = Signal(fond: Charte.danger, texte: Charte.encre)
    static let feu = Signal(fond: Charte.feu, texte: .white)
    static let eau = Signal(fond: Charte.eau, texte: .white)
    static let securite = Signal(fond: Charte.securite, texte: .white)
    static let preparation = Signal(fond: Charte.preparation, texte: .white)
    static let neutre = Signal(fond: Charte.neutre, texte: .white)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

/// Pictogramme et couleur de chaque guide (symboles SF de l'iPhone en attendant les pictogrammes définitifs).
enum Pictos {
    static func pour(guide id: String, categorie: String) -> (symbole: String, signal: Signal) {
        switch id {
        case "numeros", "trousses", "arret-cardiaque", "saignement", "inconscient-respire", "etouffement", "brulure":
            return ("cross.case.fill", .secours)
        case "alerte", "reflexes": return ("light.beacon.max.fill", .danger)
        case "abri-evacuation", "plan-evacuation": return ("figure.walk.departure", .securite)
        case "risques": return ("exclamationmark.triangle.fill", .danger)
        case "monoxyde": return ("aqi.high", .danger)
        case "coupure-electricite": return ("bolt.slash.fill", .danger)
        case "canicule": return ("thermometer.sun.fill", .feu)
        case "grand-froid": return ("thermometer.snowflake", .eau)
        case "cyberattaque", "cyberattaque-commune": return ("lock.trianglebadge.exclamationmark.fill", .eau)
        case "kit72h", "sac-evacuation", "stocks": return ("bag.fill", .preparation)
        case "pfms", "engagement": return ("person.2.fill", .securite)
        case "incendie-domicile", "feu": return ("flame.fill", .feu)
        case "eau": return ("drop.fill", .eau)
        case "orientation": return ("safari.fill", .neutre)
        case "communication", "desinformation": return ("bubble.left.and.text.bubble.right.fill", .eau)
        case "documents", "assurance": return ("doc.text.fill", .neutre)
        default:
            switch categorie {
            case "urgence": return ("cross.case.fill", .secours)
            case "preparer": return ("bag.fill", .preparation)
            case "survie": return ("tent.fill", .neutre)
            case "apres": return ("house.fill", .eau)
            default: return ("building.columns.fill", .preparation)
            }
        }
    }
}
