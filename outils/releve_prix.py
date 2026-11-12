#!/usr/bin/env python3
"""Relevé de prix publics des téléphones et accessoires suivis (projet HUMAN).

Lit une liste d'adresses de fiches produit, extrait le prix affiché à partir des
données structurées de la page (JSON-LD de type Product, ou balises meta de prix),
et ajoute une ligne datée par produit dans un fichier CSV.

Usage :
    python3 releve_prix.py                      # lit produits_suivis.csv, écrit releves_prix.csv
    python3 releve_prix.py --test               # vérifie l'extraction sur un exemple intégré, sans réseau

A lancer une fois par semaine. Respecter les conditions d'utilisation des sites :
une requête par page, pas de boucle rapide. Bibliothèque standard uniquement.
"""
import argparse
import csv
import json
import re
import sys
import time
import urllib.request
from datetime import date
from pathlib import Path

ICI = Path(__file__).resolve().parent
ENTREE = ICI / "produits_suivis.csv"
SORTIE = ICI / "releves_prix.csv"
AGENT = "Mozilla/5.0 (compatible; releve-prix/0.1)"


def _offres(noeud):
    """Parcourt un objet JSON-LD et renvoie les (prix, devise) trouvés dans les offres de produits."""
    trouves = []
    if isinstance(noeud, list):
        for element in noeud:
            trouves += _offres(element)
    elif isinstance(noeud, dict):
        types = noeud.get("@type", "")
        types = types if isinstance(types, list) else [types]
        if "Product" in types and "offers" in noeud:
            offres = noeud["offers"]
            for offre in (offres if isinstance(offres, list) else [offres]):
                if isinstance(offre, dict):
                    prix = offre.get("price") or offre.get("lowPrice")
                    if prix is not None:
                        trouves.append((str(prix), offre.get("priceCurrency", "")))
        for valeur in noeud.values():
            if isinstance(valeur, (dict, list)):
                trouves += _offres(valeur)
    return trouves


def extraire_prix(html: str):
    """Renvoie (prix, devise) ou (None, None). Essaie le JSON-LD, puis les balises meta."""
    for bloc in re.findall(r'<script[^>]+type=["\']application/ld\+json["\'][^>]*>(.*?)</script>', html, flags=re.S | re.I):
        try:
            donnees = json.loads(bloc.strip())
        except json.JSONDecodeError:
            continue
        offres = _offres(donnees)
        if offres:
            prix, devise = offres[0]
            return _nombre(prix), devise or None
    m = re.search(r'<meta[^>]+(?:property|itemprop)=["\'](?:product:price:amount|og:price:amount|price)["\'][^>]+content=["\']([^"\']+)["\']', html, flags=re.I)
    if m:
        d = re.search(r'<meta[^>]+(?:property|itemprop)=["\'](?:product:price:currency|og:price:currency|priceCurrency)["\'][^>]+content=["\']([^"\']+)["\']', html, flags=re.I)
        return _nombre(m.group(1)), (d.group(1) if d else None)
    return None, None


def _nombre(texte: str):
    """Convertit '1 234,50' ou '1234.50' en nombre."""
    propre = re.sub(r"[^\d,.]", "", texte)
    if "," in propre and "." in propre:
        propre = propre.replace(".", "").replace(",", ".") if propre.rfind(",") > propre.rfind(".") else propre.replace(",", "")
    else:
        propre = propre.replace(",", ".")
    try:
        return float(propre)
    except ValueError:
        return None


def telecharger(adresse: str) -> str:
    requete = urllib.request.Request(adresse, headers={"User-Agent": AGENT, "Accept-Language": "fr-FR,fr;q=0.9"})
    with urllib.request.urlopen(requete, timeout=20) as reponse:
        return reponse.read().decode("utf-8", errors="replace")


def relever() -> int:
    if not ENTREE.exists():
        print(f"Fichier introuvable : {ENTREE}")
        return 1
    nouveau = not SORTIE.exists()
    with ENTREE.open(encoding="utf-8", newline="") as f, SORTIE.open("a", encoding="utf-8", newline="") as g:
        sortie = csv.writer(g, delimiter=";")
        if nouveau:
            sortie.writerow(["date", "produit", "vendeur", "prix_ttc", "devise", "adresse", "statut"])
        for ligne in csv.DictReader(f, delimiter=";"):
            adresse = ligne["adresse"].strip()
            if not adresse or adresse.startswith("#"):
                continue
            try:
                prix, devise = extraire_prix(telecharger(adresse))
                statut = "ok" if prix is not None else "prix non trouvé"
            except Exception as erreur:  # réseau, page absente, blocage
                prix, devise, statut = None, None, f"erreur : {type(erreur).__name__}"
            sortie.writerow([date.today().isoformat(), ligne["produit"], ligne["vendeur"],
                             "" if prix is None else f"{prix:.2f}".replace(".", ","), devise or "", adresse, statut])
            print(f"{ligne['produit']:<32} {ligne['vendeur']:<16} {'' if prix is None else prix:>8} {devise or '':<4} {statut}")
            time.sleep(2)
    print(f"\nRelevé ajouté à {SORTIE.name}")
    return 0


EXEMPLE = """<html><head>
<script type="application/ld+json">{"@context":"https://schema.org","@graph":[{"@type":"BreadcrumbList"},
{"@type":"Product","name":"Téléphone durci 22 000 mAh","offers":{"@type":"Offer","price":"272.00","priceCurrency":"EUR"}}]}</script>
</head><body></body></html>"""
EXEMPLE_META = '<html><head><meta property="product:price:amount" content="1 299,90"><meta property="product:price:currency" content="EUR"></head></html>'


def tester() -> int:
    cas = [(EXEMPLE, (272.0, "EUR")), (EXEMPLE_META, (1299.9, "EUR")), ("<html></html>", (None, None))]
    echecs = 0
    for html, attendu in cas:
        obtenu = extraire_prix(html)
        ok = obtenu == attendu
        echecs += 0 if ok else 1
        print(("OK    " if ok else "ECHEC ") + f"attendu {attendu}, obtenu {obtenu}")
    return 0 if echecs == 0 else 1


if __name__ == "__main__":
    analyseur = argparse.ArgumentParser(description="Relevé de prix publics.")
    analyseur.add_argument("--test", action="store_true", help="Tester l'extraction sans réseau")
    sys.exit(tester() if analyseur.parse_args().test else relever())
