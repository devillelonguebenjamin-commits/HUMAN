import Foundation

/// Un bouton de réponse rapide proposé par l'assistant quand la demande est ambiguë.
/// `question` est la phrase renvoyée à l'assistant quand on appuie sur le bouton.
public struct OptionClarification: Sendable, Equatable, Hashable {
    public let libelle: String
    public let question: String

    public init(libelle: String, question: String) {
        self.libelle = libelle
        self.question = question
    }
}

/// Triage avant la recherche par mots (cycle 1 de l'assistant, règles 1 à 5, 27/11/2026) :
/// mots trompeurs, hors périmètre, signes sans guide (AVC, convulsions), urgence personnelle,
/// cas particuliers (mer, chaleur, nourrisson, toux), priorité entre urgences, clarification.
/// Tout ce que le triage affiche vient des guides, sauf les messages d'orientation (15, 112, pharmacien...).
public enum Triage {
    public enum Decision: Sendable, Equatable {
        /// Hors périmètre ou sans guide : un message d'orientation, sans rien inventer.
        case horsPerimetre(message: String, urgenceVitale: Bool)
        /// Demande ambiguë : une question fermée et 2 ou 3 boutons.
        case clarification(question: String, options: [OptionClarification])
        /// La personne décrit sa propre urgence vitale.
        case urgencePersonnelle
        /// Gestes exacts d'un guide de santé : les lignes sont prises mot pour mot dans les guides.
        case sante(guideId: String, lignes: [String])
        /// Consigne de risque majeur (cycle 2) : passages exacts des guides, jamais reformulés.
        case consigne(guideId: String, lignes: [String], urgenceVitale: Bool)
        /// Détresse suicidaire (cycle 5) : 3114, 15, 112, 114, jamais reformulé.
        case detressePsy(pourSoi: Bool, lignes: [String])
        /// Question d'information : recherche limitée à ce guide.
        case guide(id: String)
        /// Rien de particulier : recherche par mots habituelle, sur le texte éventuellement corrigé.
        case recherche(texte: String)
    }

    // MARK: Messages d'orientation (pas de contenu de guide)

    public static let messageSansGuideVital = "Appelez le 15 ou le 112 immédiatement (114 par SMS si vous ne pouvez pas parler). Je n'ai pas encore de guide sur ces signes : restez avec la personne et suivez les consignes des secours."
    public static let messageMedical = "Je ne donne ni diagnostic ni dose de médicament. Demandez conseil à un pharmacien ou à un médecin. En cas de signe grave ou de doute, appelez le 15."
    public static let messageVeterinaire = "Je n'ai pas de guide pour les animaux. Appelez un vétérinaire ; la nuit ou le week-end, cherchez le vétérinaire de garde."
    public static let messagePlantes = "Je ne conseille aucune plante pour soigner. Pour une plaie, demandez conseil à un pharmacien ; si elle saigne beaucoup, voyez le guide « Saignement abondant » et appelez le 15 ou le 112."
    public static let messageArmes = "Je ne donne pas de conseil sur les armes ni sur la défense. Si vous êtes en danger, appelez le 17 ou le 112 (114 par SMS si vous ne pouvez pas parler)."
    public static let messageBrulage = "Je n'ai pas de guide sur les feux de jardin. Les règles dépendent de votre commune et de la saison : renseignez-vous auprès de votre mairie ou sur service-public.gouv.fr."
    public static let messageTechnique = "Je n'ai pas de guide pour réparer un appareil. Pour une coupure de courant, voyez le guide « Coupure d'électricité »."
    public static let messageDigestif = "Je n'ai pas de guide sur les maux de ventre ou d'estomac. Demandez conseil à un pharmacien ou à un médecin. En cas de douleur forte ou de doute, appelez le 15."
    public static let messageSansGuideSante = "Je n'ai pas de guide sur ce sujet. Demandez conseil à un pharmacien ou à un médecin ; en cas de signe grave ou de doute, appelez le 15."
    public static let messagePetitePlaie = "Je n'ai pas de guide sur les petites plaies : demandez conseil à un pharmacien. Si le saignement est abondant ou ne s'arrête pas, appelez le 15 ou le 112."
    public static let messageChute = "Je n'ai pas de guide sur les chutes. Si la personne a mal, ne peut pas se relever ou semble confuse, appelez le 15 ou le 112 et suivez leurs consignes."

