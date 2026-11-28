#!/bin/bash
# Extrait la carte de la Loire-Atlantique (fond Protomaps tiré d'OpenStreetMap) pour l'application.
# À lancer sur le Mac, depuis n'importe quel dossier : bash outils/extraire_carte.sh
set -e
cd "$(dirname "$0")/.."
DEST=app/Sijamais/Resources/Cartes/loire-atlantique.pmtiles
BBOX="-2.56,46.86,-0.92,47.84"   # ouest, sud, est, nord du département

if ! command -v pmtiles >/dev/null; then
  echo "L'outil pmtiles manque. Installez-le avec : brew install pmtiles"
  exit 1
fi

BUILD=""
for i in 0 1 2 3 4 5 6 7 8; do
  J=$(date -v-${i}d +%Y%m%d 2>/dev/null || date -d "-$i day" +%Y%m%d)
  if curl -sfI "https://build.protomaps.com/$J.pmtiles" >/dev/null; then BUILD=$J; break; fi
done
if [ -z "$BUILD" ]; then
  echo "Aucune carte récente trouvée sur build.protomaps.com."
  exit 1
fi

echo "Carte Protomaps du $BUILD : extraction de la Loire-Atlantique..."
pmtiles extract "https://build.protomaps.com/$BUILD.pmtiles" "$DEST" --bbox="$BBOX" --maxzoom=15
ls -lh "$DEST"
echo "Terminé. Relancez l'application dans Xcode (Cmd + R)."
