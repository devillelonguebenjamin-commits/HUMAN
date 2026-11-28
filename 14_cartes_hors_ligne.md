# 14. Cartes hors ligne : choix et plan de travail

Rédigé le 26 novembre 2026, après la première compilation de l'application. Marqueurs : [FAIT] vérifié ce jour, [A VERIFIER], [EST] estimation.

## 1. Pourquoi la carte n'est pas encore dans l'application

C'est la brique technique la plus lourde, et elle a été laissée pour après le cœur (guides, assistant). Il manque trois choses :

1. **Un moteur de carte** capable de fonctionner sans réseau. Celui d'Apple (MapKit) ne le permet pas aux applications tierces : les cartes hors ligne d'iOS sont réservées à l'application Plans [FAIT, forums développeurs Apple]. Celui de Google non plus. Il faut donc intégrer un moteur libre : **MapLibre Native**, licence BSD, prévu depuis la spécification.
2. **Les fichiers de carte** de chaque département, à préparer, à héberger et à faire télécharger une fois par l'application.
3. **Les couches utiles** (hôpitaux, pompiers, défibrillateurs, risques, points de rassemblement), à extraire des bases publiques et à tenir à jour.

## 2. Oui, on peut partir de cartes prêtes à l'emploi

| Source | Ce qu'elle apporte | Licence | Usage dans SIJAMAIS |
|---|---|---|---|
| **Protomaps** (OpenStreetMap) | Fond de carte vectoriel du monde, reconstruit chaque jour, au format PMTiles ; découpage d'un département en une commande (`pmtiles extract`) [FAIT] | ODbL : mention « © les contributeurs d'OpenStreetMap » obligatoire [FAIT] | **Fond de carte gratuit**, un fichier par département |
| **Plan IGN** | Fond cartographique officiel français | Licence Ouverte, réutilisation libre y compris commerciale [FAIT] | Fond « officiel », à étudier en option |
| **SCAN 25 IGN** (carte topographique au 1:25 000) | La carte de randonnée de référence | Licence distincte, pour un usage final professionnel ou associatif : **à vérifier** avant tout usage commercial [FAIT] | Premium randonnée, seulement si la licence le permet |
| **Géo'DAE** | Base nationale des défibrillateurs, mise à jour plusieurs fois par jour, en CSV et JSON [FAIT] | Données publiques ; licence de la base elle-même à confirmer [A VERIFIER] | Couche gratuite « Défibrillateurs » |
| OpenStreetMap | Hôpitaux, pompiers, pharmacies, points d'eau | ODbL | Couches gratuites |
| FINESS | Répertoire officiel des établissements de santé | Données publiques [A VERIFIER] | Hôpitaux avec urgences, plus fiables qu'OpenStreetMap |
| Géorisques | Zones inondables, risques par commune | Données publiques, licence à vérifier jeu par jeu | Couche « Risques » |
| Pack commune | Points de rassemblement, centres d'accueil | Fourni par la mairie | Couche « Ma commune » |

**À écarter :** Apple Plans et Google Maps (pas de hors ligne pour une application tierce), et les tuiles d'OpenStreetMap.org, interdites en usage massif dans une application.

## 3. Ce qu'il faut construire

| Étape | Contenu | Qui | Charge [EST] |
|---|---|---|---|
| A. Prototype | MapLibre dans l'application, fond Protomaps de la Loire-Atlantique embarqué, style lisible en clair et en sombre, polices et icônes embarquées, position GPS, couche des défibrillateurs | Claude (code), Benjamin (extraction du fichier sur son Mac) | 1 à 3 jours |
| B. Couches utiles | Hôpitaux, pompiers, défibrillateurs, pharmacies, points d'eau, avec fiche au toucher et bouton « Y aller » (ouvre Plans si le réseau existe) | Claude | 2 à 3 jours |
| C. Toute la France | Script qui produit les 101 fichiers départementaux et leurs couches, une fois par mois ; hébergement des fichiers ; téléchargement dans l'application (barre de progression, place occupée, mise à jour) | Claude et un hébergeur | 3 à 5 jours, plus quelques euros par mois d'hébergement [EST] |
| D. Risques et commune | Zones inondables de Géorisques ; points de rassemblement du pack commune | Claude, puis les mairies | 2 à 4 jours |
| E. Premium | France entière, fond topographique (Plan IGN, SCAN 25 si la licence le permet), traces de randonnée, itinéraires hors ligne | Développeur | À chiffrer : les itinéraires hors ligne sont lourds |

Taille d'un département en vectoriel : quelques dizaines à quelques centaines de mégaoctets selon la densité et le niveau de zoom [EST, à mesurer avec `pmtiles extract --dry-run`].

## 4. Points d'attention

- **Le hors ligne se gère soi-même.** MapLibre lit un fichier PMTiles local, mais ses « paquets hors ligne » intégrés ne fonctionnent pas avec ce format [FAIT, documentation MapLibre] : c'est l'application qui télécharge et range le fichier.
- **Les mentions obligatoires** (« © les contributeurs d'OpenStreetMap », IGN) doivent être visibles sur la carte.
- **L'ODbL** impose de partager sous la même licence une base de données dérivée qu'on diffuserait : à faire valider par l'avocat pour les couches combinées.
- **Fiabilité.** OpenStreetMap peut contenir des erreurs. Pour les urgences, les sources officielles (Géo'DAE, FINESS) priment, et la carte rappelle d'appeler le 15 ou le 112.

## 5. Sources

| Source | Apport |
|---|---|
| Forum développeurs Apple, « Offline Maps for App via MapKit ». https://developer.apple.com/forums/thread/765857 | Pas de cartes hors ligne MapKit pour les applications tierces |
| Protomaps, téléchargements. https://docs.protomaps.com/basemaps/downloads | Constructions quotidiennes, extraction, ODbL |
| Protomaps, prise en main. https://docs.protomaps.com/guide/getting-started | Commande `pmtiles extract` |
| MapLibre Native, exemple PMTiles. https://maplibre.org/maplibre-native/android/examples/data/PMTiles/ | Protocole `pmtiles://`, limite des paquets hors ligne |
| MapLibre Flutter, PMTiles. https://maplibre.org/flutter-maplibre-gl/advanced/pmtiles/ | Prise en charge native sur iOS |
| IGN, communiqué de juillet 2021. https://www.ign.fr/files/default/2021-07/CP_site-Geoservices.pdf | Gratuité, conditions du SCAN 25 |
| CGU des ressources du Géoportail. https://geoservices.ign.fr/ressources_documentaires/Espace_documentaire/CGU-ressourcesgeoportail.pdf | Licence du SCAN 25 |
| data.gouv.fr, Géo'DAE. https://www.data.gouv.fr/datasets/geodae-base-nationale-des-defibrillateurs | Défibrillateurs, mises à jour |
