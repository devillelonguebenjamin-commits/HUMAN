import Foundation

/// Étape « alertes et risques majeurs » du triage (cycle 2 de l'assistant, 27/11/2026).
/// Le guide « Que faire selon le risque » regroupe 13 risques : ici, chaque risque est repéré
/// séparément et seule sa section est affichée, mot pour mot, sans reformulation.
extension Triage {
    // MARK: Messages d'orientation

    public static let messageFiltre = "Je n'ai pas de guide pour fabriquer un filtre ou un masque. En cas d'accident industriel, la consigne officielle est : abritez-vous dans le bâtiment clos le plus proche, calfeutrez les ouvertures et coupez la ventilation ; en cas de gêne respiratoire, respirez à travers un linge humide."
    public static let messageJuridique = "Je ne donne pas de conseil juridique personnalisé. Pour l'indemnisation, voyez le guide « Assurance et catastrophe naturelle » ; pour vos droits, consultez service-public.gouv.fr."
    public static let messageMeteo = "Je n'ai pas la météo : SIJAMAIS fonctionne sans réseau. Consultez Météo-France (vigilance.meteofrance.fr) ou écoutez la radio."
    public static let messagePiratage = "Je ne réponds pas à cette demande. Pour suivre les consignes, écoutez ici (ex-France Bleu), France Info ou France Inter, et les annonces de la préfecture ou de la mairie."
    public static let messageDegatDesEaux = "Je n'ai pas de guide sur les dégâts des eaux dans le logement. Si vous pouvez le faire sans danger, coupez l'eau et l'électricité, puis contactez votre assurance ou un plombier."

    public static let messageEnlevement = "Je n'ai pas de guide sur l'alerte enlèvement. Lisez le message en entier ; si vous avez une information, appelez le numéro qu'il indique, sans intervenir vous-même."

    static let rumeur = ["tiktok", "facebook", "whatsapp", "twitter", "instagram", "snapchat", "reseaux sociaux", "rumeur", "vu sur", "video", "on dit que", "il parait"]

