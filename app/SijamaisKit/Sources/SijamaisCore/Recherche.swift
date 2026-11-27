import Foundation

/// Mise en forme du texte pour la recherche : minuscules, sans accents, sans ponctuation.
public enum Normalisation {
    private static let accents: [Character: String] = [
        "à": "a", "â": "a", "ä": "a", "á": "a", "ã": "a",
        "ç": "c",
        "é": "e", "è": "e", "ê": "e", "ë": "e",
        "î": "i", "ï": "i", "í": "i",
        "ô": "o", "ö": "o", "ó": "o",
        "ù": "u", "û": "u", "ü": "u", "ú": "u",
        "ÿ": "y", "ñ": "n",
        "œ": "oe", "æ": "ae",
    ]

    public static func normaliser(_ texte: String) -> String {
        var sortie = ""
        sortie.reserveCapacity(texte.count)
        for c in texte.lowercased() {
            if let r = accents[c] {
                sortie += r
            } else if c.isASCII, c.isLetter || c.isNumber {
                sortie.append(c)
            } else {
                sortie.append(" ")
            }
        }
        return sortie
    }
}

/// Résultat d'une recherche dans les guides.
public struct ResultatRecherche: Sendable {
    public let guide: Guide?
    public let passages: [String]
    public let score: Int
    /// Vrai pour une question de santé ou d'urgence vitale : aucune reformulation, bandeau 15 et 112.
    public let sensible: Bool

    /// Lignes à afficher : les étapes exactes du guide pour une question sensible, sinon les passages trouvés.
    public var lignesAAfficher: [String] {
        if sensible, let g = guide, !g.premieresEtapes.isEmpty { return g.premieresEtapes }
        return passages
    }
}

/// Recherche hors ligne dans les guides : niveau 1 de l'assistant, disponible sur tous les iPhone.
/// Même logique que la maquette (prototype/maquette_app), pour que les tests restent comparables.
public struct MoteurRecherche: Sendable {
    private struct Morceau: Sendable {
        let texte: String
        let normalise: String
    }
    private struct Entree: Sendable {
        let guide: Guide
        let titreNormalise: String
        let morceaux: [Morceau]
    }

    private let entrees: [Entree]
    public let seuil: Int
    /// Les guides par identifiant, pour le triage.
    public let guidesParId: [String: Guide]

