"""Construit contenus/famille/plan_familial_v1.json : le parcours pas à pas du plan familial (onglet Famille).

Demande de Benjamin du 27/11/2026 : un système de questions interactives pour la partie Famille,
équivalent au parcours guidé de l'assistant. Chaque réponse remplit un champ du guide « Mon plan familial
de mise en sûreté » (clé « pfms.<formulaire>.<rang> », la même que dans le guide). Les consignes proposées
pour chaque risque sont recopiées mot pour mot du guide « Que faire selon le risque » (vérifié ici).
Usage : python3 outils/construire_famille.py
"""
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
GUIDES = RACINE / "contenus" / "guides" / "guides_v1.2.json"
CIBLE = RACINE / "contenus" / "famille" / "plan_familial_v1.json"
CORE = RACINE / "app" / "SijamaisKit" / "Sources" / "SijamaisCore" / "Ressources" / "plan_familial.json"

d = json.loads(GUIDES.read_text(encoding="utf-8"))
g = {x["id"]: x for x in d["guides"]}
formulaires = {b["id"]: b["fields"] for b in g["pfms"]["blocs"] if b["t"] == "form"}
risques = {b["titre"]: b["items"] for b in g["risques"]["blocs"] if b["t"] == "risk"}


def cle(form, champ):
    assert champ in formulaires[form], (form, champ)
    return f"pfms.{form}.{formulaires[form].index(champ)}"


def consigne(risque, contenant):
    l = [i for i in risques[risque] if contenant in i]
    assert len(l) == 1, (risque, contenant)
    return l[0]


def choix(libelle, valeur=None, defaut=False):
    c = {"libelle": libelle}
    if valeur is not None:
        c["valeur"] = valeur
    if defaut:
        c["parDefaut"] = True
    return c


RISQUES = [
    ("Tempête, orage", "Tempête, orage, cyclone", "bâtiment en dur", True),
    ("Transport de matières dangereuses", "Transport de matières dangereuses", "abritez-vous", True),
    ("Inondation", "Inondation", "Ne prenez pas votre voiture", False),
    ("Feu de forêt", "Feu de forêt", "Quittez le massif", False),
    ("Séisme", "Séisme", "Pendant", False),
    ("Accident industriel", "Accident industriel", "bâtiment clos le plus proche", False),
    ("Accident nucléaire", "Accident nucléaire", "instruction du préfet", False),
    ("Rupture de barrage", "Rupture de barrage", "corne de brume", False),
    ("Mouvement de terrain, avalanche", "Mouvement de terrain, avalanche", "fortes pentes", False),
    ("Tsunami", "Tsunami", "point haut", False),
]

