# Maquette cliquable de l'application SIJAMAIS (version 0.1)

Fichier unique `index.html`, à ouvrir dans un navigateur (ordinateur ou iPhone). Aucune donnée réelle, aucun appel réseau.

## Ce qu'elle montre

| Écran | Contenu | Gratuit ou premium |
|---|---|---|
| Prise en main | 3 questions (pour quoi, où, foyer et assistant), puis téléchargement de la carte et des fiches | Gratuit |
| Accueil | Bouton Urgence, vigilance officielle, score de préparation, tâches de la semaine, accès rapides, batterie | Gratuit, bandeau premium discret |
| Urgence | 112, 15, 18, 17, 114, sirène et 6 réflexes, 10 scénarios de crise, premiers secours | Gratuit, pour toujours |
| Préparer | Kit de 72 heures du guide officiel adapté au foyer | Gratuit. Objectif 14 jours, péremption, code-barres et inventaire partagé en premium |
| Carte | Carte du département, hôpitaux, défibrillateurs, pompiers, points de rassemblement | Gratuit. France entière, topographie, itinéraires, traces en premium |
| Savoir | Sources officielles (SGDSN, PSC1, 6 réflexes, conseils aux voyageurs, DICRIM), import de PDF, journal des mises à jour | Gratuit. Encyclopédie et guides de loisir en premium |
| Famille | « Je suis en sécurité », plan du foyer, rendez-vous | Gratuit. Partage jusqu'à 5 personnes, carte et messagerie en offre Famille. Bluetooth : bientôt |
| Assistant | Réponse sourcée, renvoi systématique au 15 pour la santé | Gratuit pour la sécurité, premium pour le loisir |
| Ma commune | La Baule-Escoublac, **exemple fictif** | Gratuit pour l'habitant |
| Premium | « Tout ce qui protège est gratuit, pour toujours. » 3,99 € par mois ou 29,99 € par an ; Famille 5,99 € par mois ou 44,99 € par an ; essai 7 jours | |
| Réglages | Modes, thème, stockage, données personnelles, aide | |

Le panneau de gauche (sur ordinateur) permet de changer de thème, de simuler un abonné et de revoir la prise en main.

## Points à valider avant le développement

1. Les textes des fiches sont des exemples à aligner mot pour mot sur les sources officielles (voir `10_veille_officielle.md`).
2. Le logo est redessiné en SVG d'après la proposition « Le repère » : à remplacer par le fichier du graphiste.
3. L'identité visuelle reste provisoire : couleurs de la charte, police système de l'iPhone, aucun dégradé ni illustration générée.
4. Aucun contenu de la commune de La Baule-Escoublac n'a été validé par elle.

## Navigation

Les écrans sont reliés par de simples liens internes (`#e-accueil`, `#e-urgence`...). La maquette reste navigable même si la visionneuse n'exécute pas JavaScript. Le script ne gère que les compléments : messages de démonstration, cases à cocher, thème, simulation d'abonné, barres de téléchargement.

## Carte et PDF (18 novembre 2026)

- La carte de l'onglet Carte montre la presqu'île guérandaise et Saint-Nazaire. Les contours des communes viennent de l'IGN (Admin Express 2018, Licence Ouverte), via le projet france-geojson. Les positions des hôpitaux, centres de secours, défibrillateurs et points de rassemblement sont **indicatives** et placées à la main : elles ne doivent pas servir en situation réelle.
- `SIJAMAIS_maquette_0.2.pdf` : les 20 écrans, une couverture et la carte agrandie en annexe (22 pages A4). Les écrans longs sont présentés en deux colonnes.

## Version 0.2 : signalétique de sécurité (18 novembre 2026)

Direction A de `directions_visuelles.html`, validée par Benjamin. Tuiles de couleur unie et pictogrammes épais, dessinés à la main en SVG, sans image générée par IA :

| Couleur | Sens | Exemples |
|---|---|---|
| Rouge, croix blanche | Secours | Bouton Urgence, premiers secours, trousse |
| Jaune | Danger, alerte | Sirène, coupure, tempête, séisme, accident industriel |
| Orange | Chaleur, feu | Feu de forêt, canicule |
| Bleu | Eau, information | Inondation, eau potable, épidémie, assistant |
| Vert | Sécurité, évacuation | Défibrillateur, évacuation, « Je suis en sécurité », rendez-vous |
| Vert forêt | Préparation, commune | Kit de 72 heures, Ma commune |
| Gris | Premium et loisirs | Randonnée, mer, voyage, camping (photos à venir) |

Prochaine étape : remplacer les pictogrammes gris des loisirs par des photos libres de droits ou achetées, fournies par Benjamin.

## Guides de survie (25 novembre 2026)

Les 44 guides de `contenus/guides/guides_v1.1.json` sont intégrés : entrée « Guides de survie » dans l'onglet Savoir, un écran par catégorie, un écran par guide (badge « Consigne officielle » ou « Conseil pratique », sources, mention « à vérifier »). L'onglet Urgence renvoie vers les guides de premiers secours, des risques et des réflexes.

Pour mettre à jour la maquette après une modification des guides :

```
python3 outils/construire_guides_v11.py
python3 outils/integrer_guides_maquette.py
```