    public init(bibliotheque: GuideLibrary, seuil: Int = 3) {
        self.seuil = seuil
        guidesParId = Dictionary(bibliotheque.guides.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
        entrees = bibliotheque.guides.map { g in
            var m: [Morceau] = []
            for b in g.blocs {
                for t in b.textesRecherche {
                    m.append(Morceau(texte: t, normalise: Normalisation.normaliser(b.titreBloc + " " + t)))
                }
            }
            return Entree(guide: g, titreNormalise: Normalisation.normaliser(g.titre + " " + g.resume), morceaux: m)
        }
    }

    static let motsVides: Set<String> = Set("""
    a au aux avec ce ces cet cette comment dans de des du elle en est et il ils j je l la le les leur lui ma mais me mes moi mon ne nos notre nous on ou par pas pour qu que quel quelle quels quelles qui quoi sa se ses si son sur ta te tes toi ton tu un une vos votre vous y d c s n m t faire fait faut dois doit peut peux suis sont etre avoir ai ont quand plus tout tous toute depuis hier aujourd hui chez
    """.split(separator: " ").map(String.init))

    static let synonymes: [String: [String]] = [
        "courant": ["electricite", "coupure"], "lumiere": ["electricite", "coupure"], "panne": ["coupure", "electricite"],
        "respire": ["respirer", "arret", "cardiaque", "massage"], "respirer": ["arret", "cardiaque"],
        "saigne": ["saignement", "plaie"], "sang": ["saignement"], "evanoui": ["inconsciente"], "repond": ["inconsciente"],
        "sirene": ["alerte", "signal", "sirene"], "sonne": ["sirene", "alerte"],
        "rancon": ["rancon", "bloque"], "ordinateur": ["appareil", "rancon"], "pirate": ["piratage", "compte"], "arnaque": ["arnaques", "suspect"],
        "potable": ["purifier", "eau", "bouillir"], "boire": ["eau"], "kit": ["kit", "urgence"], "sac": ["kit", "sac"],
        "chaud": ["canicule", "chaleur"], "chaleur": ["canicule"], "degres": ["canicule", "chaleur"], "froid": ["grand", "froid"],
        "nord": ["orientation", "nord"], "perdu": ["orientation"],
        "inondation": ["inondation"], "monte": ["inondation", "crue", "hauteur"], "crue": ["inondation"], "deborde": ["inondation", "crue"],
        "gaz": ["reseaux", "arrivees", "couper"], "couper": ["reseaux", "arrivees"],
        "eau": ["eau"], "feu": ["feu"], "brule": ["brulure"], "etouffe": ["etouffement"], "avale": ["etouffement"],
        "massage": ["massez", "masser", "compressions"], "rythme": ["minute", "fois"],
        "peur": ["moral", "stress"], "angoisse": ["moral", "stress"], "panique": ["moral", "stress"], "stresse": ["moral", "stress"], "triste": ["moral"],
        "assurance": ["assurance", "catastrophe"], "iode": ["iode", "nucleaire"], "seisme": ["seisme"], "tempete": ["tempete"],
        // Cycle 1 (27/11/2026) : mots courants et anglais.
        "sourd": ["114", "sms"], "sourde": ["114", "sms"], "malentendant": ["114", "sms"], "samu": ["15", "samu"], "pompiers": ["18", "pompiers"],
        "pharmacie": ["trousse", "familiale"], "trousse": ["trousse", "familiale"], "apprendre": ["former", "formation", "gestes"],
        "formation": ["former", "formation"], "applis": ["applications", "sauv"], "appli": ["applications", "sauv"],
        "sdf": ["abri", "115"], "abri": ["abri", "115"], "cauchemar": ["moral", "stress"], "cauchemars": ["moral", "stress"],
        "dae": ["defibrillateur"], "reanimation": ["massage", "cardiaque"], "pls": ["laterale", "securite"],
        "tourniquet": ["garrot"], "heimlich": ["etouffement", "poing"], "cloque": ["brulure"], "ebouillante": ["brulure"],
        "burn": ["brulure"], "burned": ["brulure"], "bleeding": ["saignement"], "choking": ["etouffement"], "breathe": ["respirer"],
        "breathing": ["respirer"], "unconscious": ["inconsciente"], "fire": ["feu", "incendie"], "flood": ["inondation"],
    ]

    /// Expressions de plusieurs mots (cycle 1) : cherchées dans la question préparée, elles ajoutent des mots du guide.
    static let expressions: [(String, [String])] = [
        ("repond plus", ["inconsciente"]), ("coeur arrete", ["arret", "cardiaque"]), ("crise cardiaque", ["arret", "cardiaque"]),
        ("pisse le sang", ["saignement"]), ("coupure profonde", ["saignement", "plaie"]), ("objet plante", ["saignement", "retirez"]),
        ("tombe dans les pommes", ["inconsciente"]), ("avale de travers", ["etouffement", "tousser"]), ("fausse route", ["etouffement"]),
        ("intoxication gaz", ["monoxyde"]), ("poele a petrole", ["monoxyde"]), ("peux pas parler", ["114", "sms"]), ("peut pas parler", ["114", "sms"]),
        ("secours en mer", ["196"]), ("samu social", ["115", "abri"]), ("sans abri", ["abri", "115"]), ("idees noires", ["3114", "moral"]),
        ("premiers secours", ["former", "formation", "gestes"]), ("pas bien", ["moral"]),
    ]

    static let termesSensibles: [String] = [
        "respire", "respirer", "saigne", "saignement", "sang", "inconscient", "inconsciente", "evanoui", "evanouie",
        "brule", "brulure", "etouffe", "etouffement", "malaise", "douleur", "poitrine", "fracture", "avale", "poison",
        "convulse", "convulsion",
    ]

    static func mots(_ texte: String) -> [String] {
        Triage.preparer(texte).split(separator: " ").map(String.init).filter { $0.count > 1 && !motsVides.contains($0) }
    }

    /// Racine grossière : retire la dernière lettre des mots longs, puis un e, s ou x final.
    static func racine(_ mot: String) -> String {
        guard mot.count > 5 else { return mot }
        var r = String(mot.dropLast())
        if let d = r.last, "esx".contains(d) { r.removeLast() }
        return r
    }

    /// Vrai si la personne parle d'elle-même (« je n'arrive plus à respirer », « j'ai mal à la poitrine »).
    public static func parleDeSoi(_ question: String) -> Bool {
        let tous = Normalisation.normaliser(question).split(separator: " ").map(String.init)
        return tous.contains { ["je", "j", "moi", "me", "m"].contains($0) }
    }

    public static func estSensible(_ question: String) -> Bool {
        mots(question).contains { m in termesSensibles.contains { m.hasPrefix($0) } }
    }

    public func chercher(_ question: String, dans guideId: String? = nil) -> ResultatRecherche {
        let ms = Self.mots(question)
        var etendus = ms
        for m in ms { etendus += Self.synonymes[m] ?? [] }
        let prepare = Triage.preparer(question)
        for (e, ajouts) in Self.expressions where prepare.contains(" " + e + " ") { etendus += ajouts }
        var vus = Set<String>()
        let racines = etendus.map(Self.racine).filter { vus.insert($0).inserted }
        let sensible = ms.contains { m in Self.termesSensibles.contains { m.hasPrefix($0) } }

        var meilleur: (entree: Entree, total: Int, passages: [String])?
        for e in entrees where guideId == nil || e.guide.id == guideId {
            let scores = e.morceaux.enumerated().map { (i, m) in
                (i, m, racines.reduce(0) { $0 + (m.normalise.contains($1) ? 1 : 0) })
            }
            let tries = scores.sorted { $0.2 != $1.2 ? $0.2 > $1.2 : $0.0 < $1.0 } // à égalité, l'ordre du guide est gardé
            let titre = racines.reduce(0) { $0 + (e.titreNormalise.contains($1) ? 2 : 0) }
            let total = titre + tries.prefix(3).reduce(0) { $0 + $1.2 }
            if meilleur == nil || total > meilleur!.total {
                let retenus = tries.filter { $0.2 > 0 }.prefix(3).sorted { $0.0 < $1.0 }.map { $0.1.texte }
                meilleur = (e, total, retenus)
            }
        }
        guard let m = meilleur, m.total >= (guideId == nil ? seuil : 0) else {
            return ResultatRecherche(guide: nil, passages: [], score: meilleur?.total ?? 0, sensible: sensible)
        }
        return ResultatRecherche(guide: m.entree.guide, passages: m.passages, score: m.total, sensible: sensible)
    }
}
