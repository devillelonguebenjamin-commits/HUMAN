#!/usr/bin/env python3
"""Maquette du niveau 1 du MVP : recherche hors ligne dans des fiches validées.

Aucune génération de texte : l'outil retrouve et affiche des fiches existantes.
Bibliothèque standard de Python uniquement (SQLite FTS5), donc aucun réseau.

Usage :
    python3 recherche.py "comment rendre l'eau potable"
    python3 recherche.py --interactif
    python3 recherche.py --invite "que faire en cas de coupure de courant"

Sur le téléphone, la même logique sera portée dans l'application Android
(SQLite FTS5 est disponible nativement sur Android).
"""
import argparse
import re
import sqlite3
import sys
import unicodedata
from pathlib import Path

DOSSIER_FICHES = Path(__file__).resolve().parent / "fiches"

MOTS_VIDES = set("""
a au aux avec ce ces cet cette comment dans de des du elle en est et il ils j je l la le les
leur lui ma mais me mes moi mon ne nos notre nous on ou où par pas pour qu que quel quelle
quels quelles qui quoi sa se ses si son sur ta te tes toi ton tu un une vos votre vous y d
c s n m t faire fait faut dois doit peut peux suis es sont être avoir ai as ont quand
combien temps cas plus tout tous toute beaucoup
""".split())

# Synonymes et formulations courantes : le client ne parle pas comme une fiche.
SYNONYMES = {
    "saigne": ["hemorragie", "saignement", "sang"],
    "saignement": ["hemorragie", "sang"],
    "sang": ["hemorragie", "saignement"],
    "evanoui": ["inconscient", "malaise"],
    "evanouie": ["inconscient", "malaise"],
    "repond": ["inconscient"],
    "reveille": ["inconscient"],
    "electricite": ["courant", "coupure", "panne"],
    "panne": ["coupure", "courant"],
    "blackout": ["coupure", "courant"],
    "lumiere": ["courant", "coupure"],
    "boire": ["eau", "potable"],
    "soif": ["eau", "potable"],
    "riviere": ["eau", "potable"],
    "ruisseau": ["eau", "potable"],
    "froid": ["hypothermie"],
    "gele": ["hypothermie", "froid"],
    "grelotte": ["hypothermie", "froid"],
    "perdu": ["orientation"],
    "perdus": ["orientation"],
    "nord": ["orientation", "boussole"],
    "dormir": ["abri", "bivouac"],
    "tente": ["abri", "bivouac"],
    "sac": ["kit"],
    "provisions": ["kit", "reserve"],
    "crue": ["inondation"],
    "appeler": ["alerter", "secours", "urgence"],
    "numero": ["alerter", "secours", "urgence"],
    "pompiers": ["alerter", "secours"],
    "samu": ["alerter", "secours"],
    "bouillir": ["potable", "ebullition"],
    "purifier": ["potable"],
    "cloque": ["brulure"],
    "ebouillante": ["brulure"],
}

# Termes qui signalent un sujet de santé : affichage du rappel d'urgence,
# et aucune réponse générée par un modèle de langage (niveau 3 de la spécification).
TERMES_SENSIBLES = {
    "hemorragie", "saigne", "saignement", "sang", "inconscient", "inconsciente", "malaise",
    "brulure", "brule", "brulee", "hypothermie", "medicament", "medicaments", "dose", "dosage",
    "douleur", "fracture", "poison", "champignon", "champignons", "plante", "plantes", "bebe",
    "respire", "coeur", "cardiaque", "etouffe", "allergie", "morsure", "piqure", "fievre",
}

# Une fiche secondaire n'est proposée que si son score atteint cette part du score de la première.
SEUIL_VOIR_AUSSI = 0.45

RAPPEL_URGENCE = ("Sujet de santé : seule une fiche validée est affichée, sans réponse générée. "
                  "En cas d'urgence, appelez le 15 ou le 112 dès que c'est possible.")


def normaliser(texte: str) -> str:
    """Minuscules, sans accents."""
    texte = unicodedata.normalize("NFD", texte.lower())
    return "".join(c for c in texte if unicodedata.category(c) != "Mn")


def lire_fiche(chemin: Path) -> dict:
    """Lit une fiche Markdown avec en-tête 'clé: valeur' entre deux lignes '---'."""
    brut = chemin.read_text(encoding="utf-8")
    _, entete, corps = brut.split("---", 2)
    meta = {}
    for ligne in entete.strip().splitlines():
        cle, _, valeur = ligne.partition(":")
        meta[cle.strip()] = valeur.strip()
    corps = "\n".join(l for l in corps.strip().splitlines() if not l.startswith(">")).strip()
    essentiel = ""
    m = re.search(r"## L'essentiel\s*\n(.+?)(?:\n## |\Z)", corps, flags=re.S)
    if m:
        essentiel = " ".join(m.group(1).split())
    meta.update(corps=corps, essentiel=essentiel, fichier=chemin.name)
    return meta


def construire_index(dossier: Path = DOSSIER_FICHES) -> sqlite3.Connection:
    """Index plein texte en mémoire. Sur le téléphone, l'index est un fichier livré avec le pack."""
    base = sqlite3.connect(":memory:")
    base.row_factory = sqlite3.Row
    base.execute("""CREATE VIRTUAL TABLE fiches USING fts5(
        id UNINDEXED, titre, mots_cles, corps, categorie UNINDEXED, sensible UNINDEXED,
        sources UNINDEXED, relecture UNINDEXED, maj UNINDEXED, essentiel UNINDEXED,
        tokenize = 'unicode61 remove_diacritics 2')""")
    for chemin in sorted(dossier.glob("*.md")):
        f = lire_fiche(chemin)
        base.execute("INSERT INTO fiches VALUES (?,?,?,?,?,?,?,?,?,?)", (
            f["id"], f["titre"], f["mots_cles"], f["corps"], f["categorie"], f["sensible"],
            f["sources"], f["relecture"], f["maj"], f["essentiel"]))
    return base


