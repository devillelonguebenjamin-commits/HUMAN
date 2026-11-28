#!/usr/bin/env python3
"""Points de la carte hors ligne pour toute la France, département par département (27/11/2026).

À lancer sur le Mac (accès internet), une fois par mois, après outils/construire_cartes_france.sh :

    python3 outils/construire_points_france.py              # les 101 départements
    python3 outils/construire_points_france.py 44 29 73     # seulement ces départements
    python3 outils/construire_points_france.py --sans-refuges

Écrit dans cartes_france/ (à déposer chez l'hébergeur avec les cartes) :
- <code>-secours.geojson : hôpitaux, pompiers, pharmacies, police, mairies (OpenStreetMap, ODbL),
  défibrillateurs (base nationale Géo'DAE, sinon OpenStreetMap). Gratuit dans l'application.
- <code>-refuges.geojson : refuges gardés, cabanes non gardées, gîtes d'étape, abris, points d'eau
  (Refuges.info, CC BY-SA 2.0, crédit obligatoire). Mode Randonnée.
et complète cartes_france/catalogue.json (taille et empreinte de chaque fichier).

Ménagement des serveurs bénévoles : une requête à la fois, avec une pause, et des reprises en cas de refus.
Les données sont ensuite servies par notre hébergement : l'application n'interroge jamais Overpass ni Refuges.info.
Bibliothèque standard de Python uniquement.
"""
from __future__ import annotations

import hashlib
import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
SORTIE = RACINE / "cartes_france"
AGENT = {"User-Agent": "SIJAMAIS-cartes-hors-ligne/1.0 (mise a jour mensuelle, une requete a la fois)"}
TYPES_OSM = {"hospital": "hopital", "fire_station": "pompiers", "pharmacy": "pharmacie", "police": "police", "townhall": "mairie"}
TYPES_REFUGES = {7: "cabane", 9: "gite", 10: "refuge", 23: "eau", 29: "abri"}


def lire(url: str, donnees: bytes | None = None, delai: int = 300, essais: int = 4) -> bytes:
    for i in range(essais):
        try:
            req = urllib.request.Request(url, data=donnees, headers=AGENT)
            with urllib.request.urlopen(req, timeout=delai) as r:
                return r.read()
        except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError) as e:
            if i == essais - 1:
                raise
            attente = 30 * (i + 1)
            print(f"    refus ou délai dépassé ({e}), nouvel essai dans {attente} s")
            time.sleep(attente)
    raise RuntimeError("inaccessible")


def dans(contours: list, lat: float, lon: float) -> bool:
    """Point dans l'un des contours (méthode du rayon)."""
    for anneau in contours:
        dedans = False
        j = len(anneau) - 1
        for i in range(len(anneau)):
            xi, yi = anneau[i]
            xj, yj = anneau[j]
            if (yi > lat) != (yj > lat) and lon < (xj - xi) * (lat - yi) / (yj - yi) + xi:
                dedans = not dedans
            j = i
        if dedans:
            return True
    return False


def point(lon: float, lat: float, proprietes: dict) -> dict:
    return {"type": "Feature", "geometry": {"type": "Point", "coordinates": [round(lon, 6), round(lat, 6)]}, "properties": proprietes}


def osm(d: dict) -> list[dict]:
    o, s, e, n = d["cadre"]
    requete = f"""
[out:json][timeout:300];
(
  nwr["amenity"~"^(hospital|fire_station|pharmacy|police|townhall)$"]({s},{o},{n},{e});
  node["emergency"="defibrillator"]({s},{o},{n},{e});
);
out center tags;
"""
    brut = lire("https://overpass-api.de/api/interpreter", urllib.parse.urlencode({"data": requete}).encode())
    points = []
    for el in json.loads(brut)["elements"]:
        lat = el.get("lat") or el.get("center", {}).get("lat")
        lon = el.get("lon") or el.get("center", {}).get("lon")
        if lat is None or lon is None or not dans(d["contours"], lat, lon):
            continue
        t = el.get("tags", {})
        genre = "dae" if t.get("emergency") == "defibrillator" else TYPES_OSM.get(t.get("amenity", ""))
        if not genre:
            continue
        p = {"type": genre, "nom": t.get("name", ""), "source": "OpenStreetMap"}
        if genre == "hopital":
            p["urgences"] = t.get("emergency") == "yes"
        if t.get("phone"):
            p["telephone"] = t["phone"]
        points.append(point(lon, lat, p))
    return points


