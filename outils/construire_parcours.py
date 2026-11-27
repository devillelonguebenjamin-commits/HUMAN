"""Construit contenus/assistant/parcours_v1.json : le parcours guidé de l'assistant (questions à choix).

Demande de Benjamin du 27/11/2026, après des essais en famille : guider la personne par des choix
plutôt que de compter sur ses mots. Chaque fin de parcours envoie à l'assistant une phrase « canonique »
que le triage comprend sans ambiguïté ; le champ « attendu » (guide et mode) est vérifié par un test.
Usage : python3 outils/construire_parcours.py
"""
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
CIBLE = RACINE / "contenus" / "assistant" / "parcours_v1.json"

noeuds = {}


def noeud(id_, question, options):
    noeuds[id_] = {"id": id_, "question": question, "options": options}


def vers(libelle, suivant, symbole=None):
    return {"libelle": libelle, "suivant": suivant, "symbole": symbole}


def fin(libelle, question, guide, mode, symbole=None):
    return {"libelle": libelle, "question": question, "attendu": {"guide": guide, "mode": mode}, "symbole": symbole}


noeud("racine", "De quoi avez-vous besoin ?", [
    vers("Quelqu'un est en danger, maintenant", "danger", "cross.case.fill"),
    vers("Une alerte est en cours", "alerte", "megaphone.fill"),
    vers("Un événement près de chez moi", "evenement", "cloud.bolt.rain.fill"),
    vers("Me préparer", "preparer", "bag.fill"),
    vers("Après une crise", "apres", "house.fill"),
    vers("Arnaque, piratage, fausse information", "cyber", "lock.shield.fill"),
    vers("Dehors, dans la nature", "nature", "leaf.fill"),
    vers("Je suis élu ou agent de la commune", "mairie", "building.columns.fill"),
])

# Urgence vitale.
noeud("danger", "Pour qui ?", [
    fin("Pour moi", "je n arrive plus a respirer", None, "urgencePersonnelle", "person.fill"),
    vers("Pour quelqu'un d'autre", "danger-proche", "person.2.fill"),
])
noeud("danger-proche", "Que se passe-t-il ?", [
    fin("Ne répond pas et ne respire pas", "il ne repond pas et ne respire pas", "arret-cardiaque", "urgenceSante"),
    fin("Ne répond pas mais respire", "il ne repond pas mais il respire", "inconscient-respire", "urgenceSante"),
    fin("Saigne beaucoup", "il saigne beaucoup", "saignement", "urgenceSante"),
    vers("S'étouffe", "etouffement"),
    fin("S'est brûlé", "il s est brule", "brulure", "urgenceSante"),
    fin("Bouche de travers, bras qui ne se lève plus", "il a la bouche de travers et n arrive plus a lever le bras", None, "aucunGuide"),
    fin("Convulse, tremble de partout", "il fait une crise d epilepsie il tremble de partout", None, "aucunGuide"),
    fin("A avalé un produit ou des médicaments", "il a avale un produit menager", "numeros", "urgenceSante"),
    fin("Maux de tête et vertiges à plusieurs, appareil à combustion", "on a tous mal a la tete et des vertiges depuis qu on a allume le chauffage d appoint", "monoxyde", "urgenceSante"),
    fin("Parle de mourir, d'en finir", "mon proche dit qu il veut en finir", "moral", "urgenceSante"),
])
noeud("etouffement", "Quel âge a la personne ?", [
    fin("Adulte ou enfant", "il s etouffe il ne peut plus parler", "etouffement", "urgenceSante"),
    fin("Bébé de moins d'un an", "mon bebe s etouffe", "etouffement", "urgenceSante"),
    fin("Il tousse et arrive à parler", "il a avale de travers il tousse mais il arrive a parler", "etouffement", "urgenceSante"),
])

