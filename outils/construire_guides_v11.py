#!/usr/bin/env python3
"""Construit contenus/guides/guides_v1.1.json à partir de la version 1.0 fournie par Benjamin.

Chaque correction de la revue (contenus/guides/REVUE_v1.0.md) est appliquée ici,
pour que l'écart entre les deux versions reste lisible et rejouable.

Usage : python3 outils/construire_guides_v11.py
"""
import copy
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
SOURCE = RACINE / "contenus" / "guides" / "guides_v1.0.json"
CIBLE = RACINE / "contenus" / "guides" / "guides_v1.1.json"
DATE = "2026-11-25"

# Sources : titre, éditeur, date, adresse, statut de réutilisation.
SOURCES = {
    "S1": {"titre": "Affiche « Votre kit d'urgence 72 h »", "editeur": "Pouvoirs publics, illustration Antoine Dagan (CitizenPress)", "date": "2022", "url": None, "type": "officiel", "reutilisation": "Texte réutilisable en citant la source. Illustration protégée : ne jamais la reproduire"},
    "S2": {"titre": "Tous responsables. Face aux risques, agissons : bien préparés, bien protégés, tous engagés", "editeur": "SGDSN (Premier ministre)", "date": "2025-11-20", "url": "https://www.info.gouv.fr/risques/se-preparer-a-une-situation-durgence", "type": "officiel", "reutilisation": "Information publique, réutilisable en citant la source et la date (art. L321-1 du CRPA)"},
    "S3": {"titre": "Plan individuel de mise en sûreté (PIMS)", "editeur": "DGSCGC, ministère de l'Intérieur", "date": None, "url": None, "type": "officiel", "reutilisation": "Information publique, citer la source. Date et adresse à compléter"},
    "S4": {"titre": "ORSEC, plan familial de mise en sûreté (PFMS)", "editeur": "Ministère de l'Intérieur et IRMa", "date": "2010", "url": None, "type": "officiel", "reutilisation": "Information publique. Document de 2010 : chaque consigne est à vérifier sur une source récente"},
    "S5": {"titre": "Checklist EDC (EveryDay Carry)", "editeur": "Auteur privé", "date": "2024", "url": None, "type": "prive", "reutilisation": "Création protégée : contenu réécrit, ne pas reproduire la mise en forme"},
    "S7": {"titre": "Checklist plan d'évacuation", "editeur": "Auteur privé", "date": None, "url": None, "type": "prive", "reutilisation": "Création protégée : contenu réécrit"},
    "S9": {"titre": "Techniques de survie", "editeur": "La Libellule (Genève)", "date": None, "url": None, "type": "prive", "reutilisation": "Création protégée : contenu réécrit. Autorisation ou partenariat à demander"},
    "S10": {"titre": "Les 10 techniques de survie à maîtriser", "editeur": "APARS56", "date": None, "url": None, "type": "prive", "reutilisation": "Création protégée : contenu réécrit. Autorisation ou partenariat à demander"},
    "S11": {"titre": "Petit manuel de préparation aux situations d'urgence, v4", "editeur": "Atelier ILYS", "date": None, "url": None, "type": "prive", "reutilisation": "Licence à vérifier (peut-être Creative Commons). Contenu réécrit en attendant"},
    "S12": {"titre": "Phase 8 : guide de préparation à la survie urbaine", "editeur": "Résilience urbaine", "date": None, "url": None, "type": "prive", "reutilisation": "Création protégée : contenu réécrit. Autorisation ou partenariat à demander"},
    "S13": {"titre": "Guide de survie face à la crise", "editeur": "Ministère des Armées, DRSD", "date": None, "url": None, "type": "officiel", "reutilisation": "Information publique, citer la source. Écrit pour les entreprises : adapté au vocabulaire communal"},
    "S14": {"titre": "Anticiper et gérer sa communication de crise cyber, checklist", "editeur": "ANSSI", "date": "2026-05", "url": None, "type": "officiel", "reutilisation": "Information publique, citer la source. Licence exacte à vérifier"},
    "S15": {"titre": "Catastrophe naturelle ou technologique : indemnisation par l'assurance", "editeur": "Service-public.gouv.fr (DILA)", "date": "consultée le 2026-11-25", "url": "https://www.service-public.gouv.fr/particuliers/vosdroits/F3078", "type": "officiel", "reutilisation": "Information publique"},
    "S16": {"titre": "Détecteur de fumée : sécurité incendie dans le logement", "editeur": "Service-public.gouv.fr (DILA)", "date": "consultée le 2026-11-25", "url": "https://www.service-public.gouv.fr/particuliers/vosdroits/F19950", "type": "officiel", "reutilisation": "Information publique"},
    "S17": {"titre": "Recommandations PSC1 et « gestes qui sauvent »", "editeur": "Ministère de l'Intérieur, sécurité civile", "date": "2023-12", "url": "https://www.interieur.gouv.fr/Le-ministere/Securite-civile/Documentation-technique/Secourisme-et-associations/Les-recommandations-et-les-referentiels", "type": "officiel", "reutilisation": "Information publique, citer la source. Fiches à relire par un formateur agréé"},
    "S18": {"titre": "Procédure de désinfection de l'eau hors réseau", "editeur": "ARS Guadeloupe", "date": "2017", "url": "https://www.guadeloupe.ars.sante.fr/system/files/2017-09/proc%C3%A9dure%20d%C3%A9sinfection%20eau%20hors%20reseau.pdf", "type": "officiel", "reutilisation": "Information publique. Vérifier une recommandation nationale équivalente"},
    "S19": {"titre": "Distribution des comprimés d'iode autour des centrales nucléaires", "editeur": "Ordre national des pharmaciens, ASNR", "date": "2019 à 2025", "url": "https://www.ordre.pharmacien.fr/les-communications/focus-sur/les-actualites/campagne-de-distribution-de-comprimes-d-iode-stable-dans-les-officines-situees-dans-un-rayon-de-10-a-20-km-des-centrales-nucleaires-de-production-d", "type": "officiel", "reutilisation": "Information publique"},
    "S20": {"titre": "Canicule, grand froid, monoxyde de carbone : conseils de prévention", "editeur": "Santé publique France, ministère de la Santé", "date": None, "url": None, "type": "officiel", "reutilisation": "Information publique. Pages exactes à citer après vérification"},
    "S21": {"titre": "Cybercriminalité : se protéger et réagir", "editeur": "Service d'information du Gouvernement (info.gouv.fr)", "date": "consultée le 2026-11-25", "url": "https://www.info.gouv.fr/risques/cybercriminalite", "type": "officiel", "reutilisation": "Information publique"},
    "S22": {"titre": "Mémo rançongiciels et 17Cyber", "editeur": "Cybermalveillance.gouv.fr (GIP ACYMA), Police et Gendarmerie nationales", "date": "2024-12 et 2025-06", "url": "https://www.cybermalveillance.gouv.fr/medias/2025/06/210630_Memo_Rancongiciels_SCREEN.pdf", "type": "officiel", "reutilisation": "Information publique, citer la source"},
    "S23": {"titre": "SMS, appels et courriels indésirables ou frauduleux", "editeur": "ARCEP", "date": "consultée le 2026-11-25", "url": "https://www.arcep.fr/demarches-et-services/utilisateurs/sms-appels-et-courriers-electroniques-indesirables-et-ou-frauduleux.html", "type": "officiel", "reutilisation": "Information publique"},
    "S25": {"titre": "SAUV Life et Staying Alive, applications de citoyens sauveteurs", "editeur": "SAMU partenaires ; CHU d'Amiens (dossier de presse SAUV Life, 2021)", "date": "2021", "url": "https://www.chu-amiens.fr/wp-content/uploads/2021/10/sauv-life-dossier-presse-22-10-2021.pdf", "type": "officiel", "reutilisation": "Information publique, citer la source"},
    "S24": {"titre": "Règlement général sur la protection des données, article 33", "editeur": "Union européenne, CNIL", "date": "2016", "url": "https://www.cnil.fr/fr/reglement-europeen-protection-donnees/chapitre4#Article33", "type": "officiel", "reutilisation": "Texte officiel"},
}
OFFICIELLES = {k for k, v in SOURCES.items() if v["type"] == "officiel"}

