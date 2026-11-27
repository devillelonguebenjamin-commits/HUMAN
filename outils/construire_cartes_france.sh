#!/bin/bash
# Fabrique les cartes hors ligne de toute la France (fond Protomaps tiré d'OpenStreetMap, licence ODbL).
# À lancer sur le Mac (l'outil pmtiles s'installe avec : brew install pmtiles).
#
#   bash outils/construire_cartes_france.sh --mesurer      # tailles estimées, sans rien télécharger
#   bash outils/construire_cartes_france.sh                # vue d'ensemble + 101 départements + catalogue
#   bash outils/construire_cartes_france.sh 44 29 2A       # seulement ces départements
#
# Résultat :
#   app/Sijamais/Resources/Cartes/france-vue-ensemble.pmtiles  (embarquée dans l'application, zoom 0 à 8)
#   cartes_france/<code>.pmtiles et cartes_france/catalogue.json (à déposer chez l'hébergeur, voir contenus/cartes/README.md)
set -e
cd "$(dirname "$0")/.."
command -v pmtiles >/dev/null || { echo "L'outil pmtiles manque : brew install pmtiles"; exit 1; }

MESURER=""
if [ "$1" = "--mesurer" ]; then MESURER="--dry-run"; shift; fi

BUILD=""
for i in 0 1 2 3 4 5 6 7 8; do
  J=$(date -v-${i}d +%Y%m%d 2>/dev/null || date -d "-$i day" +%Y%m%d)
  if curl -sfI "https://build.protomaps.com/$J.pmtiles" >/dev/null; then BUILD=$J; break; fi
done
[ -n "$BUILD" ] || { echo "Aucune carte récente trouvée sur build.protomaps.com."; exit 1; }
SRC="https://build.protomaps.com/$BUILD.pmtiles"
echo "Carte Protomaps du $BUILD"
mkdir -p cartes_france app/Sijamais/Resources/Cartes

# Vue d'ensemble de la métropole et de la Corse, pour voir toute la France même sans département téléchargé.
if [ $# -eq 0 ]; then
  CADRE=$(python3 -c "import json;print(','.join(map(str,json.load(open('contenus/cartes/departements.json'))['vueEnsemble']['cadre'])))")
  echo "Vue d'ensemble (zoom 0 à 8)..."
  pmtiles extract "$SRC" app/Sijamais/Resources/Cartes/france-vue-ensemble.pmtiles --bbox="$CADRE" --maxzoom=8 $MESURER
fi

# Les départements : tous, ou ceux passés en argument.
CODES="$*"
[ -n "$CODES" ] || CODES=$(python3 -c "import json;print(' '.join(d['code'] for d in json.load(open('contenus/cartes/departements.json'))['departements']))")
for C in $CODES; do
  CADRE=$(python3 -c "import json,sys;d=[x for x in json.load(open('contenus/cartes/departements.json'))['departements'] if x['code']=='$C'];print(','.join(map(str,d[0]['cadre'])) if d else '')")
  [ -n "$CADRE" ] || { echo "Département inconnu : $C"; continue; }
  echo "Département $C..."
  pmtiles extract "$SRC" "cartes_france/$C.pmtiles" --bbox="$CADRE" --maxzoom=15 $MESURER
done

[ -n "$MESURER" ] && { echo "Mesure terminée (rien n'a été téléchargé)."; exit 0; }

# Catalogue : taille, empreinte SHA-256 et date de chaque fichier, lu par l'application.
python3 - "$BUILD" <<'PY'
import hashlib, json, os, sys
build = sys.argv[1]
base = json.load(open("contenus/cartes/departements.json"))
fichiers = {}
for d in base["departements"]:
    f = f"cartes_france/{d['code']}.pmtiles"
    if os.path.exists(f):
        h = hashlib.sha256(open(f, "rb").read()).hexdigest()
        fichiers[d["code"]] = {"fichier": f"{d['code']}.pmtiles", "octets": os.path.getsize(f), "sha256": h}
json.dump({"version": build, "fichiers": fichiers}, open("cartes_france/catalogue.json", "w"), indent=1)
total = sum(x["octets"] for x in fichiers.values())
print(f"{len(fichiers)} départements, {total / 1e9:.2f} Go au total. Catalogue : cartes_france/catalogue.json")
PY
echo "Étape suivante : déposer le dossier cartes_france chez l'hébergeur (voir contenus/cartes/README.md)."
