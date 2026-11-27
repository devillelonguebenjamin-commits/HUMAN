import Foundation

/// Règles des cycles 3 à 6 de l'assistant (27/11/2026) : préparation et coupures, survie,
/// après la crise, cyber et désinformation, Espace mairie. Appelées juste après les mots trompeurs.
extension Triage {
    // MARK: Messages d'orientation (aucun contenu de guide inventé)

    public static let messageDetressePsy = "Appelez maintenant le 3114, numéro national de prévention du suicide : gratuit, 24 h sur 24. En cas de danger immédiat, appelez le 15 ou le 112 (114 par SMS)."
    public static let messageDetressePsyProche = "Ne laissez pas la personne seule. Appelez le 3114, numéro national de prévention du suicide (gratuit, 24 h sur 24), ou en cas de danger immédiat le 15 ou le 112 (114 par SMS)."
    public static let messageDroit = "Je ne donne pas de conseil juridique personnalisé. Consultez service-public.gouv.fr ou renseignez-vous en mairie."
    public static let messageDroitCommune = "Je ne donne pas de conseil juridique ni de modèle d'acte. Renseignez-vous auprès de la préfecture ou sur legifrance.gouv.fr."
    public static let messageAchat = "Je ne recommande aucune marque, aucun modèle ni aucune offre commerciale. Les guides indiquent seulement quoi prévoir."
    public static let messageElectricien = "Je n'ai pas de guide sur les branchements électriques : faites appel à un électricien."
    public static let messageConservation = "Je n'ai pas de durée de conservation dans mes guides. La consigne du guide « Coupure d'électricité » : gardez le réfrigérateur et le congélateur fermés."
    public static let messageCarburant = "Je n'ai pas de guide sur le stockage de carburant. Renseignez-vous auprès de votre syndic ou de votre mairie."
    public static let messageVoyage = "Je n'ai pas de guide pour préparer un voyage ou des vacances."
    public static let messageNumerosReseaux = "Les numéros d'urgence gaz et électricité ne sont pas encore dans mes guides : notez-les dans votre plan familial (rubrique « Mes contacts »). En cas de danger immédiat, appelez le 18 ou le 112."
    public static let messageAlimentation = "Je n'ai pas de guide sur l'alimentation ou les régimes. Demandez conseil à un médecin ou à un diététicien."
    public static let messageIdentification = "Je ne peux identifier aucune plante ni aucun champignon. Ne consommez que ce que vous avez identifié avec certitude ; en cas de doute, demandez à un pharmacien. Si quelqu'un en a mangé et se sent mal, appelez le 15 ou le 112."
    public static let messageChasse = "Je ne donne pas de conseil de piégeage ni de chasse."
    public static let messageUrine = "Je n'ai pas de guide sur ce point. Voyez le guide « Trouver et purifier l'eau » ; en détresse, appelez le 112."
    public static let messageFeuLoisir = "Je n'ai pas de guide pour un feu de loisir. Les feux sont souvent interdits en forêt et à proximité : renseignez-vous en mairie."
    public static let messageUrbanisme = "Je n'ai pas de guide sur l'urbanisme : renseignez-vous en mairie ou sur service-public.gouv.fr."
    public static let messageVengeance = "Je ne réponds pas à cette demande. Signalez l'arnaque et faites-vous aider sur 17cyber.gouv.fr, puis portez plainte."
    public static let messageMenage = "Je n'ai pas de guide pour le ménage ou l'entretien."
    public static let messageCsirt = "Le numéro du CSIRT régional n'est pas encore dans le guide « Cyberattaque contre la commune ». Faites-vous aider sur 17cyber.gouv.fr et prévenez la préfecture."
    public static let messageRH = "Je n'ai pas de guide sur la gestion du personnel : voyez votre service des ressources humaines ou le centre de gestion."
    public static let messageDemarches = "Je n'ai pas de guide sur ce sujet : renseignez-vous auprès du commissariat, de la gendarmerie ou sur service-public.gouv.fr."
    public static let messageHarcelement = "Je n'ai pas de guide sur le harcèlement. Signalez les contenus sur internet-signalement.gouv.fr (Pharos) et faites-vous aider sur 17cyber.gouv.fr. En cas de danger, appelez le 17 ou le 112."
    public static let messageBlessure = "Je n'ai pas de guide sur les fractures ni les entorses. Appelez le 15 (ou le 112) pour être conseillé. Si la plaie saigne abondamment : appuyez fort et sans relâcher dessus, et appelez immédiatement."
    public static let messagePlaiePerforante = "Je n'ai pas de guide sur ce type de blessure : demandez conseil à un pharmacien ou à un médecin. Ne retirez jamais un objet planté dans une plaie ; si elle saigne abondamment, appelez le 15 ou le 112."
    public static let messageSport = "Je n'ai pas de guide sur le sport ou les loisirs."