d = json.loads(SOURCE.read_text(encoding="utf-8"))
g = {x["id"]: x for x in d["guides"]}
a_verifier = {}


def bloc(gid, cond):
    """Premier bloc du guide qui vérifie la condition."""
    for b in g[gid]["blocs"]:
        if cond(b):
            return b
    raise KeyError(gid)


def remplacer_texte(gid, ancien, nouveau):
    """Remplace un texte dans tous les champs d'un guide ; échoue s'il est absent."""
    s = json.dumps(g[gid]["blocs"], ensure_ascii=False)
    assert ancien in s, (gid, ancien)
    g[gid]["blocs"] = json.loads(s.replace(ancien, nouveau))


# ---------- Urgence ----------
remplacer_texte("alerte", "France Bleu, France Info, France Inter", "ici, ex-France Bleu ; France Info ; France Inter")
remplacer_texte("alerte", "\"France Bleu (FM)\"", "\"ici, ex-France Bleu (FM)\"")
a_verifier["alerte"] = ["Calendrier des essais de la sirène « corne de brume » (source de 2010) : à confirmer auprès de la préfecture"]
a_verifier["numeros"] = ["Numéro vert 0 800 50 73 05 du signal national d'alerte : à confirmer avant publication"]

remplacer_texte("risques", "Anticipez : retirez vos comprimés d'iode (gratuits) en pharmacie.",
                "Si vous habitez à moins de 20 km d'une centrale nucléaire, retirez vos comprimés d'iode en pharmacie (renseignez-vous en mairie).")
g["risques"]["sources"] = ["S2", "S3", "S19"]

