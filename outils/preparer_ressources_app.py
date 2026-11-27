#!/usr/bin/env python3
"""Copie les contenus dans l'application iPhone : guides, schémas (catalogue d'images), icône.

Usage : python3 outils/preparer_ressources_app.py
(l'icône PNG est produite par : node outils/icone_app.js)
"""
import json
import shutil
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
RES = RACINE / "app" / "Sijamais" / "Resources"
ASSETS = RES / "Assets.xcassets"

RES.mkdir(parents=True, exist_ok=True)
shutil.copy(RACINE / "contenus" / "guides" / "guides_v1.2.json", RES / "guides.json")
shutil.copy(RACINE / "contenus" / "guides" / "guides_v1.2.json", RACINE / "app" / "SijamaisKit" / "Tests" / "SijamaisCoreTests" / "Fixtures" / "guides.json")
# Parcours guidé et liste d'équipement : embarqués dans le cœur (SijamaisCore), inclus à chaque compilation
# sans avoir à relancer XcodeGen (vidéo de Benjamin du 27/11/2026 : bouton sans effet faute de fichier).
CORE = RACINE / "app" / "SijamaisKit" / "Sources" / "SijamaisCore" / "Ressources"
CORE.mkdir(parents=True, exist_ok=True)
shutil.copy(RACINE / "contenus" / "assistant" / "parcours_v1.json", CORE / "parcours.json")
shutil.copy(RACINE / "contenus" / "equipement" / "catalogue_v1.json", CORE / "catalogue.json")
shutil.copy(RACINE / "contenus" / "enfants" / "parcours_v0.1.json", CORE / "enfants.json")
shutil.copy(RACINE / "contenus" / "legal" / "conditions_utilisation.md", CORE / "conditions_utilisation.md")
shutil.copy(RACINE / "contenus" / "legal" / "politique_confidentialite.md", CORE / "politique_confidentialite.md")
shutil.copy(RACINE / "contenus" / "assistant" / "parcours_v1.json", RACINE / "app" / "SijamaisKit" / "Tests" / "SijamaisCoreTests" / "Fixtures" / "parcours.json")
shutil.copy(RACINE / "contenus" / "equipement" / "catalogue_v1.json", RACINE / "app" / "SijamaisKit" / "Tests" / "SijamaisCoreTests" / "Fixtures" / "catalogue.json")

INFO = {"author": "xcode", "version": 1}


def ecrire(chemin: Path, contenu: dict) -> None:
    chemin.mkdir(parents=True, exist_ok=True)
    (chemin / "Contents.json").write_text(json.dumps(contenu, indent=2) + "\n", encoding="utf-8")


ecrire(ASSETS, {"info": INFO})
ecrire(ASSETS / "AccentColor.colorset", {
    "colors": [{"idiom": "universal", "color": {"color-space": "srgb", "components": {"red": "0xE0", "green": "0x66", "blue": "0x2A", "alpha": "1.000"}}}],
    "info": INFO,
})
icone = ASSETS / "AppIcon.appiconset"
ecrire(icone, {"images": [{"filename": "icone-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"}], "info": INFO})
source_icone = RACINE / "app" / "design" / "icone-1024.png"
if source_icone.exists():
    shutil.copy(source_icone, icone / "icone-1024.png")

# Logo (le même dessin que l'icône), en vectoriel, pour l'en-tête de l'accueil.
logo = ASSETS / "Logo.imageset"
ecrire(logo, {"images": [{"filename": "logo.svg", "idiom": "universal"}], "info": INFO,
              "properties": {"preserves-vector-representation": True, "template-rendering-intent": "original"}})
shutil.copy(RACINE / "app" / "design" / "icone.svg", logo / "logo.svg")

# Schémas : un jeu d'images par SVG, en conservant le vectoriel (net à toutes les tailles).
dossier_schemas = ASSETS / "Schemas"
ecrire(dossier_schemas, {"info": INFO, "properties": {"provides-namespace": False}})
n = 0
for svg in sorted((RACINE / "contenus" / "guides" / "schemas").glob("schema-*.svg")):
    jeu = dossier_schemas / f"{svg.stem}.imageset"
    ecrire(jeu, {
        "images": [{"filename": svg.name, "idiom": "universal"}],
        "info": INFO,
        "properties": {"preserves-vector-representation": True, "template-rendering-intent": "original"},
    })
    shutil.copy(svg, jeu / svg.name)
    n += 1
print(f"guides.json copié, {n} schémas, icône : {'oui' if source_icone.exists() else 'absente'}")
