# Outils

| Fichier | Rôle | Etat |
|---|---|---|
| `generer_modele_financier.py` | Génère `modele_financier.xlsx` : hypothèses, économie unitaire, trois scénarios mensuels sur 36 mois, synthèse, sensibilités, emploi des fonds. Le classeur ne contient que des saisies et des formules | Exécuté et recalculé le 12/11/2026 : 6 762 formules, aucune erreur |
| `releve_prix.py` | Relève chaque semaine les prix publics des téléphones, cartes et accessoires suivis, et les ajoute à `releves_prix.csv` | Extraction testée hors ligne (`--test`). Non exécuté sur des sites réels : l'environnement de travail n'avait pas d'accès direct au web |
| `produits_suivis.csv` | Liste des fiches produit à suivre, à compléter avec les adresses réelles | Modèle à remplir |

## Régénérer le modèle financier

```
python3 outils/generer_modele_financier.py modele_financier.xlsx
```

Ouvrir ensuite le fichier dans Excel ou LibreOffice pour que les formules soient calculées. Pour changer une hypothèse de façon durable, modifier la liste `HYP` du script. Pour un essai ponctuel, modifier directement les cellules bleues de la feuille `Hypotheses`.

## Relever les prix

```
python3 outils/releve_prix.py --test     # contrôle sans réseau
python3 outils/releve_prix.py            # relevé réel
```

Le script lit le prix dans les données structurées des pages. Certains sites ne les publient pas ou bloquent les robots : la colonne `statut` le signale. Il fait une seule requête par page, avec une pause de deux secondes. Vérifier les conditions d'utilisation des sites suivis.