# Trousses : on garde la trousse familiale, on retire l'IFAK et le trauma kit (matériel réservé aux personnes formées).
t = g["trousses"]
t["titre"] = "Trousse de premiers secours"
t["resume"] = "Le contenu d'une trousse familiale."
t["blocs"] = [
    {"t": "alert", "body": "Une trousse ne remplace pas les gestes. Le garrot, par exemple, ne s'utilise qu'après une formation aux gestes qui sauvent : voir « Entraide et engagement »."},
    bloc("trousses", lambda b: b.get("id") == "trousse-famille"),
    {"t": "tip", "body": "Demandez conseil à votre pharmacien pour adapter la trousse à votre foyer (bébé, allergies, traitements), et vérifiez les dates de péremption deux fois par an."},
]
t["sources"] = ["S2", "S4"]

# ---------- Se préparer ----------
s = g["sac-evacuation"]
s["blocs"][0] = {"t": "text", "body": "Une crise peut vous surprendre au travail, sur la route ou en courses. Prévoyez un sac par personne, à la maison et, si possible, dans la voiture. Un sac de 30 à 40 litres suffit : il doit rester assez léger pour marcher longtemps."}
remplacer_texte("sac-evacuation", "Photos plastifiées de vos proches (utiles en cas de séparation)", "Une photo récente de chaque proche (utile si vous êtes séparés)")

remplacer_texte("edc", "Outil multifonction ou couteau", "Petit outil multifonction (la loi encadre le port d'un couteau)")
a_verifier["edc"] = ["Formulation sur le port d'un outil à lame : à valider par l'avocat"]

st = g["stocks"]
st["resume"] = "Eau, nourriture, hygiène : tenir au-delà de 72 heures."
st["blocs"][0] = {"t": "text", "body": "Sans électricité, l'eau peut ne plus monter dans les étages, et il n'y a plus ni réfrigérateur, ni cuisson électrique, ni chauffage électrique. Le kit de 72 heures recommandé par l'État est la base. Ceux qui le souhaitent peuvent viser ensuite deux semaines d'autonomie, sans achat massif."}
for i, b in enumerate(st["blocs"]):
    if b.get("t") == "kv":
        st["blocs"][i] = {"t": "calc", "titre": "Mon stock d'eau pour deux semaines", "body": "Au moins 2 litres par personne et par jour pour boire, soit 28 litres par personne. Prévoyez davantage pour la cuisine et l'hygiène.", "parPersonne": 28, "unite": "litres"}
    if b.get("titre") == "Stocker l'eau":
        st["blocs"][i] = {"t": "text", "titre": "Stocker l'eau", "body": "Le plus simple est l'eau en bouteilles du commerce, rangée à l'abri de la lumière et de la chaleur, et renouvelée avant sa date limite. Un filtre permet de boire une eau d'origine douteuse."}
remplacer_texte("stocks", "Faites tourner : consommez et remplacez les produits arrivés aux trois quarts de leur durée de vie.", "Faites tourner : consommez les produits les plus anciens et remplacez-les au fur et à mesure.")
st["niveau_force"] = "pratique"

inc = g["incendie-domicile"]
inc["blocs"] = [
    {"t": "check", "id": "feu-maison", "titre": "Équipement", "items": [
        "Un détecteur de fumée, obligatoire dans chaque logement, dans le couloir qui dessert les chambres",
        "Un détecteur par étage (conseillé)",
        "Jamais dans la cuisine ni la salle de bain (fausses alertes)",
        "Tester le détecteur chaque mois",
        "Extincteur et couverture anti-feu près de la cuisine"]},
    {"t": "steps", "titre": "Si le feu prend chez moi", "items": [
        "Je sors avec tout le monde et je ferme la porte de la pièce en feu.",
        "J'appelle le 18 ou le 112 une fois dehors.",
        "Je ne prends jamais l'ascenseur.",
        "Si la fumée envahit l'escalier : je reste chez moi, je ferme la porte, je la mouille et je calfeutre le bas, puis je me signale à la fenêtre."]},
    {"t": "tip", "body": "Rangez vos objets de valeur et vos documents dans une boîte facile à emporter."},
]
inc["sources"] = ["S16", "S2"]
inc["niveau_force"] = "pratique"  # conduite à tenir encore à vérifier
a_verifier["incendie-domicile"] = ["Conduite à tenir en cas d'incendie : à confirmer sur une source des sapeurs-pompiers"]

remplacer_texte("vehicule", "\"Chaque semaine\"", "\"Chaque mois et avant un long trajet\"")

# ---------- Survie et autonomie ----------
remplacer_texte("priorites", "[\"3 heures\", \"sans se protéger des intempéries\"]", "[\"3 minutes\", \"sans respirer\"], [\"3 heures\", \"sans abri par grand froid ou forte chaleur\"]")
remplacer_texte("priorites", ", [\"3 mois\", \"sans hygiène\"]", "")
remplacer_texte("priorites", "L'hypothermie, possible même sous 20 °C avec le vent, l'humidité et la déshydratation.", "L'hypothermie, possible même par temps doux quand on est mouillé et exposé au vent.")

