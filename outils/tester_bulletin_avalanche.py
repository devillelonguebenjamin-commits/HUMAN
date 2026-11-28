#!/usr/bin/env python3
"""Teste la clé de l'API Météo-France des bulletins avalanche, sur le Mac (28/11/2026).

    read -s METEO_FRANCE_CLE && export METEO_FRANCE_CLE
    python3 outils/tester_bulletin_avalanche.py 8        # numéro du massif (8 = Belledonne)

La clé est lue dans la variable d'environnement METEO_FRANCE_CLE, jamais écrite dans un fichier.
Écrit le bulletin dans essais/BRA-<id>.xml (dossier ignoré par git). Bibliothèque standard uniquement.
"""
from __future__ import annotations

import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

API = "https://public-api.meteofrance.fr/public/DPBRA/v1"
LIBELLES = {1: "faible", 2: "limité", 3: "marqué", 4: "fort", 5: "très fort"}


def main() -> int:
    cle = os.environ.get("METEO_FRANCE_CLE", "").strip()
    if not cle:
        print("Clé absente : lancer d'abord  read -s METEO_FRANCE_CLE && export METEO_FRANCE_CLE")
        return 1
    massif = sys.argv[1] if len(sys.argv) > 1 else "8"
    for chemin in (f"/massif/BRA?id-massif={massif}&format=xml", "/liste-massifs"):
        req = urllib.request.Request(API + chemin, headers={"apikey": cle, "User-Agent": "SIJAMAIS-essai"})
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                corps = r.read().decode("utf-8", "replace")
            print(f"OK {chemin} ({len(corps)} caractères)")
        except urllib.error.HTTPError as e:
            print(f"Échec {chemin} : code {e.code}. {'Clé refusée ou API non souscrite.' if e.code in (401, 403) else 'Adresse à corriger.' if e.code == 404 else ''}")
            continue
        if "<BULLETINS_NEIGE_AVALANCHE" in corps:
            m = re.search(r'MASSIF="([^"]+)"', corps)
            r = re.search(r'RISQUEMAXI="(\d)"', corps)
            v = re.search(r'DATEVALIDITE="([^"]+)"', corps)
            n = int(r.group(1)) if r else 0
            print(f"  {m.group(1) if m else '?'} : risque {n} ({LIBELLES.get(n, '?')}), valable jusqu'au {v.group(1) if v else '?'}")
            sortie = Path(__file__).resolve().parent.parent / "essais" / f"BRA-{massif}.xml"
            sortie.parent.mkdir(exist_ok=True)
            sortie.write_text(corps, encoding="utf-8")
            print(f"  écrit dans {sortie}")
        else:
            print("  " + corps[:300].replace("\n", " "))
    return 0


if __name__ == "__main__":
    sys.exit(main())
