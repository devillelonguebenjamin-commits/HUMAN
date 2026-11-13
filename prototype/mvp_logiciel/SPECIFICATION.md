# Spécification technique du MVP : application iPhone MECUM

Version 0.2 du 13 novembre 2026. Elle remplace la version 0.1 (application Android). Base des demandes de devis aux développeurs iOS. Raisonnement et chiffres dans `09_application_iphone.md`. La maquette du moteur de recherche (`recherche.py`, `tests_recherche.py`, `fiches/`) reste valable : sa logique se porte telle quelle sur iPhone.

## 1. Objet

Une application iPhone qui donne accès, sans réseau, à des savoirs utiles en français : fiches réflexes signées et datées, préparation du foyer, cartes, bibliothèque, assistant qui cite ses sources. Gratuite pour tout ce qui protège, avec une version complète en achat unique.

Finalité déclarée : information générale et éducation. L'application n'est pas un dispositif médical, ne pose pas de diagnostic et ne remplace ni les secours ni un professionnel de santé.

Hors périmètre de la v1 : Android, iPad optimisé (l'application doit fonctionner sur iPad mais sans mise en page dédiée), veille en ligne, maillage Bluetooth, identification par photo, comptes utilisateurs.

## 2. Plateforme et choix techniques

| Sujet | Choix | Raison |
|---|---|---|
| Langage et interface | Swift, SwiftUI | Natif, accès au modèle local d'Apple, meilleure tenue hors ligne |
| Système minimal | iOS 17 pour l'application, iOS 26 pour l'assistant | Couvrir les iPhone de 5 ans tout en profitant du modèle local récent |
| Assistant | Cadre "Foundation Models" d'Apple, sur iPhone 15 Pro et suivants avec Apple Intelligence | Gratuit, en français, aucun modèle à télécharger. Sur les autres iPhone : recherche seulement |
| Recherche | SQLite avec recherche plein texte (FTS5), index livré avec l'application | Logique du prototype |
| Cartes | MapLibre Native pour iOS, fichiers vectoriels PMTiles produits à partir d'OpenStreetMap | Licences permissives, carte par département |
| Encyclopédie | Base SQLite construite par nos soins à partir de Wikipédia, Vikidia et Wikilivres en français (CC BY-SA) | Eviter d'embarquer une bibliothèque sous licence GPL. A confirmer avec l'avocat |
| Achats | StoreKit 2, achat unique non consommable, partage familial activé pour la version famille | Standard Apple |
| Téléchargements | Stockage objet sans frais de sortie (ou ressources hébergées par Apple), reprise après coupure | Cartes et compléments de plusieurs centaines de mégaoctets |
| Données personnelles | Aucun compte, aucune collecte, aucun traceur. Mesure d'usage agrégée d'Apple seulement | Argument de confiance, conformité simple |

## 3. Parcours de première ouverture (exigence principale)

Inspiré de ce que Benjamin a apprécié dans HAVEN : être opérationnel en deux minutes sans connaître l'application.

| Etape | Question ou action | Effet |
|---|---|---|
| 1 | "Pour quoi voulez-vous MECUM ?" : maison, randonnée, mer, route, famille (plusieurs choix) | Choix des fiches mises en avant et de l'ordre de l'accueil |
| 2 | "Où vivez-vous ?" : département, proposé depuis la position si autorisée | Téléchargement de la carte du département et des risques locaux |
| 3 | "Votre foyer ?" : nombre de personnes, enfants, personnes âgées, animaux | Kit de 72 heures et plan du foyer adaptés |
| 4 | Téléchargement en arrière-plan avec barre de progression, l'application reste utilisable | Carte prête en quelques minutes en Wi-Fi |
| 5 | Si le téléphone est compatible : "Activer l'assistant ?" | Vérification de la disponibilité d'Apple Intelligence, explication de ses limites |
| 6 | Proposition de la version complète, une seule fois, sans insistance | Pas de fenêtre de vente répétée |

Critère d'acceptation : 9 personnes non techniciennes sur 10 terminent le parcours sans aide, en moins de 3 minutes hors téléchargement.

## 4. Fonctions

### Gratuit

| N° | Fonction | Critère d'acceptation |
|---|---|---|
| F1 | Accueil : Urgence, Chercher, Préparer, Carte | Quatre entrées, lisibles en situation de stress, deux touches au plus pour toute fiche vitale |
| F2 | Urgence : numéros (112, 15, 18, 17, 114), position en clair, lampe, signal lumineux SOS, fiches vitales | Fonctionne en mode avion |
| F3 | Fiches réflexes de sécurité, signées, datées, sourcées | Une fiche non relue n'est jamais livrée |
| F4 | Recherche dans les fiches (niveau 1) et traitement des sujets sensibles (niveau 3) | 95 % de bonnes fiches en premier sur le jeu de 100 questions, 100 % de détection des sujets sensibles |
| F5 | Kit de 72 heures selon le guide officiel, plan du foyer, score de préparation | Etat conservé hors ligne, rappel semestriel |
| F6 | Carte du département hors ligne : position, défibrillateurs, points d'eau, secours, abris | Position affichée sans réseau |
| F7 | Bibliothèque courte et import de documents personnels (PDF) | |
| F8 | Widget et raccourcis vers Urgence et la lampe | |

### Version complète (achat unique)

| N° | Fonction |
|---|---|
| F9 | Fiches d'approfondissement : autonomie, randonnée, mer, cuisine sans courant, réparations, jardin |
| F10 | Inventaire complet, dates de péremption, objectif 14 jours, plusieurs foyers |
| F11 | Cartes de France entière, relief, enregistrement de traces |
| F12 | Encyclopédie complète en français, rayon enfants par niveau |
| F13 | Recherche dans toute la bibliothèque, puis assistant à réponses citées (niveau 2) sur les iPhone compatibles |
| F14 | Version famille : partage familial Apple |

### Plus tard

| Fonction | Condition |
|---|---|
| Module communes : plan de sauvegarde de la commune, disponible hors ligne pour ses habitants | Intérêt confirmé par les rendez-vous en mairie |
| Android | Demande mesurée sur la page de test, revenus de l'année 1 |
| Abonnement de service (mises à jour des cartes et du corpus, synchronisation familiale) | Année 2, jamais sur un contenu de sécurité |

## 5. Assistant : règles

1. Il ne répond qu'à partir des passages retrouvés dans le corpus et affiche ses sources.
2. S'il ne trouve rien, il le dit.
3. Il ne génère jamais rien sur la santé, les médicaments, les plantes et champignons, l'électricité : renvoi vers la fiche validée et rappel du 15 et du 112.
4. Il signale toujours qu'il est une IA et peut se tromper.
5. Il n'est proposé que si le modèle d'Apple est disponible sur le téléphone. Aucun modèle de remplacement embarqué en v1.

## 6. Contenus

Format des fiches inchangé (voir `fiches/eau-potable.md`). Objectif v1 : 60 fiches, dont 30 gratuites de sécurité relues par un formateur de secourisme et un médecin. Les risques, numéros, règles et saisons sont ceux de la France.

## 7. Identité visuelle

Exigence de Benjamin : ne pas ressembler à un produit généré par IA. Conséquences pour le développeur :

- aucune illustration générée par IA dans l'application ni sur l'App Store ;
- une charte graphique fournie par un graphiste avant la version de production (couleurs, typographie, pictogrammes, captures d'App Store) ;
- photographies et vidéos réelles pour l'App Store et les réseaux ;
- en attendant, une interface sobre fondée sur les composants standard d'Apple, facile à habiller ensuite.

## 8. Exigences non fonctionnelles

| Exigence | Cible |
|---|---|
| Hors ligne | 100 % des fonctions gratuites après le parcours d'accueil |
| Taille de l'application téléchargée | Moins de 150 Mo, contenus lourds téléchargés ensuite |
| Démarrage | Moins de 2 secondes |
| Recherche | Moins de 0,5 seconde |
| Accessibilité | Taille de texte dynamique, contraste élevé, VoiceOver |
| Stabilité | Aucun plantage sur l'assistant : vérification de la mémoire et de la disponibilité avant chaque réponse |
| Garantie | Mises à jour correctives pendant 2 ans au moins |

## 9. Lots et estimation

| Lot | Contenu | Charge | Coût externe estimé |
|---|---|---|---|
| 0 | "MVP zéro" : démonstration avec Kiwix, Organic Maps et l'assistant d'Apple sur un iPhone de test, plus le prototype de recherche | 3 jours du fondateur | 550 € (iPhone d'occasion) |
| 1 | Application v1 gratuite et version complète (F1 à F14 sauf F13 assistant) | 8 à 10 semaines de développeur iOS indépendant, à temps partiel | 6 000 à 8 000 € |
| 2 | Corpus : 60 fiches, base encyclopédique, cartes par département | 6 semaines du fondateur | 1 200 € de relecture |
| 3 | Assistant (F13), module communes | 4 à 6 semaines | 3 000 à 4 000 € |
| Annexe | Mac pour compiler et publier (si nécessaire), compte développeur | | 800 € et 99 € par an |

A confirmer par deux devis.

## 10. Questions aux développeurs consultés

1. Avez-vous publié une application iOS qui fonctionne entièrement hors ligne ? Laquelle ?
2. Avez-vous utilisé le cadre Foundation Models d'Apple ? Sur quels appareils ?
3. Comment gérez-vous les téléchargements de plusieurs centaines de mégaoctets avec reprise ?
4. MapLibre et fichiers PMTiles hors ligne : l'avez-vous déjà fait ?
5. Acceptez-vous que le code nous appartienne entièrement, et à quel forfait pour la maintenance mensuelle ?
