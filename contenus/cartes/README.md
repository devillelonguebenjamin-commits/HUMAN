# Cartes hors ligne de toute la France

Construit le 27/11/2026 (palier E de `14_cartes_hors_ligne.md`).

## Principe

- **Vue d'ensemble** de la métropole et de la Corse (zoom 0 à 8), **embarquée dans l'application** : toute la France est visible dès l'installation, sans réseau.
- **Un fichier par département** (101, outre-mer compris, zoom 15, fond Protomaps tiré d'OpenStreetMap), **téléchargé une fois** dans l'application, puis lisible sans réseau.
- **Gratuit : un département** (le sien), parce que la carte protège. **Abonnement : toute la France.**
- La carte assemble automatiquement la vue d'ensemble et les départements présents. Elle s'ouvre sur « Mon département » et affiche les traces GPX par-dessus.
- `departements.json` donne les codes, noms, régions, cadres et contours simplifiés : contours Admin Express de l'IGN, Licence Ouverte, via github.com/gregoiredavid/france-geojson.

## Fabriquer les cartes (sur le Mac, une fois par mois)

```
brew install pmtiles
cd ~/Documents/GitHub/HUMAN
bash outils/construire_cartes_france.sh --mesurer   # d'abord : tailles estimées, sans rien télécharger
bash outils/construire_cartes_france.sh             # puis : vue d'ensemble + 101 départements + catalogue
```

**Tailles mesurées le 27/11/2026** (carte Protomaps du jour, zoom 15) :
- vue d'ensemble de la France : 28 Mo ;
- 101 départements : 11,1 Go au total ;
- médiane : 101 Mo par département ; le plus gros est le Nord (428 Mo), les plus petits Mayotte (9,6 Mo) et la Martinique (14 Mo) ; la Loire-Atlantique fait 169 Mo.

Une première estimation (2 à 4 Go) était fausse d'un facteur trois : la France est très détaillée dans OpenStreetMap. Pour diviser les tailles par deux environ, il suffirait de s'arrêter au zoom 14 (chaque niveau double à peu près la taille), au prix de détails en moins (bâtiments, petits chemins) aux plus forts zooms.

## Points de secours et refuges (sur le Mac, après les cartes)

```
python3 outils/construire_points_france.py             # les 101 départements, environ 3 heures
python3 outils/construire_points_france.py 74 73 05    # seulement quelques départements
rclone copy cartes_france r2:sijamais-cartes/2026-11 --progress
```

Le script écrit, pour chaque département, à côté de sa carte :
- `<code>-secours.geojson` : hôpitaux, pompiers, pharmacies, police, mairies (OpenStreetMap, ODbL) et défibrillateurs (Géo'DAE, sinon OpenStreetMap). **Gratuit** ;
- `<code>-refuges.geojson` : refuges gardés, cabanes, gîtes d'étape, abris, points d'eau (Refuges.info, CC BY-SA 2.0). **Affichés seulement avec l'abonnement**, crédit visible ;
- et la rubrique `points` du `catalogue.json` (taille et empreinte de chaque fichier).

Il faut le lancer **après** `construire_cartes_france.sh`, qui réécrit le catalogue. L'application télécharge ces fichiers avec la carte du département, vérifie leur empreinte, et fusionne les points sans doublon.

Essai du 27/11/2026 sur la Haute-Savoie (74) : 429 points Refuges.info (250 points d'eau, 85 cabanes, 58 gîtes, 35 refuges, 1 abri).

**Refuges.info** : l'API est un « service web personnel et non commercial » ([documentation](https://www.refuges.info/api/doc/)). L'application ne l'interroge jamais ; le script fait une requête par département et par mois, avec une pause. **Ne pas publier les fichiers `-refuges` avant la réponse de l'équipe** (courrier `courriers/04_refuges_info.md`) ; en attendant, lancer le script avec `--sans-refuges`.

## Héberger (à faire par Benjamin)

Protomaps déconseille de pointer une application vers ses fichiers quotidiens : il faut les copier sur son propre stockage ([Protomaps](https://docs.protomaps.com/basemaps/downloads)).

Proposition : **Cloudflare R2**. L'offre gratuite donne 10 Go de stockage par mois, et la bande passante sortante est gratuite quel que soit le volume ; au-delà, le stockage coûte 0,015 $ par Go et par mois ([Cloudflare](https://developers.cloudflare.com/r2/pricing/index.md)). Avec 11,1 Go, le dépassement est d'environ 1 Go, soit quelques centimes par mois ; pendant le changement de mois (deux versions en ligne, environ 22 Go), moins de 0,20 $ par mois.

1. Créer un compte Cloudflare, puis un « bucket » R2 nommé par exemple `sijamais-cartes`, avec un accès public par un sous-domaine (par exemple `cartes.<ton-domaine>`).
2. Déposer le contenu du dossier `cartes_france/` dans un dossier daté, par exemple `2026-12/`. Le dépôt peut se faire avec l'interface web ou avec l'outil `rclone`.
3. Me donner l'adresse publique : je la mets dans `departements.json` (champ `adresseBase`, par exemple `https://cartes.<ton-domaine>/2026-12/`). L'application vérifie l'empreinte SHA-256 de chaque fichier téléchargé.

Tant que `adresseBase` est vide, l'écran « Cartes de France » l'explique, et seules la vue d'ensemble et la Loire-Atlantique (fichier embarqué) sont disponibles.

## Obligations

- Mention « © les contributeurs d'OpenStreetMap » visible sur la carte (ODbL).
- Mise à jour mensuelle conseillée ; garder les fichiers du mois précédent le temps que les téléphones basculent.