    static let detressePsy = ["idees noires", "idee noire", "envie d en finir", "en finir", "suicide", "suicider", "me tuer", "se tuer", "veux mourir",
                              "veut mourir", "envie de mourir", "plus envie de vivre", "plus le gout de vivre", "mettre fin a mes jours", "kill myself",
                              "veux plus vivre", "veut plus vivre", "marre de vivre", "marre de la vie", "veux disparaitre", "envie de disparaitre", "plus me reveiller",
                              "sauter du pont", "sauter du toit", "sauter par la fenetre", "foutre en l air", "me pendre", "se pendre", "want to die", "end my life", "end it all"]

    /// Signes vitaux : quand ils sont là, aucune règle de thème ne passe devant les gestes de secours.
    static func vital(_ x: Texte) -> Bool {
        x.a(arret) || x.a(inconscience) || x.a(saignementFort) || x.a(etouffement) || x.a("brule", "brulure", "brulee")
            || x.a("arrive plus a respirer", "arrive pas a respirer", "respire mal", "malaise")
    }

    static func themes(_ x: Texte, guides g: [String: Guide]) -> Decision? {
        // 1. Détresse suicidaire : avant tout le reste (cycle 5).
        if x.a(detressePsy) {
            let soi = x.a(Triage.soi) && !x.a(tiers)
            return .detressePsy(pourSoi: soi, lignes: lignes("moral", contenant: "3114", g))
        }

        let espaceMairie = x.a(marqueursMairie) && !x.a("particulier")

        // 2. Hors périmètre.
        if espaceMairie {
            if x.a("loi matras", "penal", "arrete municipal", "rediger un arrete", "requisition", "code general des collectivites", "obligation legale", "nous oblige") {
                return .horsPerimetre(message: messageDroitCommune, urgenceVitale: false)
            }
            if x.a("csirt") && x.a("numero", "telephone", "contact") { return .horsPerimetre(message: messageCsirt, urgenceVitale: false) }
            if x.a("indemnite", "astreinte", "heures supplementaires", "salaire", "conges") { return .horsPerimetre(message: messageRH, urgenceVitale: false) }
        }
        if x.a("droit de porter", "ai le droit", "a t on le droit", "est ce legal", "c est legal", "dommages et interets", "diffamation", "porter plainte contre", "attaquer en justice", "au tribunal", "mise en demeure", "l attaquer", "attaquer mon assureur") {
            return .horsPerimetre(message: espaceMairie ? messageDroitCommune : messageDroit, urgenceVitale: false)
        }
        if x.a("quelle marque", "quel modele", "meilleur a acheter", "le meilleur", "payant", "comparer les tarifs", "comparer", "devis", "tarif", "quel logiciel", "quel antivirus")
            && !x.a("comparer les sources") {
            return .horsPerimetre(message: messageAchat, urgenceVitale: false)
        }
        if x.a("brancher", "cable", "raccorder", "bricoler") && x.a("groupe electrogene", "tableau electrique", "prise") { return .horsPerimetre(message: messageElectricien, urgenceVitale: false) }
        if x.a("combien d heures", "combien de temps", "combien de jours", "mangeable", "se conserve") && x.a("congelateur", "frigo", "refrigerateur", "viande", "aliment", "surgele") {
            return .horsPerimetre(message: messageConservation, urgenceVitale: false)
        }
        if x.a("essence", "gasoil", "carburant", "fioul") && x.a("stocker", "bidon", "cave", "garder") { return .horsPerimetre(message: messageCarburant, urgenceVitale: false) }
        if x.a("vacances", "voyage", "valise", "partir en week") && !x.a("evacu", "alerte") { return .horsPerimetre(message: messageVoyage, urgenceVitale: false) }
        if x.a("numero") && x.a("urgence electricite", "urgence gaz", "electricite ou gaz", "gaz ou electricite", "enedis", "grdf", "cable est tombe", "cable tombe") {
            return .horsPerimetre(message: messageNumerosReseaux, urgenceVitale: false)
        }
        if x.a("disjoncteur", "plombs ont saute", "fusible") { return .horsPerimetre(message: messageTechnique, urgenceVitale: false) }
        if x.a("batterie de ma voiture", "batterie de la voiture", "pinces croco", "demarre plus", "demarre pas", "pare brise", "essuie glace") {
            return .horsPerimetre(message: messageTechnique, urgenceVitale: false)
        }
        if x.a("regime", "maigrir", "couper la faim", "perdre du poids", "calories") { return .horsPerimetre(message: messageAlimentation, urgenceVitale: false) }
        if x.a("collet", "piege", "pieger", "chasser", "braconn") && !x.a("piege a", "pieges humains", "piege de la") { return .horsPerimetre(message: messageChasse, urgenceVitale: false) }
        if x.a("urine", "pipi") && x.a("boire") { return .horsPerimetre(message: messageUrine, urgenceVitale: false) }
        if x.a("feu de camp", "chamallow", "griller", "barbecue entre amis", "brochette") && !x.a("survie") { return .horsPerimetre(message: messageFeuLoisir, urgenceVitale: false) }
        if x.a("abri de jardin", "permis de construire", "cabane de jardin", "construire une cabane", "veranda") { return .horsPerimetre(message: messageUrbanisme, urgenceVitale: false) }
        if x.a("venger", "vengeance", "pirater le compte", "pirater son", "hacker son", "retrouver l arnaqueur") { return .horsPerimetre(message: messageVengeance, urgenceVitale: false) }
        if x.a("tache", "detacher", "canape", "tapis", "moquette") && !x.a("tache de sang") { return .horsPerimetre(message: messageMenage, urgenceVitale: false) }
        if x.a("main courante") && x.a("commissariat", "voisin", "bruit", "police", "gendarmerie") { return .horsPerimetre(message: messageDemarches, urgenceVitale: false) }
        if x.a("drone", "piloter mon", "piloter un avion") { return .horsPerimetre(message: messageDemarches, urgenceVitale: false) }
        if x.a("sport", "musculation", "abdos", "fitness", "exercices physiques") && !x.a("exercice de crise", "exercice de gestion") {
            return .horsPerimetre(message: messageSport, urgenceVitale: false)
        }
        if x.a("ortie") && x.a("pique", "piqure", "gratte", "brule", "demange") { return .horsPerimetre(message: messageSansGuideSante, urgenceVitale: false) }
        // Identification de plantes ou de champignons : jamais (règle 6), sauf questions sur les 3 plantes du guide.
        let manger = x.a("manger", "mange", "comestible", "salade", "cuisiner", "consommer", "edible")
        if manger && x.a("champignon", "mushroom") && !x.a("enfant a mange", "fils a mange", "fille a mange", "a mange des", "vomi") {
            return .horsPerimetre(message: messageIdentification, urgenceVitale: false)
        }
        // Guides 1.2 : plus aucune fiche de plante ; toute demande « je peux manger cette plante » est refusée.
        if manger && x.a("plantain", "ortie", "massette", "pousse", "pissenlit", "ail des ours", "baies", "champignon") && !x.a("a mange", "ont mange", "vomi") {
            return .horsPerimetre(message: messageIdentification, urgenceVitale: false)
        }
        if manger && x.a("feuilles", "baies", "fleur", "racine", "plante", "herbe") && x.a("sent", "couleur", "vertes", "rouges", "jaune", "blanche", "trouve", "cueilli", "inconnue")
            && !x.a("a mange", "ont mange", "vomi") {
            return .horsPerimetre(message: messageIdentification, urgenceVitale: false)
        }

        if x.a("harcel", "cyberharcel") { return .horsPerimetre(message: messageHarcelement, urgenceVitale: false) }

        // Blessures sans guide (retour d'essai de Benjamin, 27/11/2026) : fractures, entorses, objet qui a percé la peau.
        let membre = x.a("jambe", "bras", "poignet", "cheville", "cote", "doigt", "pied", "main", "genou", "epaule", "hanche", "os ", "nez", "clavicule", "dos", "orteil")
        if (x.a("casse", "cassee", "fracture", "brise") && membre) || x.a("entorse", "foulure", "luxation", "luxe", "tordu la cheville", "tordu le") {
            if !x.a(saignementFort) { return .horsPerimetre(message: messageBlessure, urgenceVitale: false) }
        }
        if x.a("clou", "epine", "echarde", "eclat de verre", "morceau de verre", "hamecon") && !x.a(saignementFort) && !x.a("plante dans", "plante au") {
            return .horsPerimetre(message: messagePlaiePerforante, urgenceVitale: false)
        }

        // 3. Espace mairie : les guides de la commune, sans les risques du grand public, sauf urgence vitale.
        if espaceMairie && !vital(x) {
            if x.a("main courante", "briefing", "reunit", "se reunit", "roles", "role ", "accueillir les sinistres", "reconnaissance catastrophe", "activer le pcc", "activer le poste", "methode en 4", "4 etapes") {
                if x.a("activer le poste", "dois activer", "activer le pcc maintenant", "briefing") { return .guide(id: "pilotage") }
                return .guide(id: "cellule-crise")
            }
            if x.a("cnil", "rancon", "chiffre", "crypte", "cyberattaque", "piratage", "messagerie et le site") && !x.a("communication", "cote communication", "preparer la communication") {
                return .consigne(guideId: "cyberattaque-commune", lignes: (g["cyberattaque-commune"]?.blocs ?? []).flatMap(\.textesRecherche), urgenceVitale: false)
            }
            if x.a("communiqu", "journaliste", "message aux habitants", "facebook", "rumeur", "presse", "trame", "communication") { return .guide(id: "com-crise") }
            if x.a("exercice", "entrainer", "simulation") { return .guide(id: "exercice-retex") }
            if x.a("point de situation", "points de situation", "epuise", "fatigue", "releve", "pilote", "piloter la crise", "24 heures") { return .guide(id: "pilotage") }
            return .recherche(texte: x.t.trimmingCharacters(in: .whitespaces))
        }

        // 4. Demandes très courtes : une question, avec boutons.
        if x.nombreDeMots <= 8, let c = clarificationCourte(x) { return c }

        let appareilMedical = x.a("appareil medical", "machine a oxygene", "concentrateur", "respirateur", "assistance respiratoire", "dialyse", "oxygene", "appareil respiratoire")
        if appareilMedical && x.a("arrive plus a respirer", "arrive pas a respirer", "respire mal", "etouff", "malaise", "inconscient", "repond plus", "bleu") && !x.a("respire bien") {
            return .sante(guideId: "numeros", lignes: alertes("arret-cardiaque", g) + numeros(["15", "112"], g))
        }
        // Ingestion de baies ou de plantes avec symptômes : 15 ou 112, haut-parleur.
        if x.a("a mange", "ont mange", "avale") && x.a("baies", "plante", "champignon", "feuilles") && x.a("vomi", "mal au ventre", "malade", "somnol", "bizarre") {
            return .sante(guideId: "numeros", lignes: alertes("arret-cardiaque", g) + numeros(["15", "112"], g))
        }

        // Assurance et hébergement : avant la garde vitale (« l'assurance ne répond pas » n'est pas une personne inconsciente).
        if x.a("assurance", "assureur") && !x.a("respire", "inconscient", "saigne", "malaise") && !x.a("comparer", "tarif") { return .guide(id: "assurance") }
        if x.a("ou dormir", "hebergement", "reloger", "plus de logement", "perdu notre maison", "perdu ma maison") { return .guide(id: "assurance") }

        guard !vital(x) else { return nil }

        // Moral d'un proche après la crise (avant « après la crise »).
        if x.a("arrive plus a dormir", "arrive pas a dormir", "dors plus", "dormir depuis", "insomnie", "s isole", "enferme dans sa chambre", "plus parler a personne", "ne parle plus", "mange presque plus", "apres un choc", "cauchemar") {
            return .guide(id: "moral")
        }

        // Cyber des particuliers (avant « après la crise » : « je viens de rentrer ma carte bancaire »).
        if let d = cyberParticulier(x, g) { return d }
        // Personne âgée seule : registre de la mairie (avant la coupure : « peur que le courant coupe »).
        if x.a("registre", "seule", "seul ", "isolee", "agee") && x.a("mairie") && x.a("chaud", "canicule", "ete", "chaleur") { return .guide(id: "canicule") }

        // 5. Après la crise : retour au logement, assurance.
        let apres = x.a("apres l inondation", "apres la crue", "apres la decrue", "decrue", "apres la tempete", "rentrer chez", "rentrer dans ma", "laisse rentrer", "on rentre", "quand on rentre",
                        "viens de rentrer", "expert", "sinistre", "jeter les meubles", "nettoyer la boue", "nettoyer", "secher", "tout perdu", "maison inondee", "maison a ete", "pendant la crue")
        if apres || x.a("cat nat", "catnat", "catastrophe naturelle", "assurance", "assureur", "assu ") {
            if x.a("cat nat", "catnat", "assurance", "assureur", "assu ", "declarer", "catastrophe naturelle", "papiers", "demarches", "indemnis") && !x.a("expert de l assurance vient", "expert vient de passer") {
                return .guide(id: "assurance")
            }
            if apres {
                var l = (g["retour"]?.blocs ?? []).flatMap(\.textesRecherche)
                if x.a("gaz") { l = enTete(l, "Odeur de gaz") + lignes("reflexes", contenant: "N'allumez aucune flamme", g) + numeros(["18", "112"], g) }
                if x.a("expert de l assurance vient", "expert vient de passer", "apres le passage") { l = textes("retour", titre: "Après le passage de l'expert", g) + l.filter { !textes("retour", titre: "Après le passage de l'expert", g).contains($0) } }
                if x.a("animal mort", "animaux morts", "bidon", "produits chimiques", "chimique") { l = enTete(l, "animaux morts") }
                if x.a("chauffage", "prises", "electrique", "rallumer") { l = enTete(l, "chauffage") }
                if x.a("prevenir la mairie", "heberge", "chez ma soeur", "chez des amis", "chez ma famille", "pas au gymnase") { l = enTete(l, "prévenez la mairie") }
                return .consigne(guideId: "retour", lignes: l, urgenceVitale: false)
            }
        }

        // 6. Coupure d'électricité.
        let coupure = (x.a("frigo", "refrigerateur", "congelateur") && x.a("coupe", "marche plus", "s est arrete", "ne marche")) || x.a("plus d electricite", "plus de courant", "coupure de courant", "coupure d electricite", "courant coupe", "courant a coupe", "courant est coupe",
                          "panne de courant", "panne d electricite", "blackout", "no electricity", "power cut", "power outage", "courant vient de couper", "plus de lumiere")
        if appareilMedical && (coupure || x.a("courant", "electricite", "batterie")) {
            let l = enTete((g["coupure-electricite"]?.blocs ?? []).flatMap(\.textesRecherche), "appareil médical") + numeros(["15", "112"], g)
            return .consigne(guideId: "coupure-electricite", lignes: l, urgenceVitale: false)
        }
        let symptomesCO = x.a("mal a la tete", "mal de tete", "vomir", "nausee", "vertige", "etourdi", "somnol")
        if coupure && !symptomesCO {
            var l = (g["coupure-electricite"]?.blocs ?? []).flatMap(\.textesRecherche)
            if x.a("barbecue", "groupe electrogene", "poele", "rechaud", "chauffage d appoint", "petrole") { l = enTete(l, "monoxyde") + alertes("monoxyde", g) }
            if x.a("batterie", "telephone", "phone", "internet", "joindre") { l = enTete(l, "batterie") }
            return .consigne(guideId: "coupure-electricite", lignes: l, urgenceVitale: false)
        }

        // 8. Préparation.
        if x.a("detecteur") && !x.a("sonne", "bip", "alarme") { return .guide(id: "incendie-domicile") }
        if x.a("argent liquide", "especes", "panne bancaire", "liquide chez") { return .guide(id: "documents") }
        if x.a("papiers", "documents") && x.a("sauvegarder", "prouver", "copie", "numeriser", "conserver", "proteger") { return .guide(id: "documents") }
        if x.a("sac d evacuation", "sac de fuite", "sac d urgence") && x.a("chien", "chat", "animal") {
            let l = lignes("documents", contenant: "animaux", g) + lignesPartout("nourriture pour animaux", g) + lignes("abri-evacuation", contenant: "pas toujours acceptés", g)
            return .consigne(guideId: "documents", lignes: l, urgenceVitale: false)
        }
        if x.a("sac d evacuation", "sac de fuite", "sac d urgence") && x.a("taille", "litres", "ranger", "insuline", "traitement", "diabet") { return .guide(id: "sac-evacuation") }
        if x.a("kit") && x.a("72", "urgence") && x.a("bebe", "nourrisson", "frequence", "verifier", "litres", "combien", "eau") { return .guide(id: "kit72h") }
        if x.a("plan d evacuation", "evacuer a pied", "a velo") { return .guide(id: "plan-evacuation") }
        if x.a("coffre", "voiture", "vehicule") && x.a("garder", "pret a partir", "preparer", "mettre dans") && !x.a("pas de voiture", "sans voiture") { return .guide(id: "vehicule") }
        if x.a("communiquer", "joindre", "contacter") && x.a("reseau", "internet", "telephone") && x.a("coupe", "sans", "plus de") { return .guide(id: "communication") }
        if x.a("m engager", "aider ma commune", "benevole", "reserve communale", "aider mes voisins") { return .guide(id: "engagement") }
        if x.a("couper") && x.a("gaz", "eau", "electricite") && x.a("preparer", "avant", "comment") { return .guide(id: "pfms") }

        // 9. Survie et nature.
        if x.a("perdu", "perdus", "lost") && x.a("foret", "bois", "montagne", "sentier", "rando", "chemin", "nature", "nuit") && !x.a("demarches", "papiers") {
            return .guide(id: x.a("signal", "helicoptere", "bras") ? "signaux" : "orientation")
        }
        if x.a("cueillir", "cueillette", "plantes sauvages") { return .guide(id: "cueillette") }
        if x.a("javel") && x.a("eau a boire", "potable", "desinfecter l eau", "boire", "dosage") { return .guide(id: "eau") }
        if x.a("perdu dans mes demarches", "perdu avec les papiers", "perdu dans les papiers") { return .guide(id: "assurance") }
        if x.a("feux en triangle", "3 feux", "trois feux") && x.a("aout", "sec", "seche", "foret", "ete ", "juillet") {
            return .consigne(guideId: "signaux", lignes: alertes("feu", g) + lignes("signaux", contenant: "", g).filter { !$0.contains("feux en triangle") }, urgenceVitale: false)
        }
        if x.a("feux en triangle", "me signaler", "se signaler", "signaler aux secours", "helicoptere") { return .guide(id: "signaux") }
        if x.a("randonnee", "rando", "balade", "sortie en montagne") && x.a("preparer", "avant de partir", "demain") { return .guide(id: "priorites") }
        if x.a("regle des 3", "regle de 3", "priorites de survie") { return .guide(id: "priorites") }
        if x.a("bloque", "coince") && x.a("neige", "froid") { return .guide(id: "grand-froid") }
        if x.a("eau de pluie", "plus d eau courante", "plus d eau dans", "eau courante") && x.a("boire", "potable", "malade", "toilette", "hygiene") {
            return .guide(id: x.a("boire", "potable", "malade") ? "eau" : "hygiene")
        }
        if x.a("grelotte", "hypotherm", "trempe") && x.a("arrive plus", "confus", "reflechir", "marcher") {
            return x.a(Triage.soi) && !x.a(tiers) ? .urgencePersonnelle : .horsPerimetre(message: messageSansGuideVital, urgenceVitale: true)
        }
        return nil
    }