    // MARK: Préparation du texte

    /// Contractions courantes en langage SMS ou en dictée sans apostrophe.
    static let contractions: [String: String] = [
        "jai": "j ai", "jarrive": "j arrive", "jetouffe": "j etouffe", "jsuis": "je suis", "chui": "je suis", "jme": "je me",
        "jsais": "je sais", "jpeux": "je peux", "jvais": "je vais", "jfais": "je fais", "jai,": "j ai",
        "ya": "il y a", "yen": "il y en", "cest": "c est", "sest": "s est", "setouffe": "s etouffe", "sallume": "s allume",
        "quon": "qu on", "quest": "qu est", "quil": "qu il", "quelquun": "quelqu un",
        "dun": "d un", "dune": "d une", "darret": "d arret", "dappoint": "d appoint", "delectricite": "d electricite",
        "depilepsie": "d epilepsie", "destomac": "d estomac", "leau": "l eau", "lair": "l air",
        "magresse": "m agresse", "metouffe": "m etouffe", "mevanouir": "m evanouir", "taide": "t aide",
        "svp": "", "stp": "", "jappelle": "j appelle", "jessaie": "j essaie", "sarreter": "s arreter", "sarrete": "s arrete",
    ]

    /// Noms courants commençant par une voyelle : « lecole » devient « l ecole », « diode » « d iode » (cycle 2).
    static let nomsAVoyelle: Set<String> = Set("""
    ecole ascenseur alerte alarme inondation escalier usine etage eau air hopital enfant enfants incendie iode orage ouragan eruption explosion \
    electricite appoint arret estomac epilepsie evacuation abri arbre autoroute immeuble interieur exterieur oeil urgence urgences ambulance \
    accident eglise habite habitation entree endroit appartement aide eclair oxygene essence emeute attentat otage ecran
    """.split(whereSeparator: { $0 == " " || $0 == "\n" || $0 == "\\" }).map(String.init))

    static func developper(_ mot: String) -> String {
        if let c = contractions[mot] { return c }
        if mot.count > 3, let p = mot.first, "ldjsmnt".contains(p), nomsAVoyelle.contains(String(mot.dropFirst())) {
            return "\(p) \(mot.dropFirst())"
        }
        if mot.hasPrefix("qu"), mot.count > 4, nomsAVoyelle.contains(String(mot.dropFirst(2))) { return "qu \(mot.dropFirst(2))" }
        return mot
    }

    /// Texte normalisé, contractions développées, entouré d'espaces pour chercher des mots entiers.
    public static func preparer(_ question: String) -> String {
        let mots = Normalisation.normaliser(question).split(separator: " ").map { developper(String($0)) }
        return " " + mots.filter { !$0.isEmpty }.joined(separator: " ") + " "
    }

    struct Texte {
        let t: String
        /// Vrai si l'un des motifs apparaît ; un motif commence toujours au début d'un mot.
        func a(_ motifs: String...) -> Bool { motifs.contains { t.contains(" " + $0) } }
        func a(_ motifs: [String]) -> Bool { motifs.contains { t.contains(" " + $0) } }
        /// Vrai si le mot exact apparaît.
        func mot(_ mots: String...) -> Bool { mots.contains { t.contains(" " + $0 + " ") } }
        var nombreDeMots: Int { t.split(separator: " ").count }
    }

