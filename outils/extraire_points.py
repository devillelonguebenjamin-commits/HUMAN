#!/usr/bin/env python3
"""Points de secours de la Loire-Atlantique pour la carte hors ligne de SIJAMAIS.

Récupère, sur le Mac (accès internet nécessaire, une seule fois) :
- hôpitaux, pompiers, pharmacies, police et mairies depuis OpenStreetMap (service Overpass) ;
- défibrillateurs depuis la base nationale Géo'DAE (data.gouv.fr), sinon depuis OpenStreetMap.

Écrit app/Sijamais/Resources/Cartes/points-loire-atlantique.geojson.
Usage : python3 outils/extraire_points.py
Bibliothèque standard de Python uniquement.
"""
from __future__ import annotations

import json
import sys
import urllib.parse
import urllib.request
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
SORTIE = RACINE / "app" / "Sijamais" / "Resources" / "Cartes" / "points-loire-atlantique.geojson"
OUEST, SUD, EST, NORD = -2.56, 46.86, -0.92, 47.84
AGENT = {"User-Agent": "SIJAMAIS-prototype-carte/0.1"}

TYPES_OSM = {
    "hospital": "hopital",
    "fire_station": "pompiers",
    "pharmacy": "pharmacie",
    "police": "police",
    "townhall": "mairie",
}


def lire(url: str, donnees: bytes | None = None, delai: int = 180) -> bytes:
    req = urllib.request.Request(url, data=donnees, headers=AGENT)
    with urllib.request.urlopen(req, timeout=delai) as r:
        return r.read()


def dans_zone(lat: float, lon: float) -> bool:
    return SUD <= lat <= NORD and OUEST <= lon <= EST


def point(lon: float, lat: float, proprietes: dict) -> dict:
    return {"type": "Feature", "geometry": {"type": "Point", "coordinates": [round(lon, 6), round(lat, 6)]}, "properties": proprietes}


def osm() -> list[dict]:
    requete = f"""
[out:json][timeout:180];
(
  nwr["amenity"~"^(hospital|fire_station|pharmacy|police|townhall)$"]({SUD},{OUEST},{NORD},{EST});
  node["emergency"="defibrillator"]({SUD},{OUEST},{NORD},{EST});
);
out center tags;
"""
    brut = lire("https://overpass-api.de/api/interpreter", urllib.parse.urlencode({"data": requete}).encode())
    points = []
    for e in json.loads(brut)["elements"]:
        lat = e.get("lat") or e.get("center", {}).get("lat")
        lon = e.get("lon") or e.get("center", {}).get("lon")
        if lat is None or lon is None:
            continue
        t = e.get("tags", {})
        if t.get("emergency") == "defibrillator":
            genre = "dae"
        else:
            genre = TYPES_OSM.get(t.get("amenity", ""))
        if not genre:
            continue
        p = {"type": genre, "nom": t.get("name", ""), "source": "OpenStreetMap"}
        if genre == "hopital":
            p["urgences"] = t.get("emergency") == "yes"
        if t.get("phone"):
            p["telephone"] = t["phone"]
        points.append(point(lon, lat, p))
    return points


def geodae() -> list[dict]:
    """Défibrillateurs de la base nationale. Les noms de colonnes sont cherchés de façon tolérante."""
    meta = json.loads(lire("https://www.data.gouv.fr/api/1/datasets/geodae-base-nationale-des-defibrillateurs/", delai=60))
    ressources = [r for r in meta.get("resources", []) if str(r.get("format", "")).lower() == "json"]
    if not ressources:
        raise RuntimeError("aucune ressource JSON dans le jeu Géo'DAE")
    brut = json.loads(lire(ressources[0]["url"], delai=300))
    lignes = brut if isinstance(brut, list) else brut.get("features") or brut.get("data") or []
    points = []
    for l in lignes:
        if "geometry" in l and l.get("geometry"):
            lon, lat = l["geometry"]["coordinates"][:2]
            props = l.get("properties", {})
        else:
            props = l
            cle_lat = next((k for k in l if "lat" in k.lower()), None)
            cle_lon = next((k for k in l if "lon" in k.lower() or "lng" in k.lower()), None)
            if not cle_lat or not cle_lon:
                continue
            try:
                lat, lon = float(l[cle_lat]), float(l[cle_lon])
            except (TypeError, ValueError):
                continue
        if not dans_zone(lat, lon):
            continue
        nom = next((str(v) for k, v in props.items() if "nom" in k.lower() and v), "Défibrillateur")
        points.append(point(lon, lat, {"type": "dae", "nom": nom, "source": "Géo'DAE"}))
    return points


def main() -> int:
    print("Récupération des services de secours depuis OpenStreetMap...")
    tous = osm()
    try:
        print("Récupération des défibrillateurs depuis Géo'DAE...")
        dae = geodae()
        if dae:
            tous = [p for p in tous if p["properties"]["type"] != "dae"] + dae
    except Exception as erreur:  # la base nationale est facultative : on garde alors ceux d'OpenStreetMap
        print(f"Géo'DAE indisponible ({erreur}) : défibrillateurs d'OpenStreetMap conservés.")
    SORTIE.parent.mkdir(parents=True, exist_ok=True)
    SORTIE.write_text(json.dumps({"type": "FeatureCollection", "features": tous}, ensure_ascii=False), encoding="utf-8")
    compte: dict[str, int] = {}
    for p in tous:
        compte[p["properties"]["type"]] = compte.get(p["properties"]["type"], 0) + 1
    print(f"{len(tous)} points écrits dans {SORTIE.relative_to(RACINE)} : {compte}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
