"""Construit contenus/equipement/catalogue_v1.json : l'écran « S'équiper » de l'application.

Décision de Benjamin du 27/11/2026 : conseil neutre d'abord (où trouver chaque article sans Amazon),
puis, en option, un lien affilié Amazon clairement signalé. Règles :
  - chaque article renvoie à une ligne exacte d'un guide (vérifié ci-dessous) : rien n'est ajouté aux listes officielles ;
  - aucune marque : le lien ouvre une recherche Amazon, pas un produit ;
  - pas de lien pour les médicaments, le lait infantile, l'eau et la nourriture (pharmacie et commerce de proximité) ;
  - sans identifiant Amazon Partenaires (champ « tag » vide), l'application n'affiche aucun lien.
Usage : python3 outils/construire_catalogue.py
"""
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
GUIDES = RACINE / "contenus" / "guides" / "guides_v1.2.json"
CIBLE = RACINE / "contenus" / "equipement" / "catalogue_v1.json"

PHARMA, QUINC, SUPER, SPORT, ELEC, PRESSE, ANIM, AUTO, MERCERIE = (
    "pharmacie", "quincaillerie ou magasin de bricolage", "supermarché", "magasin de sport ou de camping",
    "magasin d'électronique", "bureau de tabac ou maison de la presse", "animalerie", "centre auto", "supermarché (rayon bureau)")

# (guide, liste, texte exact de la ligne du guide, où le trouver, recherche Amazon ou None, conseil tiré des guides ou None)
ARTICLES = [
    # Kit 72 h : la base recommandée par l'État.
    ("kit72h", "kit-base", "Radio à piles et piles de rechange", [ELEC, SUPER, QUINC], "radio à piles", None),
    ("kit72h", "kit-base", "Lampe de poche et piles de rechange", [QUINC, SUPER], "lampe de poche", None),
    ("kit72h", "kit-base", "Bougies, briquet ou allumettes", [SUPER, PRESSE], "allumettes étanches", None),
    ("kit72h", "kit-base", "Chargeur de téléphone et batterie externe", [ELEC, SUPER], "batterie externe", None),
    ("kit72h", "kit-base", "Couteau multifonction", [QUINC, SPORT], "couteau multifonction", "La loi encadre le port d'un couteau."),
    ("kit72h", "kit-base", "Ouvre-boîte", [SUPER, QUINC], "ouvre-boîte manuel", None),
    ("kit72h", "kit-base", "Réchaud", [SPORT, QUINC], "réchaud de camping", "À utiliser dehors uniquement : risque mortel de monoxyde de carbone dans un local fermé."),
    ("kit72h", "kit-eau", "Eau potable : 6 L par personne", [SUPER], None, None),
    ("kit72h", "kit-eau", "Conserves ne nécessitant pas de cuisson", [SUPER], None, None),
    ("kit72h", "kit-eau", "Petits pots ou lait infantile 1er âge liquide prêt à l'emploi", [PHARMA, SUPER], None, None),
    ("kit72h", "kit-eau", "Nourriture pour animaux", [ANIM, SUPER], None, None),
    ("kit72h", "kit-eau", "Pastilles de décontamination de l'eau (dernier recours)", [PHARMA, SPORT], "pastilles purification eau", "Suivez la notice."),
    ("kit72h", "kit-chaud", "Couverture de survie", [PHARMA, SPORT], "couverture de survie", None),
    ("kit72h", "kit-sante", "Médicaments du quotidien et de secours", [PHARMA], None, "Demandez conseil à votre pharmacien."),
    ("kit72h", "kit-sante", "Trousse de premiers secours (alcool, gel, masques, pansements, compresses)", [PHARMA], "trousse de premiers secours", "Demandez conseil à votre pharmacien pour l'adapter à votre foyer."),
    ("kit72h", "kit-docs", "Photocopies des papiers d'identité et ordonnances dans une pochette étanche", [MERCERIE, SPORT], "pochette étanche documents", None),
    # Sac d'évacuation.
    ("sac-evacuation", "sac-eau", "Gourde filtrante remplie", [SPORT], "gourde filtrante", None),
    ("sac-evacuation", "sac-eau", "Gourde souple 2 L", [SPORT], "gourde souple 2 litres", None),
    ("sac-evacuation", "sac-feu", "Lampe frontale", [SPORT, QUINC], "lampe frontale", None),
    ("sac-evacuation", "sac-feu", "Allumettes étanches", [SPORT], "allumettes étanches", None),
    ("sac-evacuation", "sac-energie", "Radio solaire ou à dynamo", [ELEC, SPORT], "radio dynamo solaire", None),
    ("sac-evacuation", "sac-energie", "Panneau solaire portable", [ELEC, SPORT], "panneau solaire portable", None),
    ("sac-evacuation", "sac-energie", "Talkies-walkies", [ELEC, SPORT], "talkie walkie", None),
    ("sac-evacuation", "sac-outils", "Paracorde", [SPORT, QUINC], "paracorde", None),
    ("sac-evacuation", "sac-outils", "Ruban adhésif renforcé", [QUINC], "ruban adhésif renforcé", None),
    ("sac-evacuation", "sac-outils", "Sifflet", [SPORT], "sifflet de survie", None),
    ("sac-evacuation", "sac-vetements", "Poncho de pluie", [SPORT], "poncho de pluie", None),
    # Trousse familiale.
    ("trousses", "trousse-famille", "Pansements et sparadrap", [PHARMA, SUPER], None, None),
    ("trousses", "trousse-famille", "Pince à épiler et tire-tique", [PHARMA], "tire-tique", None),
    ("trousses", "trousse-famille", "Thermomètre", [PHARMA], None, None),
    # Stocks à la maison.
    ("stocks", "stock-energie", "Lampes torches et lanternes", [QUINC, SPORT], "lanterne LED", None),
    ("stocks", "stock-energie", "Piles rechargeables et chargeur", [ELEC, SUPER], "piles rechargeables chargeur", None),
    ("stocks", "stock-energie", "Radio à manivelle ou solaire", [ELEC, SPORT], "radio à manivelle", None),
    ("stocks", "stock-hygiene", "Gants nitrile", [PHARMA, QUINC], "gants nitrile", None),
    ("stocks", "stock-hygiene", "Masques FFP2", [PHARMA], None, None),
    ("stocks", "stock-hygiene", "Bâches transparentes et ruban adhésif", [QUINC], "bâche transparente", None),
    # Véhicule.
    ("vehicule", "auto-coffre", "Marteau brise-vitre avec coupe-ceinture", [AUTO], "marteau brise-vitre coupe-ceinture", None),
    ("vehicule", "auto-coffre", "Gilets et triangle de signalisation", [AUTO, SUPER], "gilet triangle signalisation", None),
    ("vehicule", "auto-coffre", "Extincteur", [AUTO, QUINC], "extincteur voiture", None),
]