e = g["eau"]
for i, b in enumerate(e["blocs"]):
    if b.get("t") == "alert" and "javel" in b["body"].lower():
        e["blocs"][i] = {"t": "steps", "titre": "Désinfecter à l'eau de Javel (méthode de l'ARS)", "items": [
            "Préparez une solution : 250 ml d'eau de Javel à 2,6 % dans 1 litre d'eau. Elle se garde 24 heures.",
            "Ajoutez 6 gouttes de cette solution par litre d'eau à traiter.",
            "Attendez 30 minutes avant de boire.",
            "Avec des pastilles de purification, suivez leur notice."]}
e["sources"] = ["S18", "S9", "S10", "S12"]
a_verifier["eau"] = ["Dosage de la javel : chercher une recommandation nationale (Santé publique France, ministère de la Santé)"]

f = g["feu"]
for b in f["blocs"]:
    if b.get("t") == "alert":
        b["body"] = "Seulement en situation de survie réelle. En France, allumer un feu dans ou près d'une forêt est en général interdit, et toujours dangereux en période sèche. Préférez un petit feu, surveillé en permanence, et éteignez-le complètement."
a_verifier["feu"] = ["Règles du code forestier sur l'emploi du feu : à citer précisément"]

o = g["orientation"]
for b in o["blocs"]:
    if b.get("titre") == "Trouver le nord":
        b["items"] = [
            "Le soleil se lève à l'est et se couche à l'ouest. En France, il passe plein sud vers 13 h en hiver et vers 14 h en été (heure légale).",
            "Avec une montre à aiguilles : pointez l'aiguille des heures vers le soleil. Le sud est à mi-chemin entre cette aiguille et le chiffre 1 (en hiver) ou 2 (en été).",
            "La nuit, l'étoile Polaire indique le nord.",
            "La mousse sur les arbres n'est pas un indicateur fiable."]

sg = g["signaux"]
sg["blocs"][0]["items"].append("Signal de détresse en montagne : 6 signaux par minute (sifflet, lampe, gestes), une minute de pause, puis recommencer. La réponse des secours est de 3 signaux par minute.")

c = g["cueillette"]
c["resume"] = "3 plantes communes et les règles de sécurité."
nouveaux = []
for b in c["blocs"]:
    if b.get("t") == "plant":
        if b["titre"] == "Tussilage":
            continue  # toxique pour le foie (alcaloïdes pyrrolizidiniques)
        b["items"] = [kv for kv in b["items"] if kv[0] != "Soigner"]
        if b["titre"] == "Massette":
            b["items"].append(["Attention", "Jeune, elle peut être confondue avec l'iris jaune, toxique. Ne la cueillez qu'en fleur ou en épi, quand elle est reconnaissable avec certitude."])
    nouveaux.append(b)
c["blocs"] = nouveaux
a_verifier["cueillette"] = ["Identification et confusions possibles : à faire relire par un pharmacien ou un botaniste"]

remplacer_texte("nourriture", "Les petits invertébrés sont la source la plus simple : sauterelles, grillons, escargots, vers de terre.", "Les petits invertébrés (sauterelles, grillons, escargots) sont une source de protéines, toujours bien cuits.")

# ---------- Après la crise ----------
a = g["assurance"]
for b in a["blocs"]:
    if b.get("titre") == "La démarche":
        b["items"] = [
            "Dès le sinistre, signalez-vous à la mairie, qui demande la reconnaissance de l'état de catastrophe naturelle à la préfecture.",
            "Prévenez votre assureur sans attendre et dressez la liste des dégâts, photos à l'appui.",
            "Après la publication de l'arrêté au Journal officiel, vous avez 30 jours pour déclarer vos dommages (règle en vigueur depuis le 1er janvier 2023).",
            "Les délais de versement de l'indemnité sont fixés par le code des assurances : consultez service-public.fr."]
a["sources"] = ["S15", "S4"]

for b in g["engagement"]["blocs"]:
    if b.get("titre") == "S'engager":
        b["items"].insert(0, "Citoyen sauveteur : installez SAUV Life ou Staying Alive pour être alerté d'un arrêt cardiaque près de chez vous.")
        b["items"].insert(1, "Profil d'aidant : indiquez dans SIJAMAIS ce que vous savez faire et ce que vous pouvez prêter, puis partagez-le avec vos proches, vos voisins ou votre mairie.")
g["engagement"]["sources"] = ["S2", "S3", "S4", "S25"]

m = g["moral"]
m["blocs"][0]["items"].append("Idées noires ou détresse : le 3114, numéro national de prévention du suicide, répond 24 h sur 24, gratuitement.")
m["sources"] = ["S13", "S11", "S12"]