# Alertes.
noeud("alerte", "Quelle alerte ?", [
    fin("Sirène (son montant et descendant)", "la sirene sonne que faire", "alerte", "passages"),
    fin("Corne de brume près d'un barrage", "corne de brume barrage", "alerte", "passages"),
    fin("Message FR-Alert sur mon téléphone", "message fr alert recu", "alerte", "passages"),
    fin("On nous dit de rester à l'abri", "les pompiers disent au haut parleur de rester chez soi", "reflexes", "passages"),
    fin("Mes enfants sont à l'école", "alerte je vais chercher mes enfants a l ecole", "reflexes", "passages"),
    fin("Comment savoir que l'alerte est finie", "fin d alerte comment savoir", "alerte", "passages"),
])

# Événements.
noeud("evenement", "Que se passe-t-il ?", [
    fin("Inondation, l'eau monte", "l eau monte inondation que faire", "risques", "passages", "drop.fill"),
    fin("Tempête, orage, cyclone", "tempete orage que faire", "risques", "passages", "wind"),
    vers("Feu de forêt", "feu-foret", "flame.fill"),
    fin("Le feu dans mon logement", "il y a le feu dans mon appartement", "incendie-domicile", "urgenceSante", "house.fill"),
    vers("Séisme", "seisme", "waveform.path.ecg"),
    fin("Accident industriel, nuage toxique", "accident industriel nuage toxique que faire", "risques", "passages", "smoke.fill"),
    fin("Accident nucléaire", "accident nucleaire que faire", "risques", "passages", "atom"),
    fin("Attentat, coups de feu", "coups de feu attentat que faire", "risques", "passages", "exclamationmark.shield.fill"),
    vers("Coupure d'électricité", "coupure", "bolt.slash.fill"),
    fin("Odeur de gaz", "ca sent le gaz chez moi", "reflexes", "passages", "aqi.medium"),
    fin("Forte chaleur, canicule", "canicule il fait tres chaud que faire", "canicule", "passages", "sun.max.fill"),
    fin("Grand froid", "grand froid que faire", "grand-froid", "passages", "snowflake"),
])
noeud("feu-foret", "Où êtes-vous ?", [
    fin("Chez moi, le feu approche", "feu de foret pres de chez moi", "risques", "passages"),
    fin("En voiture", "en voiture face a un feu de foret", "risques", "passages"),
])
noeud("seisme", "La secousse est-elle terminée ?", [
    fin("Non, ça tremble encore", "la terre tremble que faire", "risques", "passages"),
    fin("Oui, le bâtiment est abîmé", "apres le seisme la maison est fissuree", "risques", "passages"),
    fin("Je suis près de la mer", "seisme pres de la plage", "risques", "passages"),
])
noeud("coupure", "Quelqu'un dépend-il d'un appareil médical électrique ?", [
    fin("Non", "coupure d electricite dans tout le quartier que faire", "coupure-electricite", "passages"),
    fin("Oui, et tout va bien pour l'instant", "coupure de courant et mon pere a un appareil medical il respire bien", "coupure-electricite", "passages"),
    fin("Oui, et il respire mal", "le courant a coupe sa machine a oxygene et il arrive plus a respirer", "numeros", "urgenceSante"),
])

# Préparation.
noeud("preparer", "Que voulez-vous préparer ?", [
    fin("Mon kit d'urgence 72 heures", "que mettre dans le kit d urgence 72 heures", "kit72h", "passages", "bag.fill"),
    fin("Mon sac d'évacuation", "que mettre dans le sac d evacuation", "sac-evacuation", "passages", "backpack.fill"),
    fin("Des stocks pour 2 semaines", "stock d eau pour deux semaines a la maison", "stocks", "passages", "shippingbox.fill"),
    fin("Mon plan familial", "comment preparer la coupure du gaz de l eau et de l electricite avant une crise", "pfms", "passages", "person.3.fill"),
    fin("Mes papiers et de l'argent liquide", "sauvegarder mes papiers et prouver mes biens", "documents", "passages", "doc.fill"),
    fin("Ma trousse de secours", "que mettre dans la trousse de premiers secours", "trousses", "passages", "cross.case.fill"),
    fin("Ma voiture", "que garder dans le coffre de la voiture pour etre pret a partir", "vehicule", "passages", "car.fill"),
    fin("Connaître les risques de ma commune", "comment savoir quels risques majeurs existent dans ma commune", "pfms", "passages", "map.fill"),
    fin("Apprendre les gestes qui sauvent", "ou apprendre les gestes de premiers secours", "engagement", "passages", "heart.fill"),
])

