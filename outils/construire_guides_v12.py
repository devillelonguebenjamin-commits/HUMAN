"""Construit contenus/guides/guides_v1.2.json à partir de guides_v1.1.json.

Arbitrages validés par Benjamin le 27/11/2026 (« OK sur tout », contenus/assistant/arbitrages_cycles_1_a_6.md) :
  2. Stocks : réchaud, poêle à pétrole et appareils à combustion alignés sur l'interdiction du guide Monoxyde.
  3. Cueillette : guide de prudence ; les fiches plantain, ortie, massette sont mises de côté (contenus/guides/retires_v1.2.json).
  4. Eau : la méthode à l'eau de Javel est retirée ; ébullition, filtre et pastilles seulement.
  6. Numéro vert du signal d'alerte (0 800 50 73 05) retiré : introuvable sur les pages officielles consultées.
Sources vérifiées le 27/11/2026 sur service-public.gouv.fr :
  - 196 (sauvetage en mer) et 0 800 112 112 (rappel par les secours) : page F33954, vérifiée le 25 août 2026 ;
  - délais d'indemnisation, franchise et hébergement : page F3078, vérifiée le 10 avril 2026.
Usage : python3 outils/construire_guides_v12.py
"""
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
SOURCE = RACINE / "contenus" / "guides" / "guides_v1.1.json"
CIBLE = RACINE / "contenus" / "guides" / "guides_v1.2.json"
RETIRES = RACINE / "contenus" / "guides" / "retires_v1.2.json"
DATE = "2026-11-27"

d = json.loads(SOURCE.read_text(encoding="utf-8"))
g = {x["id"]: x for x in d["guides"]}
src = d["meta"]["sources"]
modifies = set()
retires = {"date": DATE, "raison": "Arbitrages du 27/11/2026 : contenus mis de côté en attendant une validation (botaniste ou pharmacien, source nationale).", "blocs": {}}


def bloc(gid, cond):
    for b in g[gid]["blocs"]:
        if cond(b):
            return b
    raise KeyError(gid)


def remplacer(gid, ancien, nouveau):
    s = json.dumps(g[gid]["blocs"], ensure_ascii=False)
    assert s.count(ancien) == 1, (gid, ancien)
    g[gid]["blocs"] = json.loads(s.replace(ancien, nouveau))
    modifies.add(gid)


# Sources nouvelles ou mises à jour.
src["S26"] = {"titre": "Quels sont les numéros en cas d'urgence (Samu, pompiers...) et les numéros d'écoute ?", "editeur": "Service-public.gouv.fr (DILA, Premier ministre)",
              "date": "vérifiée le 2026-08-25, consultée le 2026-11-27", "url": "https://www.service-public.gouv.fr/particuliers/vosdroits/F33954", "type": "officiel", "reutilisation": "Information publique"}
src["S15"]["date"] = "vérifiée le 2026-04-10, consultée le 2026-11-27"

# 2. Stocks : aucune flamme de chauffage ou de cuisson à l'intérieur.
remplacer("stocks", "Réchaud, bougies, poêle à pétrole : aérez toujours la pièce. Un appareil à flamme en espace clos est dangereux.",
          "Jamais de réchaud, de barbecue, de groupe électrogène, de poêle à pétrole ni de chauffage d'appoint à combustion dans un local fermé, même garage ou cave : risque mortel de monoxyde de carbone.")
remplacer("stocks", "Réchaud de camping et cartouches de gaz compatibles", "Réchaud de camping et cartouches de gaz compatibles (à utiliser dehors uniquement)")
if "S20" not in g["stocks"]["sources"]:
    g["stocks"]["sources"].append("S20")

# 3. Cueillette : guide de prudence.
c = g["cueillette"]
retires["blocs"]["cueillette"] = [b for b in c["blocs"] if b["t"] in ("plant", "list")]
c["titre"] = "Cueillette : prudence"
c["resume"] = "Pourquoi ne pas compter sur les plantes sauvages."
c["blocs"] = [
    bloc("cueillette", lambda b: b["t"] == "alert"),
    {"t": "text", "body": "En situation de crise, ne comptez pas sur la cueillette pour vous nourrir : la flore compte des espèces mortelles et les confusions sont fréquentes, même pour des plantes courantes. Appuyez-vous sur vos réserves (voir « Stocks à la maison » et « Se nourrir sur la durée »)."},
    {"t": "alert", "body": "Si quelqu'un a mangé une plante, des baies ou un champignon inconnus et se sent mal : appelez le 15 ou le 112."},
    {"t": "tip", "body": "SIJAMAIS ne donne aucune fiche d'identification de plantes ou de champignons : seul un spécialiste ou un pharmacien peut confirmer une espèce."},
]
c["a_verifier"] = []
modifies.add("cueillette")