# ---------- Espace mairie : vocabulaire du plan communal de sauvegarde ----------
cc = g["cellule-crise"]
cc["titre"] = "Activer le poste de commandement communal"
cc["resume"] = "Le plan communal de sauvegarde en action : organisation, rôles, méthode."
cc["blocs"][0] = {"t": "text", "body": "Le plan communal de sauvegarde (PCS) organise la réponse de la commune. Le maire est directeur des opérations de secours sur sa commune ; les sapeurs-pompiers commandent les opérations de secours sur le terrain. Le poste de commandement communal (PCC) coordonne l'alerte, l'information, l'accueil et le soutien de la population."}
for b in cc["blocs"]:
    if b.get("titre") == "Les rôles clés":
        b["titre"] = "Les rôles au poste de commandement communal"
        b["items"] = [
            "Le maire : décide, fixe les priorités, valide les messages à la population.",
            "Le responsable des actions communales : anime la méthode, suit le plan d'actions et les délais.",
            "Secrétariat et main courante : trace chaque information et chaque décision (elle peut servir de pièce juridique).",
            "Communication : messages à la population, aux médias, veille des réseaux sociaux.",
            "Terrain et liaison : agents et élus sur place, réserve communale de sécurité civile.",
            "Accueil et hébergement : centres d'accueil, ravitaillement, personnes vulnérables.",
            "Logistique : matériel, véhicules, moyens de communication de secours.",
            "Anticipation : imagine les évolutions possibles de la situation."]
    if b.get("t") == "tip":
        b["body"] = "Une équipe formée avec du papier, des stylos et un téléphone fera toujours mieux qu'une équipe non formée équipée d'un logiciel sophistiqué."
cc["sources"] = ["S13", "S3"]
a_verifier["cellule-crise"] = ["Rôles et obligations du PCS (loi du 25 novembre 2021 dite Matras) : à vérifier sur Légifrance et le guide PCS de la DGSCGC"]
remplacer_texte("pilotage", "Faut-il activer la cellule ?", "Faut-il activer le poste de commandement ?")

