# Maquette du MVP logiciel

| Fichier | Rôle |
|---|---|
| `SPECIFICATION.md` | Spécification technique de l'application, base des demandes de devis |
| `recherche.py` | Maquette fonctionnelle de la recherche hors ligne dans les fiches (niveau 1), avec détection des sujets sensibles (niveau 3) et construction de l'invite pour le futur assistant (niveau 2) |
| `tests_recherche.py` | 20 questions de contrôle en langage courant |
| `fiches/` | 12 fiches de démonstration. Elles ne sont pas relues par un professionnel et ne doivent pas être diffusées |

## Essayer

Python 3 suffit, sans installation ni réseau.

```
cd prototype/mvp_logiciel
python3 recherche.py "comment rendre l'eau d'une rivière potable"
python3 recherche.py "il saigne beaucoup du bras"
python3 recherche.py --invite "que faire en cas de coupure de courant"
python3 recherche.py --interactif
python3 tests_recherche.py
```

## Ce que la maquette démontre

1. Une recherche en langage courant dans des fiches validées répond à l'essentiel du besoin sans aucune IA générative, donc sans risque d'invention et sur n'importe quel téléphone.
2. Les sujets de santé sont reconnus et traités à part : rappel du 15 et du 112, fiche validée seulement, aucun texte généré.
3. L'assistant de la version 2 ne recevra que les passages retrouvés et devra citer ses sources.

## Ce qu'elle ne démontre pas

L'application Android elle-même, l'intégration de l'encyclopédie et des cartes, les performances du modèle de langage sur un téléphone. Ces points sont traités dans la spécification et mesurés pendant les 30 premiers jours.

## Ajouter une fiche

Créer un fichier dans `fiches/` en copiant l'en-tête d'une fiche existante, puis ajouter une ou deux questions de contrôle dans `tests_recherche.py`. Relancer les tests.