def geodae_national() -> list[tuple[float, float, str]]:
    """La base nationale des défibrillateurs, téléchargée une seule fois : (latitude, longitude, nom)."""
    meta = json.loads(lire("https://www.data.gouv.fr/api/1/datasets/geodae-base-nationale-des-defibrillateurs/", delai=60))
    ressources = [r for r in meta.get("resources", []) if str(r.get("format", "")).lower() == "json"]
    if not ressources:
        raise RuntimeError("aucune ressource JSON dans le jeu Géo'DAE")
    brut = json.loads(lire(ressources[0]["url"], delai=600))
    lignes = brut if isinstance(brut, list) else brut.get("features") or brut.get("data") or []
    sortie = []
    for l in lignes:
        if l.get("geometry"):
            c = l["geometry"].get("coordinates")
            while isinstance(c, list) and c and isinstance(c[0], list):
                c = c[0]
            try:
                lon, lat = float(c[0]), float(c[1])
            except (TypeError, ValueError, IndexError):
                continue
            props = l.get("properties", {}) or {}
        else:
            props = l
            cle_lat = next((k for k in l if "lat" in k.lower()), None)
            cle_lon = next((k for k in l if "lon" in k.lower() or "lng" in k.lower()), None)
            try:
                lat, lon = float(l[cle_lat]), float(l[cle_lon])
            except (TypeError, ValueError, KeyError):
                continue
        nom = next((str(v) for k, v in props.items() if "nom" in k.lower() and v), "Défibrillateur")
        sortie.append((lat, lon, nom))
    return sortie


def refuges(d: dict) -> list[dict]:
    o, s, e, n = d["cadre"]
    url = ("https://www.refuges.info/api/bbox?" + urllib.parse.urlencode({
        "bbox": f"{o},{s},{e},{n}", "type_points": ",".join(map(str, TYPES_REFUGES)),
        "nb_points": "all", "format": "geojson", "detail": "simple", "format_texte": "texte"}))
    points = []
    for f in json.loads(lire(url)).get("features", []):
        lon, lat = f["geometry"]["coordinates"][:2]
        if not dans(d["contours"], lat, lon):
            continue
        p = f.get("properties", {})
        genre = TYPES_REFUGES.get((p.get("type") or {}).get("id"))
        if not genre:
            continue
        q = {"type": genre, "nom": p.get("nom", ""), "source": "Refuges.info (CC BY-SA)"}
        alt = (p.get("coord") or {}).get("alt")
        if alt:
            q["altitude"] = alt
        places = (p.get("places") or {}).get("valeur")
        if places:
            q["places"] = places
        etat = (p.get("etat") or {}).get("valeur")
        if etat:
            q["etat"] = etat
        if p.get("lien"):
            q["lien"] = p["lien"]
        points.append(point(lon, lat, q))
    return points


def ecrire(chemin: Path, points: list[dict]) -> dict:
    texte = json.dumps({"type": "FeatureCollection", "features": points}, ensure_ascii=False, separators=(",", ":"))
    chemin.write_text(texte, encoding="utf-8")
    donnees = texte.encode("utf-8")
    return {"fichier": chemin.name, "octets": len(donnees), "sha256": hashlib.sha256(donnees).hexdigest()}


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    avec_refuges = "--sans-refuges" not in sys.argv
    base = json.loads((RACINE / "contenus" / "cartes" / "departements.json").read_text(encoding="utf-8"))
    deps = [d for d in base["departements"] if not args or d["code"] in args]
    SORTIE.mkdir(exist_ok=True)

    print("Base nationale des défibrillateurs (Géo'DAE)...")
    try:
        dae = geodae_national()
        print(f"  {len(dae)} défibrillateurs")
    except Exception as erreur:
        print(f"  Géo'DAE indisponible ({erreur}) : défibrillateurs d'OpenStreetMap conservés.")
        dae = []

    chemin_catalogue = SORTIE / "catalogue.json"
    catalogue = json.loads(chemin_catalogue.read_text()) if chemin_catalogue.exists() else {"version": "", "fichiers": {}}
    catalogue.setdefault("points", {})

    for d in deps:
        code = d["code"]
        print(f"Département {code} ({d['nom']})...")
        secours = osm(d)
        if dae:
            o, s, e, n = d["cadre"]
            locaux = [point(lon, lat, {"type": "dae", "nom": nom, "source": "Géo'DAE"})
                      for lat, lon, nom in dae if s <= lat <= n and o <= lon <= e and dans(d["contours"], lat, lon)]
            if locaux:
                secours = [p for p in secours if p["properties"]["type"] != "dae"] + locaux
        entree = {"secours": ecrire(SORTIE / f"{code}-secours.geojson", secours)}
        compte: dict[str, int] = {}
        for p in secours:
            compte[p["properties"]["type"]] = compte.get(p["properties"]["type"], 0) + 1
        print(f"  secours : {len(secours)} points {compte}")
        time.sleep(8)  # Overpass : une requête à la fois
        if avec_refuges:
            r = refuges(d)
            entree["refuges"] = ecrire(SORTIE / f"{code}-refuges.geojson", r)
            print(f"  refuges et points d'eau : {len(r)}")
            time.sleep(3)
        catalogue["points"][code] = entree
        chemin_catalogue.write_text(json.dumps(catalogue, indent=1), encoding="utf-8")

    print("Terminé. Déposer à nouveau le dossier cartes_france chez l'hébergeur :")
    print("  rclone copy cartes_france r2:sijamais-cartes/2026-11 --progress")
    return 0


if __name__ == "__main__":
    sys.exit(main())