    static func cyberParticulier(_ x: Texte, _ g: [String: Guide]) -> Decision? {
        if x.a("demande mon code", "demande mes codes", "mot de passe", "mail de ma banque", "sms de ma banque", "message de ma banque") && !x.a("gestionnaire") {
            return .consigne(guideId: "cyberattaque", lignes: textes("cyberattaque", titre: "J'ai reçu un message suspect ou j'ai été arnaqué", g), urgenceVitale: false)
        }
        if x.a("faux site", "carte bancaire", "coordonnees bancaires", "faux conseiller", "compte en banque", "phishing", "hameconnage", "hacked", "fake website") {
            return .consigne(guideId: "cyberattaque", lignes: textes("cyberattaque", titre: "J'ai reçu un message suspect ou j'ai été arnaqué", g) + textes("cyberattaque", titre: "Un de mes comptes est piraté", g), urgenceVitale: false)
        }
        if x.a("rancon", "ecran rouge", "payer pour debloquer", "fichiers bloques", "ransom") {
            return .consigne(guideId: "cyberattaque", lignes: textes("cyberattaque", titre: "Mon appareil est bloqué et on me demande une rançon", g), urgenceVitale: false)
        }
        if x.a("virus", "malware") && x.a("ordinateur", "pc ", "mail", "telephone", "fichier", "clique", "portable") { return .guide(id: "cyberattaque") }
        if x.a("pirate", "piratage", "hack") && x.a("compte", "insta", "facebook", "mail", "messagerie", "whatsapp") {
            return .consigne(guideId: "cyberattaque", lignes: textes("cyberattaque", titre: "Un de mes comptes est piraté", g), urgenceVitale: false)
        }
        if x.a("contenu illicite", "site illicite", "pharos", "signaler un site", "signaler un contenu") { return .guide(id: "desinformation") }
        if x.a("cyberattaque", "panne internet", "plus d internet") && x.a("rumeur", "whatsapp", "c est vrai", "message") {
            return .consigne(guideId: "cyberattaque", lignes: textes("cyberattaque", titre: "Si une cyberattaque touche tout le pays", g) + etapes("desinformation", g), urgenceVitale: false)
        }

        return nil
    }