    static let tiers = ["il ", "ils ", "elle ", "elles ", "lui ", "mari", "femme", "fils ", "fille", "enfant", "bebe", "pere ", "mere ", "grand",
                        "voisin", "pote", "ami ", "amie ", "copain", "copine", "collegue", "homme", "dame ", "conducteur", "quelqu", "personne ",
                        "frere", "soeur", "papa", "maman", "proche", "child", "he ", "she ", "his ", "her ", "daughter", "husband", "wife"]
    static let soi = ["je ", "j ", "moi ", "me ", "m ", "i ", "my ", "me "]

    static let informatif = ["appli", "application", "apprendre", "formation", "former", "ou trouver", "cours ", "stage",
                             "trousse", "acheter", "liste ", "preparer"]
    static let apresCoup = ["cauchemar", "apres avoir sauve", "apres avoir vu", "apres avoir vecu", "apres avoir assiste", "depuis que", "j y repense", "souvenir", "dormir", "traumatis"]

    static let arret = ["respire plus", "respire pas", "ne respire", "respire plu ", "bouge plus", "arret cardiaque", "arret du coeur", "coeur arrete",
                        "coeur s est arrete", "crise cardiaque", "attaque cardiaque", "heart attack", "reanimation", "reanimer", "massage cardiaque", "masser", "compressions thoraciques", "defibrillateur", "dae ",
                        "not breathing", "no pulse", "cardiac arrest", "tout mou", "toute molle"]
    static let inconscience = ["repond pas", "repond plus", "repond rien", "inconscient", "evanoui", "tombe dans les pommes", "tombee dans les pommes",
                               "perdu connaissance", "sans connaissance", "reveille pas", "reveille plus", "ouvre pas les yeux", "unconscious", "fainted"]
    static let saignementFort = ["saigne beaucoup", "saigne enorm", "saigne abond", "saigne fort", "saigne trop", "pisse le sang", "pisse du sang",
                                 "coule beaucoup", "beaucoup de sang", "plein de sang", "enormement de sang", "hemorragie", "garrot", "tourniquet",
                                 "plante dans", "plante au", "plantee", "ouvert la", "ouverte la", "tronconneuse", "coup de couteau", "coups de couteau", "poignard", "balle ", "par balle", "coule enorm", "coule fort", "coule partout", "saigne de partout", "saigne partout", "entaill", "gicle", "flaque de sang", "bleeding heavily", "lot of blood"]
    static let saignement = ["saign", "sang ", "bleed", "blood"]
    static let saignementLeger = ["un peu", "petite", "petit ", "legere", "leger", "egratign", "superficiel"]
    static let etouffement = ["etouff", "heimlich", "avale de travers", "avalee de travers", "fausse route", "coince dans la gorge", "bloque dans la gorge",
                              "choking", "choke"]
    static let brulure = ["brul", "ebouillant", "bouillant", "huile chaude", "cloque", "burn", "scald", "boiling"]
    static let produitsDangereux = ["pile", "javel", "produit", "detergent", "lessive", "capsule", "medicament", "cachet", "comprime", "aimant",
                                    "essence", "white spirit", "alcool a bruler", "poison", "champignon", "baie", "pesticide", "insecticide", "bleach", "battery", "pills"]
    static let nourrisson = ["bebe", "nourrisson", "nouveau ne", "moins d un an", "baby", "infant"]

    // MARK: Décision

