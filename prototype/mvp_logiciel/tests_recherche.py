#!/usr/bin/env python3
"""Jeu de questions de contrôle de la maquette de recherche.

Chaque question doit faire remonter la bonne fiche en première position, et les
sujets de santé doivent déclencher le rappel d'urgence. Ce jeu est l'embryon des
"100 questions pièges" rejouées à chaque version (voir SPECIFICATION.md).

Usage : python3 tests_recherche.py
"""
import sys

from recherche import chercher, construire_index

# (question en langage courant, fiche attendue, sujet sensible attendu)
CAS = [
    ("comment rendre l'eau d'une rivière potable", "eau-potable", False),
    ("j'ai soif et je n'ai que de l'eau de pluie", "eau-potable", False),
    ("combien de temps faire bouillir l'eau", "eau-potable", False),
    ("plus d'électricité dans tout le quartier", "coupure-courant", False),
    ("panne de courant que faire avec le congélateur", "coupure-courant", False),
    ("il saigne beaucoup du bras", "hemorragie", True),
    ("plaie profonde, le sang ne s'arrête pas", "hemorragie", True),
    ("ma mère est évanouie mais elle respire", "inconscient-respire", True),
    ("il ne répond plus", "inconscient-respire", True),
    ("mon fils s'est brûlé avec de l'eau bouillante", "brulure", True),
    ("elle grelotte et parle bizarrement après une chute dans l'eau froide", "hypothermie", True),
    ("allumer un feu avec du bois mouillé", "feu-allumer", False),
    ("où dormir dehors sous la pluie sans tente", "abri-improvise", False),
    ("nous sommes perdus en forêt sans GPS", "orientation-sans-gps", False),
    ("trouver le nord sans boussole", "orientation-sans-gps", False),
    ("que mettre dans le sac d'urgence 72 heures", "kit-72h", False),
    ("liste du kit de survie recommandé par le gouvernement", "kit-72h", False),
    ("l'eau monte dans la rue, la rivière déborde", "inondation", False),
    ("quel numéro appeler pour les secours", "alerter-secours", False),
    ("comment signaler ma position sans réseau", "alerter-secours", False),
]


def main() -> int:
    base = construire_index()
    echecs = 0
    for question, attendu, sensible_attendu in CAS:
        r = chercher(base, question)
        obtenu = r["resultats"][0]["id"] if r["resultats"] else "(aucune fiche)"
        ok = obtenu == attendu and r["sensible"] == sensible_attendu
        echecs += 0 if ok else 1
        marque = "OK    " if ok else "ECHEC "
        detail = "" if ok else f"  -> obtenu : {obtenu}, sensible : {r['sensible']}"
        print(f"{marque}{question}{detail}")
    total = len(CAS)
    print(f"\n{total - echecs} réussites sur {total}.")
    return 0 if echecs == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