etapes = [
    {"id": "commune", "titre": "Ma commune", "type": "texte",
     "question": "Dans quelle commune habitez-vous ?",
     "aide": "Votre mairie publie le DICRIM, qui liste les risques de la commune. Le site georisques.gouv.fr les donne aussi.",
     "champ": cle("pfms-risques", "Commune"), "exemple": "La Baule-Escoublac"},
    {"id": "risques", "titre": "Mes risques", "type": "risques",
     "question": "Quels risques concernent votre commune ?",
     "aide": "Partout en France, chacun est exposé au minimum aux tempêtes et aux accidents de transport de matières dangereuses : ils sont déjà cochés. Gardez les 4 plus importants pour vous ; la consigne du guide s'ajoute à chacun.",
     "champs": [cle("pfms-risques", f"Risque {i} et comportement") for i in range(1, 5)], "max": 4,
     "choix": [choix(lib, f"{lib} : {consigne(titre, mot)}", defaut) for lib, titre, mot, defaut in RISQUES]},
    {"id": "electricite", "titre": "Couper l'électricité", "type": "choix",
     "question": "Où se trouve votre tableau électrique ?",
     "aide": "Pour couper : basculer le disjoncteur général sur O. Montrez-le à chaque membre du foyer.",
     "champ": cle("pfms-reseaux", "Électricité : où et comment"), "gabarit": "{choix} : basculer le disjoncteur général sur O",
     "choix": [choix("Dans l'entrée"), choix("Dans le garage"), choix("Dans la cave"), choix("Dans un placard"), choix("Ailleurs")]},
    {"id": "gaz", "titre": "Couper le gaz", "type": "choix",
     "question": "Où se trouve la vanne de gaz ?",
     "aide": "Pour couper : fermer la vanne d'un quart de tour.",
     "champ": cle("pfms-reseaux", "Gaz : où et comment"), "gabarit": "{choix} : fermer la vanne d'un quart de tour",
     "choix": [choix("Pas de gaz chez moi", "Pas de gaz"), choix("Près du compteur, dehors"), choix("Dans la cuisine"), choix("Dans la cave"), choix("Ailleurs")]},
    {"id": "eau", "titre": "Couper l'eau", "type": "choix",
     "question": "Où se trouve le robinet d'arrivée d'eau ?",
     "aide": "Pour couper : tourner le robinet d'arrivée d'eau. En cas d'inondation ou de séisme, coupez aussi l'eau.",
     "champ": cle("pfms-reseaux", "Eau : où et comment"), "gabarit": "{choix} : tourner le robinet d'arrivée d'eau",
     "choix": [choix("Près du compteur d'eau"), choix("Sous l'évier"), choix("Dans la cave"), choix("Dans un placard"), choix("Ailleurs")]},
    {"id": "abri", "titre": "Me mettre à l'abri", "type": "choix",
     "question": "Où vous mettrez-vous à l'abri dans le logement ?",
     "aide": "Air pollué (accident industriel, nucléaire) : une pièce avec le moins d'ouvertures possible, proche des sanitaires. Inondation : un espace en hauteur (étage, mezzanine).",
     "champ": cle("pfms-lieux", "Lieu de mise à l'abri dans le logement"),
     "choix": [choix("La salle de bain"), choix("Une chambre avec peu de fenêtres"), choix("À l'étage"), choix("Ailleurs")]},
    {"id": "evacuation", "titre": "Évacuer", "type": "texte",
     "question": "Où aller si on doit évacuer ?",
     "aide": "La mairie fixe à l'avance les lieux d'évacuation (gymnase, point haut de la commune). Demandez-les, et testez l'itinéraire en famille.",
     "champ": cle("pfms-lieux", "Lieu d'évacuation et de regroupement"), "exemple": "Gymnase municipal, rue ..."},
    {"id": "point-contact", "titre": "Point familial de contact", "type": "texte",
     "question": "Qui appeler si la famille est séparée ?",
     "aide": "Choisissez un ami ou un proche habitant une autre localité. Si la famille est séparée, chacun l'appelle pour donner de ses nouvelles.",
     "champ": cle("pfms-contacts", "Point familial de contact (proche vivant ailleurs, à joindre si nous sommes séparés)"), "exemple": "Tante Marie, 06 ..."},
    {"id": "mairie", "titre": "Contacts", "type": "texte",
     "question": "Le téléphone de votre mairie ?",
     "champ": cle("pfms-contacts", "Mairie"), "exemple": "02 ..."},
    {"id": "medecin", "titre": "Contacts", "type": "texte",
     "question": "Votre médecin de famille ?",
     "champ": cle("pfms-contacts", "Médecin de famille"), "exemple": "Dr ..., 02 ..."},
    {"id": "ecole", "titre": "Contacts", "type": "texte",
     "question": "L'école de vos enfants ?",
     "aide": "En cas d'alerte, n'allez pas chercher vos enfants à l'école : les équipes pédagogiques s'en occupent. Notez quand même son téléphone.",
     "champ": cle("pfms-contacts", "École(s) des enfants"), "exemple": "École ..., 02 ..."},
    {"id": "assurance", "titre": "Contacts", "type": "texte",
     "question": "Votre assurance habitation ?",
     "champ": cle("pfms-contacts", "Assurance (nom, téléphone, n° de contrat)"), "exemple": "Nom, téléphone, n° de contrat"},
]

for e in etapes:
    e.setdefault("choix", [])
plan = {"version": "1", "date": "2026-11-27", "guide": "pfms", "etapes": etapes}
texte = json.dumps(plan, ensure_ascii=False, indent=1)
assert "\u2014" not in texte and "\u2013" not in texte
for chemin in (CIBLE, CORE):
    chemin.parent.mkdir(parents=True, exist_ok=True)
    chemin.write_text(texte + "\n", encoding="utf-8")
print(f"{len(etapes)} étapes dans {CIBLE.relative_to(RACINE)} (et copie dans SijamaisCore)")