    /// Les lignes de tous les guides qui contiennent un texte.
    static func lignesPartout(_ s: String, _ g: [String: Guide]) -> [String] {
        g.keys.sorted().flatMap { lignes($0, contenant: s, g) }
    }

    // MARK: Clarification des demandes courtes

    static func clarificationCourte(_ x: Texte) -> Decision? {
        func c(_ q: String, _ o: [(String, String)]) -> Decision { .clarification(question: q, options: o.map { OptionClarification(libelle: $0.0, question: $0.1) }) }
        if x.a("eau") && x.a("stocker", "combien", "prevoir") && !x.a("72", "semaine", "jours") {
            return c("Pour combien de temps ?", [("Kit d'urgence 72 heures", "combien d eau pour le kit 72 heures"), ("Stock de 2 semaines à la maison", "stock d eau pour deux semaines a la maison")])
        }
        if x.a("sac") && x.a("mets quoi", "mettre", "dedans", "contenu", "quoi") {
            return c("De quel sac parlez-vous ?", [("Kit d'urgence 72 h, à la maison", "que mettre dans le kit d urgence 72 heures"), ("Sac d'évacuation, à emporter", "que mettre dans le sac d evacuation"), ("Ce que j'ai toujours sur moi", "edc ce que j ai toujours sur moi")])
        }
        if x.nombreDeMots <= 3 && x.a("plus de courant", "plus d electricite", "panne de courant", "coupure de courant") {
            return c("La coupure touche-t-elle tout le quartier ?", [("Oui, tout le quartier", "coupure d electricite dans tout le quartier que faire"), ("Non, seulement chez moi", "le disjoncteur de chez moi a saute")])
        }
        if x.a("couper") && x.a("chez moi", "maison") && !x.a("gaz", "eau", "electricite") {
            return c("Que voulez-vous faire ?", [("Préparer la coupure du gaz, de l'eau et de l'électricité", "comment preparer la coupure du gaz de l eau et de l electricite avant une crise"), ("Couper pendant une alerte", "pendant une alerte faut il couper le gaz et l electricite")])
        }
        if x.a("detecteur") {
            return c("Quel détecteur ?", [("Détecteur de fumée", "ou installer le detecteur de fumee"), ("Monoxyde de carbone", "monoxyde de carbone appareils a combustion")])
        }
        if x.a("besoin d un abri", "un abri") && x.nombreDeMots <= 6 {
            return c("Où êtes-vous ?", [("Dehors, dans la nature", "construire un abri de fortune dans la nature"), ("Une alerte en cours", "ou me mettre a l abri pendant une alerte")])
        }
        if x.a("faire du feu", "faire un feu", "allumer un feu") && x.nombreDeMots <= 5 {
            return c("Dans quelle situation ?", [("En situation de survie, dehors", "allumer un feu en situation de survie reelle"), ("Le feu a pris chez moi", "le feu a pris chez moi")])
        }
        if x.a("eau") && x.a("pas potable", "potable", "polluee", "sale") && x.nombreDeMots <= 4 {
            return c("D'où vient l'eau ?", [("Rivière ou source, dans la nature", "rendre l eau de riviere potable dans la nature"), ("Robinet coupé ou pollué, à la maison", "plus d eau courante a la maison comment boire")])
        }
        if x.a("je suis perdu", "suis perdue", "on est perdus") && x.nombreDeMots <= 4 {
            return c("Perdu où ?", [("Dehors, dans la nature", "perdu en foret je retrouve plus le chemin"), ("Dans mes démarches après une crise", "perdu dans mes demarches d assurance apres catastrophe")])
        }
        if x.a("signaler") && x.nombreDeMots <= 3 {
            return c("Que voulez-vous signaler ?", [("Me signaler aux secours", "comment me signaler aux secours helicoptere"), ("Un contenu illicite ou une fausse information", "signaler un contenu illicite sur internet")])
        }
        if x.a("pirate", "piratage") && x.nombreDeMots <= 3 {
            return c("Qu'est-ce qui est touché ?", [("Un de mes comptes", "mon compte mail a ete pirate"), ("Mon appareil bloqué contre une rançon", "mon ordinateur bloque demande une rancon")])
        }
        if x.a("arnaque") && x.nombreDeMots <= 3 {
            return c("Que s'est-il passé ?", [("J'ai donné mes coordonnées bancaires", "j ai donne ma carte bancaire sur un faux site"), ("J'ai reçu un message suspect", "j ai recu un sms suspect que faire")])
        }
        if x.a("assurance") && x.nombreDeMots <= 3 {
            return c("Que cherchez-vous ?", [("Déclarer une catastrophe naturelle", "declarer catastrophe naturelle assurance delai"), ("Préparer mes documents et photos", "sauvegarder mes papiers et prouver mes biens")])
        }
        if x.a("rentrer chez moi", "rentrer a la maison") && x.nombreDeMots <= 6 {
            return c("Après quel événement ?", [("Après une inondation ou un sinistre", "apres l inondation peut on rentrer chez moi"), ("Après une alerte (sirène, confinement)", "fin de l alerte comment savoir")])
        }
        if x.a("pas le moral", "moral a zero", "deprime") && x.nombreDeMots <= 5 {
            return c("Comment vous sentez-vous ?", [("J'ai des idées noires", "j ai des idees noires"), ("Je suis stressé après la crise", "stress apres la crise prendre soin du moral")])
        }
        if x.nombreDeMots <= 2 && x.a("cyberattaque") {
            return c("Qui est touché ?", [("Mon ordinateur ou mon compte", "mon ordinateur bloque demande une rancon"), ("La mairie (élus, agents)", "les serveurs de la mairie sont chiffres que faire cnil")])
        }
        if x.nombreDeMots <= 2 && x.a("communiquer") {
            return c("Communiquer avec qui ?", [("Mes proches, sans réseau", "comment communiquer avec mes proches sans reseau telephone coupe"), ("La mairie vers les habitants", "notre mairie quelle trame pour le message aux habitants")])
        }
        if x.a("exercice") && x.nombreDeMots <= 4 {
            return c("Quel exercice ?", [("Exercice de crise en mairie", "comment preparer un exercice de crise pour les agents de la commune"), ("Exercice en famille (évacuation)", "preparer son plan d evacuation en famille")])
        }
        if x.a("activer la cellule", "cellule de crise") && x.nombreDeMots <= 4 {
            return c("Que voulez-vous savoir ?", [("Quand activer le poste de commandement", "maire quand dois activer le poste de commandement communal"), ("Les rôles dans la cellule", "quels roles repartir dans le poste de commandement communal")])
        }
        if x.nombreDeMots <= 2 && x.a("mairie") {
            return c("Vous êtes :", [("Élu ou agent de la commune", "maire quels roles repartir dans le poste de commandement communal"), ("Habitant", "registre mairie personnes agees seules canicule")])
        }
        return nil
    }
}