    public static func decider(_ question: String, guides: [String: Guide]) -> Decision {
        var x = Texte(t: preparer(question))
        guard x.nombreDeMots > 0 else { return .recherche(texte: question) }

        // 1. Mots trompeurs.
        if x.a("brulure d estomac", "brulures d estomac", "brule l estomac", "brule a l estomac", "remontee", "reflux", "aigreur") {
            return .horsPerimetre(message: messageDigestif, urgenceVitale: false)
        }
        if x.a("inconscient", "mort ", "morte ", "respire plus") && x.a("telephone", "portable", "ordinateur", "tablette", "ecran", "batterie", "voiture ne", "box ") {
            return .horsPerimetre(message: messageTechnique, urgenceVitale: false)
        }
        if x.a("etouff") && x.a("chaud", "chaleur", "degres", "canicule", "lourd ") {
            x = Texte(t: x.t.split(separator: " ").filter { !$0.contains("etouff") }.map(String.init).joined(separator: " ").padded)
        }

        // 1 bis. Règles des cycles 3 à 6 (détresse suicidaire, hors périmètre, Espace mairie, thèmes).
        if let d = themes(x, guides: guides) { return d }

        // 2. Hors périmètre.
        if x.a("chien", "chat ", "chats ", "chiot", "chaton", "cheval", "animal", "animaux", "vache", "lapin") && x.a("mord", "vipere", "serpent", "piqu", "bless", "empoison", "malade", "mange") {
            return .horsPerimetre(message: messageVeterinaire, urgenceVitale: false)
        }
        if x.a("bombe lacrymo", "lacrymo", "arme ", "armes", "pistolet", "fusil ", "fusils", "couteau pour", "legitime defense", "me defendre", "se defendre", "taser") {
            return .horsPerimetre(message: messageArmes, urgenceVitale: false)
        }
        if x.a("faire un feu", "faire du feu", "bruler des", "bruler les", "bruler mes") && x.a("jardin", "branche", "feuille", "dechet", "herbe", "terrain") {
            return .horsPerimetre(message: messageBrulage, urgenceVitale: false)
        }
        if x.a("plante sauvage", "plantes", "quelle plante", "herbe", "remede", "naturel") && x.a("plaie", "soign", "desinfect", "cicatri", "blessure", "coupure") {
            return .horsPerimetre(message: messagePlantes, urgenceVitale: false)
        }
        // Réaction allergique grave : avant la règle « allergie » du hors périmètre.
        if x.a("gonfle", "gonfl", "choc anaphyl", "oedeme") && x.a("gorge", "visage", "langue", "levre", "respir", "piqu", "guepe", "abeille", "frelon", "allerg") {
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        let medicament = x.a("doliprane", "paracetamol", "ibuprofene", "advil", "nurofen", "aspirine", "efferalgan", "dafalgan", "antibiotique", "medicament", "sirop", "comprime")
        let dose = x.a("combien de", "dose", "posologie", "mg ", "milligramme", "kilo", "kg ", "par jour", "toutes les")
        if (medicament && (dose || x.a("donner", "prendre", "puis je"))) || x.a("zona", "allergie", "plaques rouges", "boutons", "eczema", "grippe", "angine", "gastro", "c est grave docteur", "diagnostic") {
            return .horsPerimetre(message: messageMedical, urgenceVitale: false)
        }

        // 3. Signes graves sans guide (AVC, convulsions) : 15 tout de suite.
        if x.a("bouche de travers", "bouche tordue", "visage paralyse", "visage de travers", "lever le bras", "bras ne repond", "parle bizarre", "parle plus correctement",
               "n arrive plus a parler", "arrive plus a parler", "avc", "attaque cerebrale", "stroke") {
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        if x.a("asthme", "manque d air", "suffoque", "asthma") && !x.a(apresCoup) {
            if x.a(soi) && !x.a(tiers) { return .urgencePersonnelle }
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        if x.a("electrocut", "electrise", "electrocution", "foudroy") {
            if x.a(arret) { return .sante(guideId: "arret-cardiaque", lignes: etapes("arret-cardiaque", guides) + alertes("arret-cardiaque", guides)) }
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        if x.a("epilep", "convuls", "tremble de partout", "spasme", "seizure") {
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        // Ingestion d'un produit ou d'un objet dangereux : pas de guide, 15 tout de suite.
        if x.a("avale", "bu ", "bu de", "mange", "ingere", "swallow", "drank") && x.a(produitsDangereux) {
            // Cycle 4 : 15 ou 112 en haut-parleur, avec les boutons d'appel (plus de simple message).
            return .sante(guideId: "numeros", lignes: alertes("arret-cardiaque", guides) + numeros(["15", "112"], guides))
        }
        if x.a("empoisonn", "poison", "intoxication alimentaire", "intoxique", "overdose", "surdose", "drogue") && !x.a("monoxyde", "gaz", "chauffage", "groupe electrogene", "poele", "barbecue") {
            return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }

        // 3 bis. Alertes et risques majeurs (cycle 2).
        if let d = risquesMajeurs(x, guides: guides) { return d }

        // 4. Après coup ou simple information : pas de triage vital.
        if x.a(apresCoup) { return .guide(id: "moral") }
        let estInformatif = x.a(informatif)
        if x.a("apprendre", "formation", "former", "stage", "cours ") && x.a("secour", "gestes", "massage", "defibrillateur", "garrot", "sauver") {
            return .guide(id: "engagement")
        }

        let parleDeSoi = x.a(soi)
        let parleDUnTiers = x.a(tiers)

        // 5. Urgence personnelle : la personne décrit sa propre détresse vitale.
        if !estInformatif && parleDeSoi && !parleDUnTiers {
            let vital = x.a("respir", "poitrine", "etouff", "malaise", "evanouir", "evanoui", "perdre connaissance", "vais tomber", "coeur", "breathe", "chest") || x.a(saignementFort)
            if vital { return .urgencePersonnelle }
            if x.mot("malaise") { return .urgencePersonnelle }
        }

        // Réponses aux boutons de clarification qui n'ont pas de guide.
        if x.a("petite plaie qui saigne peu") { return .horsPerimetre(message: messagePetitePlaie, urgenceVitale: false) }
        if x.a("est tombe mais il repond") { return .horsPerimetre(message: messageChute, urgenceVitale: false) }
        if x.a("saignement de nez", "saigne du nez", "saignements de nez") && !x.a(saignementFort) {
            return .horsPerimetre(message: messageSansGuideSante, urgenceVitale: false)
        }

        if !estInformatif {
            // 6. Cas particuliers.
            if x.a("noy", "drown") || (x.a("piscine") && x.a("tombe", "au fond", "sous l eau", "inconscient", "respire", "bouge plus", "repond")) {
                if x.a(arret) || x.a(inconscience) {
                    return .sante(guideId: "arret-cardiaque", lignes: etapes("arret-cardiaque", guides) + alertes("arret-cardiaque", guides))
                }
                if !x.a("bateau", "en mer", "a la mer", "large ") { return .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true) }
            }
            if x.a("bateau", "en mer", "a la mer", "noyade", "se noie", "se noyer", "tombe a l eau", "tombee a l eau", "tombe dans l eau", "kayak", "voilier", "large ") {
                return .sante(guideId: "numeros", lignes: numeros(["196", "112"], guides))
            }
            if x.a("chaud", "chaleur", "degres", "canicule") && x.a("confus", "fievre", "malaise", "delire", "ne repond", "vomi") {
                return .sante(guideId: "canicule", lignes: alertes("canicule", guides) + listes("canicule", guides))
            }
            let bebe = x.a(nourrisson) || x.t.range(of: #" \d+ mois "#, options: .regularExpression) != nil
            if bebe && (x.a(arret) || x.a(inconscience)) {
                return .sante(guideId: "arret-cardiaque", lignes: alertes("arret-cardiaque", guides) + nourrissonLigne(guides))
            }
            if bebe && x.a(etouffement) {
                return .sante(guideId: "etouffement", lignes: alertes("arret-cardiaque", guides) + nourrissonLigne(guides))
            }
            if x.a(etouffement) && x.a("tousse", "tousser", "parle", "arrive a parler", "respire encore", "coughing")
                && !x.a("respire plus", "respire pas", "ne respire", "plus parler", "pas parler", "peut plus", "peux plus", "arrive plus", "arrive pas", "plus tousser", "tousse plus", "tousse pas") {
                return .sante(guideId: "etouffement", lignes: alertes("etouffement", guides).filter { $0.contains("tousse") })
            }

            // 7. Priorité entre urgences : danger du lieu, hémorragie, arrêt, inconscience, étouffement, brûlure.
            if x.a("le feu", "au feu", "incendie", "fumee", "flammes", "fire ") && !x.a("jardin", "foret", "barbecue", "feu de camp", "allumer un feu", "faire un feu") {
                var l = etapes("incendie-domicile", guides)
                if x.a("escalier", "couloir", "palier", "cage d") { l = enTete(l, "escalier") }
                if x.a(brulure) { l += Array(etapes("brulure", guides).prefix(1)) + alertes("brulure", guides) }
                return .sante(guideId: "incendie-domicile", lignes: l)
            }
            let combustion = x.a("groupe electrogene", "chauffage d appoint", "poele", "barbecue", "brasero", "petrole", "chaudiere", "monoxyde", "co ", "gaz d echappement")
            let symptomes = x.a("mal a la tete", "mal de tete", "maux de tete", "vomir", "nausee", "vertige", "etourdi", "malaise", "evanoui", "fatigue", "somnol")
            if (combustion && symptomes) || x.a("monoxyde", "intoxication au gaz", "intoxique") {
                return .sante(guideId: "monoxyde", lignes: Array(listes("monoxyde", guides).prefix(1)) + etapes("monoxyde", guides) + alertes("monoxyde", guides))
            }
            if x.a(saignementFort) {
                return .sante(guideId: "saignement", lignes: etapes("saignement", guides) + alertes("saignement", guides))
            }
            if x.a(arret) {
                return .sante(guideId: "arret-cardiaque", lignes: etapes("arret-cardiaque", guides) + alertes("arret-cardiaque", guides))
            }
            if x.a(inconscience) && x.a("respire", "breathing", "ventre qui bouge", "ventre bouge", "poitrine se souleve", "poitrine qui se souleve") {
                return .sante(guideId: "inconscient-respire", lignes: etapes("inconscient-respire", guides))
            }
            if x.a(etouffement) {
                return .sante(guideId: "etouffement", lignes: etapes("etouffement", guides) + alertes("etouffement", guides))
            }
            if x.a(brulure) {
                return .sante(guideId: "brulure", lignes: etapes("brulure", guides) + alertes("brulure", guides))
            }

            if x.a("pls", "position laterale") {
                return .sante(guideId: "inconscient-respire", lignes: etapes("inconscient-respire", guides))
            }

            // 8. Clarification : un mot grave seul, sans assez d'éléments.
            if x.a(inconscience) {
                return clarificationConscience
            }
            if x.a(saignement) {
                return .clarification(question: "Le saignement est-il abondant ?", options: [
                    OptionClarification(libelle: "Oui, il saigne beaucoup", question: "il saigne beaucoup"),
                    OptionClarification(libelle: "Non, c'est une petite plaie", question: "petite plaie qui saigne peu"),
                ])
            }
            if x.a("tombe ", "tombee", "tombes", "par terre", "au sol", "chute", "s est effondre", "effondree") {
                return clarificationConscience
            }
            if x.a("malaise", "pas bien", "se sent mal", "sent pas bien", "mal partout") {
                if parleDUnTiers { return clarificationConscience }
                if !parleDeSoi {
                    return .clarification(question: "Le malaise, c'est pour vous ou pour un proche ?", options: [
                        OptionClarification(libelle: "Pour moi", question: "je fais un malaise"),
                        OptionClarification(libelle: "Pour un proche", question: "un proche fait un malaise"),
                    ])
                }
            }
        }

        if x.a("saignement de nez", "saigne du nez", "fievre", "diarrhee", "toux ", "rhume", "mal au ventre", "mal de ventre", "mal aux dents", "migraine") {
            return .horsPerimetre(message: messageSansGuideSante, urgenceVitale: false)
        }
        return .recherche(texte: x.t.trimmingCharacters(in: .whitespaces))
    }

    static let clarificationConscience = Decision.clarification(question: "La personne répond-elle quand vous lui parlez, et respire-t-elle ?", options: [
        OptionClarification(libelle: "Ne répond pas, ne respire pas", question: "il ne repond pas et ne respire pas"),
        OptionClarification(libelle: "Ne répond pas mais respire", question: "il ne repond pas mais il respire"),
        OptionClarification(libelle: "Répond", question: "il est tombe mais il repond"),
    ])

    // MARK: Extraits exacts des guides

    static func etapes(_ id: String, _ guides: [String: Guide]) -> [String] { guides[id]?.premieresEtapes ?? [] }

    static func alertes(_ id: String, _ guides: [String: Guide]) -> [String] {
        guides[id]?.blocs.compactMap { b -> String? in if case let .alert(body) = b { return body } else { return nil } } ?? []
    }

    static func listes(_ id: String, _ guides: [String: Guide]) -> [String] {
        guides[id]?.blocs.flatMap { b -> [String] in if case let .list(_, items) = b { return items } else { return [] } } ?? []
    }

    /// Le conseil « Nourrisson » du guide Étouffement, mot pour mot.
    static func nourrissonLigne(_ guides: [String: Guide]) -> [String] {
        let tips: [String] = guides["etouffement"]?.blocs.compactMap { b -> String? in if case let .tip(_, body) = b { return body } else { return nil } } ?? []
        return tips.filter { $0.lowercased().hasPrefix("nourrisson") }
    }

    static func numeros(_ ns: [String], _ guides: [String: Guide]) -> [String] {
        let tous = guides["numeros"]?.blocs.flatMap { b -> [NumeroUrgence] in if case let .numbers(_, items) = b { return items } else { return [] } } ?? []
        return ns.compactMap { n in tous.first { $0.n == n }.map { "\($0.n) : \($0.label). \($0.desc)" } }
    }

    // MARK: Anglais

    /// Vrai si la question semble écrite en anglais : on ajoute alors « Emergency: call 112 ».
    public static func semblerAnglais(_ question: String) -> Bool {
        let mots = Set(Normalisation.normaliser(question).split(separator: " ").map(String.init))
        let anglais: Set<String> = ["my", "the", "what", "is", "help", "to", "do", "he", "she", "his", "her", "not", "with", "and", "how", "can", "i", "it", "has", "hand", "water", "child", "breathing", "burned", "bleeding", "please"]
        return mots.intersection(anglais).count >= 3
    }
}

extension String {
    var padded: String { " " + self + " " }
}

extension Triage {
    /// Marqueurs d'une question posée par un élu ou un agent (Espace mairie, cycle 6).
    static let marqueursMairie = ["maire ", "maires ", "adjoint", "elu ", "elue ", "elus ", "dgs ", "agent en mairie", "agents de la commune", "agents municipaux",
                                  "secretaire de mairie", "en mairie", "notre mairie", "la mairie on", "de la mairie quelle", "notre commune", "nos agents", "nos habitants",
                                  "les habitants", "aux habitants", "des habitants", "pcc ", "pcs ", "poste de commandement", "cellule de crise", "collectivite",
                                  "serveurs de la commune", "serveurs de la mairie", "communal", "communale", "town hall", "point de situation", "points de situation",
                                  "main courante par ecrit", "briefing", "retex", "journaliste", "communication de la mairie", "accusent la mairie", "la mairie de cacher", "intern in french town", "chargee de communication", "charge de communication", "responsable informatique de la mairie"]

    public static func estMairie(_ question: String) -> Bool {
        let x = Texte(t: preparer(question))
        return x.a(marqueursMairie) && !x.a("je suis un particulier", "particulier")
    }
}