    static func risquesMajeurs(_ x: Texte, guides g: [String: Guide]) -> Decision? {
        // Hors périmètre propres au thème.
        if x.a("fabriquer", "faire un", "faire une", "construire", "bricoler") && x.a("filtre", "masque a gaz", "masque anti", "bunker", "abri anti") {
            return .horsPerimetre(message: messageFiltre, urgenceVitale: false)
        }
        if x.a("juridiq", "avocat", "plainte", "proces ", "tribunal", "en justice") || (x.a("responsable") && x.a("mairie", "maire ", "etat ", "prefet", "commune")) {
            return .horsPerimetre(message: messageJuridique, urgenceVitale: false)
        }
        if x.a("meteo", "quel temps", "weather") && x.a("demain", "aujourd", "week end", "semaine", "prevision", "ce soir", "tomorrow") {
            return .horsPerimetre(message: messageMeteo, urgenceVitale: false)
        }
        if x.a("pirater", "hacker", "scanner", "intercepter") && x.a("radio", "pompiers", "police", "gendarmerie", "frequence") {
            return .horsPerimetre(message: messagePiratage, urgenceVitale: false)
        }
        if x.a("lave linge", "machine a laver", "lave vaisselle", "tuyau", "chauffe eau", "ballon d eau", "degat des eaux", "baignoire", "fuite d eau") || (x.a("toilettes", "wc ") && x.a("deborde", "fuite", "inonde")) {
            return .horsPerimetre(message: messageDegatDesEaux, urgenceVitale: false)
        }
        // Métaphores : « tempête de critiques », « sous le feu des critiques ».
        if x.a("tempete de", "tempete sous", "tempete dans", "feu des critiques", "dans ma tete") && !x.a("tempete de neige", "tempete de sable") {
            return .guide(id: "moral")
        }

        let respireMal = x.a("mal a respirer", "du mal a respirer", "respire mal", "arrive pas a respirer", "arrive plus a respirer", "etouff", "tousse", "gene respiratoire")

        // Rumeur : on ne réagit qu'aux annonces officielles.
        if x.a(rumeur) && x.a("barrage", "evacu", "sirene", "alerte", "inond", "attentat", "nuage", "centrale", "eau contaminee", "contamin") {
            var l = alertes("reflexes", g) + etapes("desinformation", g)
            if x.a("barrage") { l += textes("alerte", titre: "La sirène de barrage", g) }
            return .consigne(guideId: "desinformation", lignes: l, urgenceVitale: false)
        }

        if x.a("alerte enlevement", "enlevement") {
            return .horsPerimetre(message: messageEnlevement, urgenceVitale: false)
        }

        // Sirène de barrage : évacuer, à l'inverse de la sirène habituelle.
        if x.a("corne de brume") || (x.a("barrage") && x.a("sirene", "casse", "rupture", "cede", "ceder", "lache", "rompu", "alerte")) {
            return .consigne(guideId: "alerte", lignes: alertes("alerte", g) + risque("Rupture de barrage", g), urgenceVitale: true)
        }

        if x.a("barrage") && !x.a("barrage de police", "barrage routier", "faire barrage") {
            return .consigne(guideId: "alerte", lignes: textes("alerte", titre: "La sirène de barrage", g) + alertes("alerte", g) + risque("Rupture de barrage", g), urgenceVitale: false)
        }

        // Questions d'information sur l'alerte.
        if x.a("fin d alerte", "fin de l alerte", "alerte est finie", "alerte est terminee", "fin de l alarme") {
            return .guide(id: "alerte")
        }
        if x.a("sirene") && x.a("essai", "test", "mercredi", "fin de l alerte", "finie", "fini ", "termine", "reconnaitre", "quand ")
            && !x.a("sonne", "retentit", "entend", "pas mercredi", "hurle") {
            return .guide(id: "alerte")
        }
        if x.a("radio") && x.a("quelle", "quel ", "ecouter", "frequence", "station") {
            return .guide(id: "alerte")
        }
        if x.a("fr alert", "fralert") {
            return .consigne(guideId: "alerte", lignes: lignes("alerte", contenant: "FR-Alert", g) + etapes("alerte", g), urgenceVitale: false)
        }
        if x.a("dicrim", "ddrm", "georisques") || (x.a("risque") && x.a("commune", "ma ville", "mon quartier", "chez moi", "ou j habite") && x.a("savoir", "connaitre", "quels", "quel ", "liste", "trouver")) {
            return .guide(id: "pfms")
        }

        // Consigne reçue de rester à l'abri (haut-parleur, SMS, préfecture) : les réflexes.
        if x.a("confin", "rester chez", "rester a l abri", "rester enferme", "mise a l abri", "mettre a l abri", "haut parleur", "rester a l interieur")
            && !x.a("quelle piece", "piece ", "rechaud", "bougie", "barbecue", "groupe electrogene") && !x.a("covid", "epidemie", "grippe")
            && !(x.a("evacuer", "partir", "quitter") && x.a("ou rester", "ou pas", "ou non")) {
            return .consigne(guideId: "reflexes", lignes: etapes("reflexes", g), urgenceVitale: false)
        }

        // Enfants à l'école : jamais aller les chercher.
        if x.a("ecole", "creche", "college", "lycee", "school") && x.a("chercher", "recuperer", "aller", "pick up") {
            var l = lignes("reflexes", contenant: "N'allez pas chercher", g) + etapes("reflexes", g).filter { !$0.contains("N'allez pas chercher") }
            if x.a("chimique", "industriel", "nuage", "toxique") { l += risque("Accident industriel", g) }
            return .consigne(guideId: "reflexes", lignes: l, urgenceVitale: false)
        }

        // Odeur de gaz, avant tout autre risque.
        if x.a("odeur de gaz", "sent le gaz", "ca sent le gaz", "fuite de gaz", "sens le gaz", "smell gas") {
            let l = lignes("reflexes", contenant: "N'allumez aucune flamme", g) + lignes("retour", contenant: "Odeur de gaz", g) + lignes("reflexes", contenant: "Couper le gaz", g)
            return .consigne(guideId: "reflexes", lignes: l, urgenceVitale: false)
        }
        // Flamme pendant une mise à l'abri, sans symptôme (avec symptômes : guide Monoxyde, plus loin).
        let combustion = x.a("rechaud", "bougie", "barbecue", "groupe electrogene", "chauffage d appoint", "camping gaz", "brasero", "poele a petrole")
        let symptomes = x.a("mal a la tete", "mal de tete", "vomir", "nausee", "vertige", "etourdi", "malaise", "evanoui", "somnol")
        if combustion && !symptomes && x.a("confin", "dedans", "interieur", "a l abri", "enferme", "maison", "appartement", "garage") {
            return .consigne(guideId: "reflexes", lignes: lignes("reflexes", contenant: "N'allumez aucune flamme", g) + alertes("monoxyde", g), urgenceVitale: false)
        }

        // Séisme et tsunami.
        let seisme = x.a("seisme", "tremblement de terre", "terre tremble", "terre a tremble", "secousse", "earthquake")
        let tsunami = x.a("tsunami", "raz de maree", "vague geante")
        if seisme || tsunami {
            var l: [String] = []
            if seisme { l = risque("Séisme", g) }
            if x.a("fissur", "endommag", "effondr", "lezard", "rentre", "retourner") { l = enTete(l, "Après") }
            if tsunami || x.a("plage", "cote ", "cotes", "mer ", "bord de mer", "port ", "beach", "coast", "sea ") {
                l = enTete(l, "côtes") + risque("Tsunami", g)
                if tsunami && x.a("fissur", "endommag") { l = enTete(l, "Après") }
            }
            if x.a("ascenseur", "elevator") { l += lignes("reflexes", contenant: "ascenseur", g) }
            return .consigne(guideId: "risques", lignes: l, urgenceVitale: false)
        }

        // Accident nucléaire.
        if x.a("nucleaire", "centrale", "iode", "radioacti", "radiation") {
            var l = risque("Accident nucléaire", g)
            if !x.a("ou recuperer", "ou trouver", "retirer", "pharmacie", "ou avoir", "distribu") { l = enTete(l, "instruction du préfet") }
            return .consigne(guideId: "risques", lignes: l, urgenceVitale: respireMal)
        }

        // Air pollué : accident industriel, matières dangereuses.
        let industriel = x.a("accident industriel", "usine", "seveso", "chimique", "nuage toxique", "nuage chimique", "nuage de fumee", "camion citerne", "citerne", "matieres dangereuses",
                             "fumee jaune", "fumee noire", "produit toxique", "fuite chimique", "explosion")
        if industriel {
            if x.a("quelle piece", "piece ", "pieces", "se confiner", "me confiner", "calfeutrer", "preparer") && !x.a("maintenant", "en ce moment") {
                return .guide(id: "abri-evacuation")
            }
            var l = risque("Accident industriel", g)
            if x.a("citerne", "camion", "train", "wagon", "matieres dangereuses") { l = risque("Transport de matières dangereuses", g) + l }
            if x.a("fenetre", "aerer", "ouvrir") { l = enTete(l, "Fermez portes et fenêtres") }
            return .consigne(guideId: "risques", lignes: l, urgenceVitale: respireMal)
        }

        // Attentat.
        if x.a("attentat", "terroris", "coups de feu", "coup de feu", "fusillade", "tireur", "tirs ", "prise d otage", "attaque au couteau", "homme arme", "hommes armes", "shooting", "gunshot") {
            return .consigne(guideId: "risques", lignes: risque("Attaque terroriste", g), urgenceVitale: false)
        }

        // Évacuer avec des animaux.
        if x.a("chat ", "chats", "chien", "animal", "animaux", "pets") && x.a("evacu", "gymnase", "accueil", "partir", "accept") {
            return .guide(id: "abri-evacuation")
        }

        // Inondation.
        if x.a("inond", "crue", "eau monte", "l eau monte", "submersion", "flood", "riviere deborde", "deborde", "pluie diluvienne", "pluies diluviennes")
            || (x.a("pleut", "pluie", "averse") && x.a("rue", "cave", "maison", "route", "piscine", "monte", "riviere")) {
            return .consigne(guideId: "risques", lignes: risque("Inondation", g), urgenceVitale: false)
        }

        // Feu de forêt.
        if x.a("feu de foret", "feux de foret", "incendie de foret", "front de flammes", "flammeche", "wildfire", "feu de broussaille", "feu de garrigue")
            || (x.a("feu", "flammes", "incendie", "fumee") && x.a("foret", "massif", "pinede", "garrigue", "colline", "vegetation")) {
            var l = risque("Feu de forêt", g)
            if x.a("voiture", "vehicule", "en auto", "car ") { l = enTete(l, "En voiture") }
            return .consigne(guideId: "risques", lignes: l, urgenceVitale: false)
        }

        // Tempête, orage, cyclone.
        if x.a("tempete", "orage", "cyclone", "ouragan", "foudre", "eclair", "vent violent", "vents violents", "tornade", "storm", "hurricane", "lightning") {
            var l = risque("Tempête, orage, cyclone", g)
            if x.a("arbre", "tree") { l = enTete(l, "arbre isolé") }
            if x.a("cyclone", "ouragan", "oeil", "vent s est arrete", "s arrete", "calme") { l = enTete(l, "Cyclone") }
            return .consigne(guideId: "risques", lignes: l, urgenceVitale: false)
        }

        if x.a("volcan", "eruption", "cendres", "lave ") {
            return .consigne(guideId: "risques", lignes: risque("Éruption volcanique (outre-mer)", g), urgenceVitale: false)
        }
        if x.a("glissement de terrain", "eboulement", "avalanche", "coulee de boue", "mouvement de terrain", "falaise") {
            return .consigne(guideId: "risques", lignes: risque("Mouvement de terrain, avalanche", g), urgenceVitale: false)
        }

        // Sirène habituelle : mise à l'abri, et dans la même bulle la consigne de la corne de brume.
        if x.a("sirene", "siren") {
            var l = etapes("alerte", g) + alertes("alerte", g)
            if x.a("voiture", "vehicule", "en auto", "conduis", "au volant") { l = lignes("reflexes", contenant: "véhicule", g) + l }
            return .consigne(guideId: "alerte", lignes: l, urgenceVitale: false)
        }

        // Demandes trop vagues : une question, avec boutons.
        if x.a("feu", "incendie", "flammes") && x.a("dehors", "exterieur", "rue", "au loin", "pas loin", "pres de chez") && !x.a("cuisine", "appartement", "immeuble", "escalier", "maison") {
            return .clarification(question: "Où êtes-vous par rapport au feu ?", options: [
                OptionClarification(libelle: "Feu de forêt ou de végétation près de moi", question: "feu de foret pres de chez moi"),
                OptionClarification(libelle: "Je suis en voiture près des flammes", question: "en voiture face a un feu de foret"),
                OptionClarification(libelle: "Feu dans un bâtiment", question: "il y a le feu dans l immeuble"),
            ])
        }
        if x.a("evacuer", "partir", "quitter") && x.a("rester", "ou pas", "ou non") {
            return .clarification(question: "De quel risque s'agit-il ? Sans consigne des autorités, on reste à l'abri.", options: [
                OptionClarification(libelle: "Inondation", question: "inondation que faire"),
                OptionClarification(libelle: "Nuage toxique, accident industriel", question: "accident industriel nuage toxique que faire"),
                OptionClarification(libelle: "Feu de forêt", question: "feu de foret pres de chez moi"),
                OptionClarification(libelle: "Sirène de barrage (corne de brume)", question: "corne de brume barrage"),
            ])
        }
        if x.nombreDeMots <= 2 && x.a("alerte", "alert") {
            return .clarification(question: "Quelle alerte avez-vous reçue ?", options: [
                OptionClarification(libelle: "Sirène (son montant et descendant)", question: "la sirene sonne que faire"),
                OptionClarification(libelle: "Message FR-Alert sur le téléphone", question: "message fr alert recu"),
                OptionClarification(libelle: "Corne de brume près d'un barrage", question: "corne de brume barrage"),
            ])
        }
        return nil
    }

    // MARK: Extraits exacts des guides

    /// Les consignes d'un risque du guide « Que faire selon le risque ».
    static func risque(_ titre: String, _ g: [String: Guide]) -> [String] {
        for b in g["risques"]?.blocs ?? [] { if case let .risk(t, items) = b, t == titre { return items } }
        return []
    }

    /// Les textes d'un bloc par son titre.
    static func textes(_ id: String, titre: String, _ g: [String: Guide]) -> [String] {
        for b in g[id]?.blocs ?? [] where b.titreBloc == titre { return b.textesRecherche }
        return []
    }

    /// Les lignes d'un guide qui contiennent un texte.
    static func lignes(_ id: String, contenant s: String, _ g: [String: Guide]) -> [String] {
        (g[id]?.blocs ?? []).flatMap(\.textesRecherche).filter { $0.contains(s) }
    }

    /// Met en tête les lignes qui contiennent un texte, sans changer l'ordre des autres.
    static func enTete(_ l: [String], _ s: String) -> [String] {
        l.filter { $0.contains(s) } + l.filter { !$0.contains(s) }
    }
}
