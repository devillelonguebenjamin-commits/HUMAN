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

Taille attendue : quelques gigaoctets au total. La planète entière fait environ 120 Go au zoom 15, et chaque niveau de zoom double à peu près la taille ([Protomaps](https://docs.protomaps.com/basemaps/downloads)). À mesurer avec `--mesurer`.

## Héberger (à faire par Benjamin)

Protomaps déconseille de pointer une application vers ses fichiers quotidiens : il faut les copier sur son propre stockage ([Protomaps](https://docs.protomaps.com/basemaps/downloads)).

Proposition : **Cloudflare R2**. L'offre gratuite donne 10 Go de stockage par mois, et la bande passante sortante est gratuite quel que soit le volume ([Cloudflare](https://developers.cloudflare.com/r2/pricing/index.md)). La France entière devrait y tenir.

1. Créer un compte Cloudflare, puis un « bucket » R2 nommé par exemple `sijamais-cartes`, avec un accès public par un sous-domaine (par exemple `cartes.<ton-domaine>`).
2. Déposer le contenu du dossier `cartes_france/` dans un dossier daté, par exemple `2026-12/`. Le dépôt peut se faire avec l'interface web ou avec l'outil `rclone`.
3. Me donner l'adresse publique : je la mets dans `departements.json` (champ `adresseBase`, par exemple `https://cartes.<ton-domaine>/2026-12/`). L'application vérifie l'empreinte SHA-256 de chaque fichier téléchargé.

Tant que `adresseBase` est vide, l'écran « Cartes de France » l'explique, et seules la vue d'ensemble et la Loire-Atlantique (fichier embarqué) sont disponibles.

## Obligations

- Mention « © les contributeurs d'OpenStreetMap » visible sur la carte (ODbL).
- Mise à jour mensuelle conseillée ; garder les fichiers du mois précédent le temps que les téléphones basculent.