# 4. Eau : sans eau de Javel.
e = g["eau"]
retires["blocs"]["eau"] = [b for b in e["blocs"] if b.get("titre", "").startswith("Désinfecter à l'eau de Javel")]
e["blocs"] = [b for b in e["blocs"] if not b.get("titre", "").startswith("Désinfecter à l'eau de Javel")]
remplacer("eau", "Finir par une paille filtrante, une pastille de purification ou quelques gouttes de javel.",
          "Finir par une paille filtrante ou une pastille de purification, en suivant sa notice.")
remplacer("eau", "puis la désinfecter et attendre 30 minutes avant de boire.", "puis la désinfecter avec une pastille de purification, en attendant le temps indiqué sur sa notice.")
e["blocs"].insert(len(e["blocs"]) - 1, {"t": "alert", "body": "La désinfection à l'eau de Javel n'est pas reprise ici : les concentrations varient d'un produit à l'autre et une erreur de dosage est dangereuse. Préférez l'ébullition et les pastilles de purification."})
e["sources"] = [s for s in e["sources"] if s != "S18"]
e["a_verifier"] = []

# 6. Numéros : retrait du numéro vert non vérifié ; 196 et 0 800 112 112 vérifiés.
n = g["numeros"]
kv = bloc("numeros", lambda b: b["t"] == "kv")
kv["items"] = [i for i in kv["items"] if i[0] != "0 800 50 73 05"]
kv["items"].insert(0, ["0 800 112 112", "Numéro par lequel les services d'urgence vous rappellent : décrochez en confiance, l'appel est gratuit"])
nums = bloc("numeros", lambda b: b["t"] == "numbers")["items"]
for x in nums:
    if x["n"] == "196":
        x["desc"] = "Depuis le littoral : appelez le 196 ou le 112. En mer, privilégiez le canal 16 de la radio VHF."
n["sources"] = n["sources"] + ["S26"]
n["a_verifier"] = []
modifies.add("numeros")

# 5. Assurance : délais, franchise et hébergement (page F3078).
remplacer("assurance", "vous avez 30 jours pour déclarer vos dommages (règle en vigueur depuis le 1er janvier 2023).", "vous avez 30 jours au plus tard pour déclarer vos dommages.")
remplacer("assurance", "Les délais de versement de l'indemnité sont fixés par le code des assurances : consultez service-public.fr.",
          "L'assureur doit verser une provision dans les 2 mois suivant la remise de l'état estimatif des dommages ou la publication de l'arrêté, puis l'indemnisation complète dans un délai de 3 mois. Votre contrat peut prévoir mieux.")
g["assurance"]["blocs"].insert(2, {"t": "list", "titre": "Bon à savoir", "items": [
    "Une franchise légale s'applique : 380 € pour une habitation, 1 520 € si le dommage vient d'un mouvement de terrain lié à la sécheresse.",
    "Les frais d'hébergement temporaire peuvent être pris en charge si votre résidence principale devient inhabitable.",
]})

# Métadonnées.
for gid in modifies:
    g[gid]["version"] = "1.2"
    g[gid]["maj"] = DATE
    g[gid]["relecture"] = {"statut": "non relu", "nom": None, "qualite": None, "date": None}
d["meta"]["version"] = "1.2"
d["meta"]["date"] = DATE
d["meta"]["historique"] += " ; 1.2 du 2026-11-27 applique les arbitrages de contenus/assistant/arbitrages_cycles_1_a_6.md"

for x in d["guides"]:
    for s_ in x["sources"]:
        assert s_ in src, (x["id"], s_)
texte = json.dumps(d, ensure_ascii=False, indent=1)
assert "\u2014" not in texte and "\u2013" not in texte
CIBLE.write_text(texte + "\n", encoding="utf-8")
RETIRES.write_text(json.dumps(retires, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
print(f"{len(d['guides'])} guides écrits dans {CIBLE.relative_to(RACINE)} ; modifiés : {', '.join(sorted(modifies))}")