# Après la crise.
noeud("apres", "De quoi avez-vous besoin ?", [
    fin("Rentrer chez moi", "apres l inondation peut on rentrer chez moi", "retour", "passages", "house.fill"),
    fin("L'assurance, la catastrophe naturelle", "declarer catastrophe naturelle assurance delai", "assurance", "passages", "doc.text.fill"),
    fin("Je n'ai pas le moral", "stress apres la crise prendre soin du moral", "moral", "passages", "heart.fill"),
    fin("Un enfant fait des cauchemars", "mon enfant fait des cauchemars depuis l evacuation", "moral", "passages", "moon.fill"),
    fin("J'ai des idées noires", "j ai des idees noires", "moral", "urgencePersonnelle", "phone.fill"),
])

# Cyber.
noeud("cyber", "Que se passe-t-il ?", [
    fin("Mon appareil est bloqué, on me demande une rançon", "mon ordinateur bloque demande une rancon", "cyberattaque", "passages"),
    fin("Un de mes comptes est piraté", "mon compte mail a ete pirate", "cyberattaque", "passages"),
    fin("J'ai donné ma carte bancaire sur un faux site", "j ai donne ma carte bancaire sur un faux site", "cyberattaque", "passages"),
    fin("J'ai reçu un message suspect", "j ai recu un mail de ma banque qui demande mon code", "cyberattaque", "passages"),
    fin("Une information me paraît fausse", "comment verifier une information avant de la partager", "desinformation", "passages"),
])

# Nature.
noeud("nature", "Que se passe-t-il ?", [
    fin("Je suis perdu", "perdu en foret je retrouve plus le chemin", "orientation", "passages", "location.fill"),
    fin("Je veux me signaler aux secours", "comment me signaler aux secours helicoptere", "signaux", "passages", "light.beacon.max.fill"),
    fin("Trouver de l'eau, la rendre potable", "rendre l eau de riviere potable dans la nature", "eau", "passages", "drop.fill"),
    fin("Faire du feu pour survivre", "allumer un feu en situation de survie reelle", "feu", "passages", "flame.fill"),
    fin("Construire un abri", "construire un abri de fortune dans la nature", "abri", "passages", "tent.fill"),
    fin("J'ai très froid, je grelotte", "je suis trempe je grelotte j arrive plus a marcher", "numeros", "urgencePersonnelle", "thermometer.snowflake"),
])

# Espace mairie.
noeud("mairie", "De quoi avez-vous besoin ?", [
    fin("Faut-il activer le poste de commandement ?", "maire quand dois activer le poste de commandement communal", "pilotage", "passages"),
    fin("Répartir les rôles", "maire quels roles repartir dans le poste de commandement communal", "cellule-crise", "passages"),
    fin("Mener un point de situation", "nos points de situation au pcc durent trop longtemps", "pilotage", "passages"),
    fin("Communiquer avec les habitants", "notre mairie quelle trame pour le message aux habitants", "com-crise", "passages"),
    fin("La mairie subit une cyberattaque", "les serveurs de la mairie sont chiffres que faire cnil", "cyberattaque-commune", "passages"),
    fin("Organiser un exercice", "comment preparer un exercice de crise pour les agents de la commune", "exercice-retex", "passages"),
])

for n in noeuds.values():
    for o in n["options"]:
        if o.get("suivant"):
            assert o["suivant"] in noeuds, o
        o_clean = {k: v for k, v in o.items() if v is not None}
        o.clear(); o.update(o_clean)
parcours = {"version": "1", "date": "2026-11-27", "racine": "racine", "noeuds": list(noeuds.values())}
texte = json.dumps(parcours, ensure_ascii=False, indent=1)
assert "\u2014" not in texte and "\u2013" not in texte
CIBLE.write_text(texte + "\n", encoding="utf-8")
fins = sum(1 for n in noeuds.values() for o in n["options"] if "question" in o)
print(f"{len(noeuds)} questions, {fins} fins de parcours dans {CIBLE.relative_to(RACINE)}")