# ---------- Nouveaux guides ----------
PSC = ["S17"]
nouveaux_guides = [
    {"id": "cyberattaque", "cat": "urgence", "titre": "Cyberattaque et arnaques en ligne", "resume": "Rançon, compte piraté, faux message : que faire, et comment se protéger.", "duree": "4 min", "prioritaire": True, "sensible": False, "blocs": [
        {"t": "text", "body": "Une cyberattaque peut vous viser directement (appareil bloqué contre une rançon, compte piraté, arnaque) ou toucher tout le pays : hôpitaux, paiements, téléphone, internet. Dans les deux cas, quelques réflexes limitent les dégâts."},
        {"t": "steps", "titre": "Mon appareil est bloqué et on me demande une rançon", "items": [
            "Débranchez-le tout de suite d'internet et du réseau : coupez le Wi-Fi, retirez le câble.",
            "Ne l'éteignez pas : mettez-le en veille. Les enquêteurs et les techniciens en auront besoin.",
            "Ne payez pas : le paiement ne garantit pas de retrouver vos fichiers.",
            "Cherchez une solution gratuite de déchiffrement sur nomoreransom.org.",
            "Faites-vous aider sur 17cyber.gouv.fr et portez plainte (commissariat, gendarmerie ou plainte en ligne)."]},
        {"t": "steps", "titre": "Un de mes comptes est piraté", "items": [
            "Changez le mot de passe depuis un autre appareil, sain, puis ceux des comptes qui utilisaient le même.",
            "Activez la double authentification.",
            "Prévenez vos contacts : le pirate peut leur écrire en votre nom.",
            "Suivez la procédure de récupération du service concerné et faites-vous aider sur 17cyber.gouv.fr."]},
        {"t": "steps", "titre": "J'ai reçu un message suspect ou j'ai été arnaqué", "items": [
            "Ne cliquez pas, ne répondez pas, ne rappelez pas le numéro indiqué.",
            "SMS frauduleux : transférez-le au 33700, sans commentaire.",
            "Si vous avez donné vos coordonnées bancaires : appelez votre banque immédiatement pour faire opposition.",
            "Portez plainte et signalez les contenus illicites sur internet-signalement.gouv.fr (Pharos)."]},
        {"t": "list", "titre": "Si une cyberattaque touche tout le pays", "items": [
            "Paiements, téléphone ou internet peuvent être coupés : votre kit de 72 heures et un peu d'argent liquide prennent tout leur sens.",
            "Écoutez la radio et suivez seulement les canaux officiels.",
            "Ne relayez pas les rumeurs : une cyberattaque s'accompagne souvent de fausses informations.",
            "Sans internet, rendez-vous au commissariat, à la gendarmerie ou en mairie."]},
        {"t": "check", "id": "cyber-protection", "titre": "Me protéger dès maintenant", "items": [
            "Un mot de passe solide et différent pour chaque compte important (un gestionnaire de mots de passe aide)",
            "La double authentification sur la messagerie, la banque et les réseaux sociaux",
            "Les mises à jour du téléphone et de l'ordinateur faites sans attendre",
            "Une sauvegarde régulière de mes fichiers sur un support débranché ensuite",
            "Des applications téléchargées seulement depuis les boutiques officielles",
            "De la méfiance envers tout message inattendu ou trop pressant"]},
        {"t": "kv", "titre": "Où trouver de l'aide", "items": [
            ["17cyber.gouv.fr", "Diagnostic et aide aux victimes, échange avec un policier ou un gendarme, 24 h sur 24, gratuit"],
            ["33700", "Signaler un SMS ou un appel frauduleux"],
            ["internet-signalement.gouv.fr", "Signaler un contenu illicite (Pharos)"],
            ["cybermalveillance.gouv.fr", "Conseils et professionnels de confiance près de chez vous"]]}],
     "sources": ["S2", "S21", "S22", "S23"]},
    {"id": "cyberattaque-commune", "cat": "mairie", "titre": "Cyberattaque contre la commune", "resume": "Les premières heures, côté technique et côté communication.", "duree": "4 min", "prioritaire": False, "sensible": False, "blocs": [
        {"t": "steps", "titre": "Les premières heures", "items": [
            "Isolez du réseau les postes et serveurs touchés, sans les éteindre.",
            "Activez la cellule de crise : maire, direction générale, informatique, communication.",
            "Faites-vous aider : 17cyber.gouv.fr est ouvert aux collectivités, et le centre régional de réponse aux incidents (CSIRT) de votre région peut intervenir.",
            "Si des données personnelles sont touchées, notifiez la CNIL dans les 72 heures.",
            "Portez plainte, et ne payez pas de rançon.",
            "Passez en mode dégradé : papier, téléphones de secours, procédures prévues à l'avance."]},
        {"t": "list", "titre": "Communiquer pendant l'attaque", "items": [
            "Organisez l'équipe de communication de crise et répartissez les rôles.",
            "Établissez les faits avant de parler, puis choisissez une posture : communication proactive ou réactive.",
            "Ne communiquez que des informations vérifiées et ne promettez pas de date de retour à la normale.",
            "Informez d'abord les agents, puis les habitants et les usagers.",
            "Ton pédagogique et rassurant, sans termes techniques ni anxiogènes.",
            "Utilisez des canaux de secours si la messagerie ou le site sont touchés, et rappelez aux agents la conduite à tenir face aux médias et sur les réseaux sociaux.",
            "Gelez les publications programmées et centralisez les demandes de la presse."]},
        {"t": "tip", "body": "Préparez-vous avant : un exercice de crise cyber, une boîte à outils de communication prête et des sauvegardes testées font la différence. Voir « Communiquer en crise » et « Exercices et retour d'expérience »."}],
     "sources": ["S14", "S22", "S24"]},
    {"id": "arret-cardiaque", "cat": "urgence", "titre": "Arrêt cardiaque", "resume": "La personne ne répond pas et ne respire pas.", "duree": "1 min", "prioritaire": True, "sensible": True, "blocs": [
        {"t": "alert", "body": "Appelez le 15 ou le 112, mettez le haut-parleur et suivez les instructions."},
        {"t": "steps", "titre": "Alerter, masser, défibriller", "items": [
            "Alertez : 15 ou 112 (114 par SMS). Faites chercher un défibrillateur.",
            "Massez : à genoux, mains l'une sur l'autre au centre de la poitrine, bras tendus. Appuyez fort et vite, 100 à 120 fois par minute, sans vous arrêter.",
            "Défibrillez : allumez l'appareil dès qu'il arrive et suivez ses instructions vocales. Continuez le massage pendant qu'on l'installe."]},
        {"t": "tip", "body": "Vous ne pouvez pas aggraver la situation : sans massage, la personne meurt. Une formation de 2 heures aux gestes qui sauvent vous donne l'assurance nécessaire."},
        {"t": "tip", "titre": "Devenez citoyen sauveteur", "body": "Avec les applications gratuites SAUV Life et Staying Alive, le SAMU ou les pompiers peuvent vous alerter si un arrêt cardiaque survient près de vous, et vous indiquer le défibrillateur le plus proche."}],
     "sources": PSC + ["S25"]},
    {"id": "saignement", "cat": "urgence", "titre": "Saignement abondant", "resume": "Arrêter l'hémorragie en attendant les secours.", "duree": "1 min", "prioritaire": True, "sensible": True, "blocs": [
        {"t": "steps", "titre": "Les gestes", "items": [
            "Appuyez fort et sans relâcher sur la plaie, avec la main protégée (gant, sac plastique) ou un tissu propre.",
            "Allongez la victime.",
            "Faites alerter, ou alertez vous-même : 15 ou 112.",
            "Si vous ne pouvez pas comprimer ou si la compression ne suffit pas sur un bras ou une jambe, et seulement si vous êtes formé : posez un garrot au-dessus de la plaie et notez l'heure."]},
        {"t": "alert", "body": "Ne retirez jamais un objet planté dans une plaie."}],
     "sources": PSC},
    {"id": "inconscient-respire", "cat": "urgence", "titre": "Personne inconsciente qui respire", "resume": "La mettre sur le côté pour protéger sa respiration.", "duree": "1 min", "prioritaire": True, "sensible": True, "blocs": [
        {"t": "steps", "titre": "Les gestes", "items": [
            "Vérifiez qu'elle ne répond pas mais qu'elle respire (le ventre et la poitrine se soulèvent).",
            "Tournez-la sur le côté, tête basculée en arrière, bouche vers le sol : position latérale de sécurité.",
            "Alertez : 15 ou 112.",
            "Couvrez-la et surveillez sa respiration jusqu'à l'arrivée des secours. Si elle ne respire plus : massage cardiaque."]}],
     "sources": PSC},
    {"id": "etouffement", "cat": "urgence", "titre": "Étouffement", "resume": "La personne ne peut plus parler, tousser ni respirer.", "duree": "1 min", "prioritaire": True, "sensible": True, "blocs": [
        {"t": "steps", "titre": "Chez l'adulte et l'enfant", "items": [
            "Penchez la personne en avant et donnez jusqu'à 5 claques vigoureuses entre les omoplates, avec le plat de la main.",
            "Si cela ne suffit pas : placez-vous derrière elle, un poing au creux de l'estomac, et tirez fort vers vous et vers le haut, jusqu'à 5 fois.",
            "Alternez les deux jusqu'à ce que l'objet sorte. Si elle perd connaissance : alertez et commencez le massage cardiaque."]},
        {"t": "alert", "body": "Si la personne tousse et respire encore, ne faites rien d'autre que l'encourager à tousser."},
        {"t": "tip", "body": "Nourrisson : les gestes sont différents. Apprenez-les lors d'une formation."}],
     "sources": PSC},
    {"id": "brulure", "cat": "urgence", "titre": "Brûlure", "resume": "Refroidir tout de suite, longtemps.", "duree": "1 min", "prioritaire": False, "sensible": True, "blocs": [
        {"t": "steps", "titre": "Les gestes", "items": [
            "Refroidissez immédiatement sous l'eau tempérée, pendant au moins 20 minutes.",
            "Retirez les vêtements, sauf s'ils collent à la peau, ainsi que bagues et montre.",
            "Alertez le 15 si la brûlure est plus grande que la moitié de la paume de la victime, si elle touche le visage, les mains ou les parties génitales, si la peau est blanche ou noire, ou s'il s'agit d'un enfant."]},
        {"t": "alert", "body": "Pas de glace, pas de beurre, pas de dentifrice. Ne percez pas les cloques."}],
     "sources": PSC},
    {"id": "monoxyde", "cat": "urgence", "titre": "Monoxyde de carbone", "resume": "Un gaz invisible et sans odeur, premier danger des coupures de courant.", "duree": "1 min", "prioritaire": True, "sensible": True, "blocs": [
        {"t": "list", "titre": "Les signes", "items": ["Maux de tête, nausées, vertiges, fatigue, chez plusieurs personnes du même logement.", "Les symptômes diminuent quand on sort."]},
        {"t": "steps", "titre": "Que faire", "items": ["Aérez immédiatement : ouvrez portes et fenêtres.", "Arrêtez les appareils à combustion.", "Sortez du logement.", "Appelez le 15, le 18 ou le 112."]},
        {"t": "alert", "body": "Jamais de groupe électrogène, de barbecue ou de chauffage d'appoint à combustion dans un local fermé, même garage ou cave."}],
     "sources": ["S20", "S2"]},
    {"id": "canicule", "cat": "urgence", "titre": "Canicule", "resume": "Se protéger de la chaleur et veiller sur les plus fragiles.", "duree": "2 min", "prioritaire": False, "sensible": False, "blocs": [
        {"t": "list", "titre": "Les bons gestes", "items": ["Buvez régulièrement de l'eau, sans attendre d'avoir soif.", "Mouillez-vous le corps et ventilez-vous.", "Fermez volets et fenêtres le jour, aérez la nuit.", "Évitez l'alcool et les efforts aux heures chaudes.", "Passez quelques heures dans un lieu frais (bibliothèque, commerce climatisé).", "Prenez des nouvelles de vos proches âgés ou isolés."]},
        {"t": "tip", "body": "Les mairies tiennent un registre des personnes âgées, handicapées ou isolées, contactées en cas de canicule. Inscrivez-vous ou inscrivez un proche."},
        {"t": "alert", "body": "Malaise, confusion, forte fièvre : appelez le 15."}],
     "sources": ["S20"]},
    {"id": "grand-froid", "cat": "urgence", "titre": "Grand froid", "resume": "Se protéger et se chauffer sans danger.", "duree": "2 min", "prioritaire": False, "sensible": False, "blocs": [
        {"t": "list", "titre": "Les bons gestes", "items": ["Couvrez-vous en plusieurs couches, la tête et les mains en priorité.", "Chauffez sans surchauffer, et ne bouchez jamais les aérations.", "Limitez les sorties des personnes fragiles.", "Prenez des nouvelles des personnes isolées."]},
        {"t": "alert", "body": "Personne sans abri en danger : appelez le 115."}],
     "sources": ["S20"]},
    {"id": "coupure-electricite", "cat": "urgence", "titre": "Coupure d'électricité prolongée", "resume": "Tenir plusieurs jours sans courant.", "duree": "3 min", "prioritaire": True, "sensible": False, "blocs": [
        {"t": "steps", "titre": "Tout de suite", "items": ["Vérifiez si la coupure est générale (voisins, éclairage public).", "Débranchez les appareils sensibles et laissez une lampe allumée pour voir le retour du courant.", "Gardez le réfrigérateur et le congélateur fermés.", "Écoutez la radio à piles pour suivre les consignes."]},
        {"t": "list", "titre": "Si cela dure", "items": ["Utilisez votre kit de 72 heures.", "Personne dépendante d'un appareil médical électrique : contactez son prestataire et signalez-vous en mairie.", "Économisez la batterie du téléphone : mode économie d'énergie, SMS plutôt qu'appels."]},
        {"t": "alert", "body": "Jamais de groupe électrogène ni de barbecue à l'intérieur : risque mortel de monoxyde de carbone."}],
     "sources": ["S2", "S20"]},
]
a_verifier["arret-cardiaque"] = a_verifier["saignement"] = a_verifier["inconscient-respire"] = a_verifier["etouffement"] = a_verifier["brulure"] = ["Texte à relire par un formateur agréé aux premiers secours, mot pour mot contre les recommandations PSC1 de décembre 2023"]
a_verifier["cyberattaque-commune"] = ["Coordonnées du CSIRT régional (Pays de la Loire pour La Baule) à ajouter"]
a_verifier["monoxyde"] = a_verifier["canicule"] = a_verifier["grand-froid"] = ["Pages de Santé publique France à citer précisément"]