def termes_de_recherche(question: str) -> list:
    """Découpe la question, retire les mots vides, ajoute les synonymes."""
    mots = [m for m in re.findall(r"[a-z0-9]+", normaliser(question)) if m not in MOTS_VIDES and len(m) > 1]
    termes = []
    for m in mots:
        termes.append(m)
        termes.extend(SYNONYMES.get(m, []))
    vus, uniques = set(), []
    for t in termes:
        if t not in vus:
            vus.add(t)
            uniques.append(t)
    return uniques


def requete_fts(termes: list) -> str:
    """Requête FTS5 : OU logique, avec troncature pour approcher pluriels et conjugaisons."""
    parties = []
    for t in termes:
        racine = t if len(t) <= 4 else t[: max(4, len(t) - 2)]
        parties.append(f'"{racine}"*')
    return " OR ".join(parties)


def chercher(base: sqlite3.Connection, question: str, limite: int = 3) -> dict:
    """Renvoie les fiches les plus pertinentes et l'indication de sujet sensible."""
    termes = termes_de_recherche(question)
    if not termes:
        return {"question": question, "sensible": False, "resultats": []}
    # Pondération BM25 : le titre et les mots-clés comptent plus que le corps.
    lignes = base.execute(
        """SELECT id, titre, categorie, sensible, sources, relecture, maj, essentiel,
                  bm25(fiches, 0.0, 6.0, 4.0, 1.0) AS score
           FROM fiches WHERE fiches MATCH ? ORDER BY score LIMIT ?""",
        (requete_fts(termes), limite)).fetchall()
    resultats = [dict(l) for l in lignes]
    # Les scores BM25 sont négatifs (plus bas = plus pertinent). On écarte des "voir aussi"
    # les fiches nettement moins pertinentes que la première, pour éviter les rapprochements absurdes.
    if resultats:
        seuil = resultats[0]["score"] * SEUIL_VOIR_AUSSI
        resultats = [resultats[0]] + [r for r in resultats[1:] if r["score"] <= seuil]
    sensible = bool(set(termes) & TERMES_SENSIBLES) or bool(resultats and resultats[0]["sensible"] == "oui")
    return {"question": question, "sensible": sensible, "resultats": resultats}


def construire_invite(question: str, resultats: list) -> str:
    """Niveau 2 (v2 de l'application) : invite envoyée au modèle de langage local.

    Le modèle ne reçoit que les passages retrouvés et doit citer ses sources.
    Cette fonction n'est jamais appelée pour un sujet sensible (niveau 3).
    """
    passages = "\n\n".join(f"[{i}] {r['titre']} : {r['essentiel']}" for i, r in enumerate(resultats, start=1))
    return (
        "Tu es un assistant hors ligne. Réponds en français, en cinq phrases au plus, "
        "uniquement à partir des passages ci-dessous. Cite le numéro du passage utilisé. "
        "Si les passages ne répondent pas à la question, réponds exactement : "
        "\"Je n'ai pas de fiche sur ce sujet.\"\n\n"
        f"Passages :\n{passages}\n\nQuestion : {question}\nRéponse :")


def afficher(reponse: dict) -> None:
    print(f"\nQuestion : {reponse['question']}")
    if not reponse["resultats"]:
        print("Aucune fiche ne correspond. Reformulez avec des mots simples (eau, feu, froid, blessure...).")
        return
    if reponse["sensible"]:
        print(f"\n!  {RAPPEL_URGENCE}")
    premier = reponse["resultats"][0]
    print(f"\n> {premier['titre']}  ({premier['categorie']})")
    print(f"  {premier['essentiel']}")
    print(f"  Sources : {premier['sources']}")
    print(f"  Relecture : {premier['relecture']}. Mise à jour : {premier['maj']}.")
    if len(reponse["resultats"]) > 1:
        print("\nVoir aussi :")
        for r in reponse["resultats"][1:]:
            print(f"  - {r['titre']}  ({r['categorie']})")


def main() -> int:
    analyseur = argparse.ArgumentParser(description="Recherche hors ligne dans les fiches (maquette).")
    analyseur.add_argument("question", nargs="*", help="Question en langage courant")
    analyseur.add_argument("--interactif", action="store_true", help="Poser plusieurs questions à la suite")
    analyseur.add_argument("--invite", action="store_true",
                           help="Afficher l'invite qui serait envoyée au modèle local (niveau 2)")
    args = analyseur.parse_args()
    base = construire_index()
    if args.interactif:
        print("Recherche hors ligne. Ligne vide pour quitter.")
        while True:
            try:
                q = input("\n? ").strip()
            except EOFError:
                break
            if not q:
                break
            afficher(chercher(base, q))
        return 0
    if not args.question:
        analyseur.print_help()
        return 1
    question = " ".join(args.question)
    reponse = chercher(base, question)
    afficher(reponse)
    if args.invite:
        if reponse["sensible"]:
            print("\n[Niveau 3] Sujet sensible : aucune invite n'est envoyée au modèle.")
        elif reponse["resultats"]:
            print("\n[Niveau 2] Invite pour le modèle local :\n")
            print(construire_invite(question, reponse["resultats"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