SECTIONS = {
    "kit72h": ("Kit d'urgence 72 heures", "La base recommandée par l'État, pour tenir 3 jours chez soi."),
    "sac-evacuation": ("Sac d'évacuation", "Ce qui s'ajoute pour partir vite et marcher longtemps."),
    "trousses": ("Trousse de premiers secours", "À adapter à votre foyer avec votre pharmacien."),
    "stocks": ("Stocks à la maison", "Pour aller au-delà de 3 jours."),
    "vehicule": ("Véhicule", "Dans le coffre."),
}

d = json.loads(GUIDES.read_text(encoding="utf-8"))
listes = {}
for g in d["guides"]:
    for b in g["blocs"]:
        if b["t"] == "check":
            listes[(g["id"], b["id"])] = b["items"]

sections = []
for gid, (titre, intro) in SECTIONS.items():
    arts = []
    for (ag, liste, texte, ou, recherche, conseil) in ARTICLES:
        if ag != gid:
            continue
        items = listes[(ag, liste)]
        assert texte in items, (ag, liste, texte)
        arts.append({"id": f"{liste}-{items.index(texte)}", "guide": ag, "liste": liste, "index": items.index(texte), "nom": texte,
                     "ouTrouver": ou, "rechercheAmazon": recherche, "conseil": conseil})
    sections.append({"id": gid, "titre": titre, "intro": intro, "articles": arts})

catalogue = {
    "version": "1",
    "date": "2026-11-27",
    "introduction": "Tout ce qui figure ici vient des listes des guides. Chaque article se trouve dans des commerces ordinaires : commencez par ceux de votre commune. Si vous n'en avez pas près de chez vous, un lien vers Amazon est proposé.",
    "partenaireAmazon": {
        "tag": "",
        "domaine": "www.amazon.fr",
        "mention": "En tant que Partenaire Amazon, SIJAMAIS réalise un bénéfice sur les achats remplissant les conditions requises. Cela ne change pas le prix pour vous.",
    },
    "sections": sections,
}
texte = json.dumps(catalogue, ensure_ascii=False, indent=1)
assert "\u2014" not in texte and "\u2013" not in texte
CIBLE.parent.mkdir(parents=True, exist_ok=True)
CIBLE.write_text(texte + "\n", encoding="utf-8")
n = sum(len(s["articles"]) for s in sections)
print(f"{n} articles dans {CIBLE.relative_to(RACINE)}, dont {sum(1 for s in sections for a in s['articles'] if a['rechercheAmazon'])} avec lien possible")