ordre = [x["id"] for x in d["guides"]]
pos = ordre.index("trousses")
ordre = ordre[:pos] + ["arret-cardiaque", "saignement", "inconscient-respire", "etouffement", "brulure", "monoxyde", "coupure-electricite", "canicule", "grand-froid", "cyberattaque"] + ordre[pos:]
ordre.insert(ordre.index("com-crise") + 1, "cyberattaque-commune")
for x in nouveaux_guides:
    g[x["id"]] = x

# ---------- Schémas produits avec Claude Design (contenus/guides/schemas/) ----------
import csv
with open(RACINE / "contenus" / "guides" / "schemas" / "textes-alternatifs.csv", encoding="utf-8") as fcsv:
    lignes = list(csv.DictReader(fcsv, delimiter=";"))
schemas_par_guide = {}
for l in lignes:
    n = int(l["N°"])
    schemas_par_guide.setdefault(l["Guide"], []).append({"t": "schema", "fichier": l["Fichier"], "titre": l["Titre"], "alt": l["Texte alternatif"], "relecture_secours": n <= 6})
for gid, sch in schemas_par_guide.items():
    assert gid in g, gid
    assert (RACINE / "contenus" / "guides" / "schemas" / sch[0]["fichier"]).exists()
    g[gid]["blocs"] = [b for b in g[gid]["blocs"] if b.get("t") != "schema"]
    g[gid]["blocs"] = sch + g[gid]["blocs"]


