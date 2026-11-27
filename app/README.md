# Application iPhone SIJAMAIS (version 0.1)

Première version du code de l'application, commencée le 26 novembre 2026. SwiftUI, iPhone, iOS 17 au minimum ; l'assistant utilise le modèle d'Apple à partir d'iOS 26, sur les iPhone compatibles.

## Organisation

| Dossier | Contenu | Où il se teste |
|---|---|---|
| `SijamaisKit/` | Le cœur, en Swift pur : lecture des 46 guides, recherche hors ligne, règles et triage de l'assistant, score de préparation | Sur Mac et sur Linux : `swift test` (28 tests, dont les 40 cas du cycle 1) |
| `Sijamais/` | L'application : écrans SwiftUI, enregistrement sur le téléphone, lampe, passerelle vers le modèle d'Apple | Sur Mac, avec Xcode |
| `Sijamais/Resources/` | `guides.json` et le catalogue d'images (24 schémas, icône, couleur d'accent). **Ne pas modifier à la main** : produit par `python3 outils/preparer_ressources_app.py` | |
| `project.yml` | Description du projet Xcode, lue par XcodeGen | |
| `design/` | Icône de l'application (SVG source et PNG 1024) | |

## Ce que fait la version 0.1

| Écran | Contenu |
|---|---|
| Prise en main | 3 questions : usages, commune, foyer ; indique si l'assistant d'Apple est disponible sur l'iPhone |
| Accueil | Bouton Urgence, « Posez une question », score de préparation, accès rapides (Préparer, Famille, Ma commune, lampe torche) |
| Urgence | Appel direct du 112, 15, 18, 17 et 114 par SMS ; 7 réflexes ; 12 scénarios ; premiers secours |
| Assistant (au centre) | Questions fréquentes, recherche dans les guides, reformulation par le modèle d'Apple quand il est disponible, bandeau 15 et 112 pour la santé, sans jamais de reformulation |
| Savoir | Les 46 guides par catégorie, avec schémas, listes à cocher et formulaires enregistrés sur le téléphone |
| Carte | Carte hors ligne MapLibre (fond OpenStreetMap par Protomaps) : hôpitaux, pompiers, pharmacies, police, mairies, position GPS. Le fichier de carte s'extrait sur le Mac (voir plus bas) |
| Réglages | Foyer, commune, données personnelles, à propos |

Pas encore fait : défibrillateurs et téléchargement des cartes de toute la France, profil d'aidant et QR code, espace commune, abonnement, contenus de loisir, notifications.

## Ouvrir le projet sur ton Mac (première fois)

Dans le Terminal :

1. Installer Homebrew, le gestionnaire d'outils du Mac (une seule fois ; il demande ton mot de passe) :
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   À la fin, Homebrew affiche deux ou trois lignes à copier pour l'ajouter au Terminal (« Next steps ») : copie-les et exécute-les.
2. Installer XcodeGen :
   ```
   brew install xcodegen
   ```
3. Récupérer la dernière version du dépôt avec GitHub Desktop (« Fetch origin », puis « Pull origin »).
4. Fabriquer le projet Xcode, puis l'ouvrir :
   ```
   cd ~/Documents/GitHub/HUMAN/app
   xcodegen generate
   open Sijamais.xcodeproj
   ```

## Lancer l'application

1. Dans Xcode, en haut, choisir la cible « Sijamais » et un simulateur, par exemple iPhone 17 Pro.
2. Appuyer sur le bouton Lecture (ou Cmd + R).
3. Pour l'installer sur ton iPhone : brancher l'iPhone, le choisir en haut, puis dans « Signing & Capabilities » choisir ton équipe (ton identifiant Apple, « Personal Team »). Avec un identifiant gratuit, l'application expire au bout de 7 jours.
4. Le simulateur n'a pas le modèle d'Apple : l'assistant y affiche les passages des guides. Pour tester la reformulation, il faut un iPhone compatible (15 Pro ou plus récent) avec Apple Intelligence activée, en français.

## Ajouter la carte de la Loire-Atlantique (prototype)

Le fichier de carte est trop lourd pour le dépôt : on le fabrique sur le Mac.

```
brew install pmtiles
cd ~/Documents/GitHub/HUMAN
bash outils/extraire_carte.sh
python3 outils/extraire_points.py
cd app && xcodegen generate
```

`extraire_carte.sh` produit le fond de carte (`loire-atlantique.pmtiles`) ; `extraire_points.py` produit les points de secours (`points-loire-atlantique.geojson` : hôpitaux, pompiers, pharmacies, police, mairies depuis OpenStreetMap, défibrillateurs depuis Géo'DAE). Les deux fichiers sont rangés dans `app/Sijamais/Resources/Cartes/` et ignorés par Git.

## Lancer les tests

- Dans Xcode : menu Product, puis Test (Cmd + U).
- Ou dans le Terminal : `cd ~/Documents/GitHub/HUMAN/app/SijamaisKit && swift test`

## Après une modification des guides

```
python3 outils/construire_guides_v11.py
python3 outils/preparer_ressources_app.py
cd app && xcodegen generate
```

## Si la compilation échoue

Le code de l'application n'a pas pu être compilé dans l'environnement de Claude, qui n'a pas Xcode : seul le cœur (`SijamaisKit`) y a été compilé et testé. Une erreur de compilation est donc possible au premier lancement. Fais une capture de l'erreur (panneau de gauche, icône en triangle) et envoie-la : je corrige.