SENSIBLES = {"trousses"}
guides = []
for gid in ordre:
    x = g[gid]
    srcs = x["sources"]
    niveau = x.pop("niveau_force", None) or ("officiel" if set(srcs) <= OFFICIELLES else "pratique")
    x["niveau"] = niveau
    x["sensible"] = x.get("sensible", gid in SENSIBLES)
    x["version"] = "1.1"
    x["maj"] = DATE
    x["relecture"] = {"statut": "non relu", "nom": None, "qualite": None, "date": None}
    x["a_verifier"] = a_verifier.get(gid, [])
    guides.append(x)

for x in guides:
    for s_ in x["sources"]:
        assert s_ in SOURCES, (x["id"], s_)

sortie = {
    "meta": {
        "app": "SIJAMAIS",
        "titre": "Guides SIJAMAIS",
        "version": "1.1",
        "date": DATE,
        "langue": "fr",
        "avertissement": "Version de travail, non relue par des professionnels : ne pas diffuser en l'état. En situation réelle, les consignes des autorités (préfecture, mairie, secours) priment toujours.",
        "niveaux": {"officiel": "Consigne officielle : reprise de documents publics de l'État, citée et datée", "pratique": "Conseil pratique : rédigé par SIJAMAIS à partir de sources diverses, à relire"},
        "regle_gratuite": "Tous ces guides sont gratuits.",
        "historique": "1.0 du 2026-11-25 fournie par Benjamin ; 1.1 corrige selon contenus/guides/REVUE_v1.0.md",
        "sources": SOURCES,
    },
    "categories": d["categories"],
    "guides": guides,
}
CIBLE.write_text(json.dumps(sortie, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
print(f"{len(guides)} guides écrits dans {CIBLE.relative_to(RACINE)}")
print("officiels :", sum(1 for x in guides if x["niveau"] == "officiel"), "; pratiques :", sum(1 for x in guides if x["niveau"] == "pratique"))
