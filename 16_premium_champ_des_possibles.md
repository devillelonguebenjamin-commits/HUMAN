# Premium : explorer le champ des possibles

Rédigé le 27 novembre 2026 à la demande de Benjamin : « que les gens en aient pour leur argent », beaucoup de contenu, des ponts avec d'autres applications. Marqueurs : [FAIT] vérifié ce jour (lien), [A VERIFIER] trouvé mais à confirmer, [MEMOIRE] connu sans vérification ce jour.

## 1. Le test qui guide tout

Un abonnement est payé chaque mois : il doit rendre **un service qui continue**, que la version gratuite ne peut pas imiter. Trois familles de valeur passent ce test :

| Famille | Exemple | Pourquoi ça vaut un abonnement |
|---|---|---|
| **Données qui se renouvellent** | Bulletin avalanche du jour, refuges ouverts, vigilance, qualité de l'eau | Le gratuit donne la consigne ; le premium donne l'information du jour, téléchargée et lisible sans réseau |
| **Outils qui travaillent pour moi** | Fiche de sortie, compte à rebours, trace GPX analysée, temps de marche estimé, rappel sur la montre | Gagner du temps et de la sérénité à chaque sortie |
| **Contenu propre et profond** | Modules enfants, fiches par massif, phrases d'urgence traduites | Ce que personne d'autre ne propose en français, relu |

Règle inchangée : **tout ce qui protège reste gratuit** (alerter, consignes officielles, numéros, « J'ai besoin d'aide »).

## 2. Ce que disent les autres applications (vérifié)

| Service | Pont possible | Constat |
|---|---|---|
| Komoot | API réservée aux partenaires sous contrat, avec un droit d'envoi de tours vers le compte de l'utilisateur | [FAIT, [documentation v007](https://static.komoot.de/doc/external-api/v007/index.html)]. Demande de partenariat : partner@komoot.de |
| Strava | API restreinte depuis novembre 2024 : données montrées seulement à la personne, aucun usage par une IA, design distinct | [FAIT, [Cycling News](https://www.cyclingnews.com/news/strava-plan-to-restrict-third-party-apps-has-users-in-an-uproar), [DC Rainmaker](https://dcrainmaker.com/2024/11/stravas-changes-to-kill-off-apps.html)]. Peu d'intérêt pour nous |
| Visorando | Aucune API publique ; export et import GPX manuels | [FAIT, [support Visorando](https://support.visorando.com/en/my-account/uploading-or-downloading-a-gpx-file)] |
| Garmin | « Courses API » : publier un parcours sur Garmin Connect, puis sur la montre ; accès gratuit pour les développeurs professionnels approuvés | [FAIT, [Garmin](https://developer.garmin.com/gc-developer-program/courses-api/)]. Demande à faire une fois l'entreprise créée |
| Apple Watch (WorkoutKit) | Envoyer un entraînement planifié vers l'app Exercice de la montre | [FAIT, [Apple](https://developer.apple.com/documentation/workoutkit/workoutplan.md)]. Pensé pour l'entraînement, pas pour un tracé ; problèmes de synchronisation signalés en 2024 et 2025 |
| Live Activities (ActivityKit) | Compte à rebours du retour sur l'écran verrouillé et dans la Dynamic Island, dessiné par le système | [FAIT, [Apple](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities.md)] |

**Conclusion : le pont universel est le fichier GPX.** Komoot, Visorando, Strava, Garmin, IGN et les montres l'exportent et l'importent. Le premium ouvre une trace venue de n'importe où, l'analyse, l'attache à la fiche de sortie, et la renvoie vers la montre ou une autre application.

## 3. Données ouvertes à exploiter (vérifiées)

| Source | Contenu | Licence | Usage premium |
|---|---|---|---|
| Refuges.info | Refuges, cabanes, points d'eau, avec une API | CC BY-SA (version 2.0 citée dans l'API) ; les données OpenStreetMap restent en ODbL [FAIT, [licence](https://www.refuges.info/wiki/licence), [API](https://www.refuges.info/api/doc/)] | Refuges et points d'eau du massif, téléchargés pour le hors ligne, crédités |
| Geotrek (parcs nationaux et régionaux) | Itinéraires officiels, points d'intérêt, API par parc | Souvent Licence Ouverte 2.0, à vérifier jeu par jeu [FAIT, [Écrins sur data.gouv.fr](https://www.data.gouv.fr/datasets/5bf88cf28b4c4151e7a136d2)] | Itinéraires des parcs, avec la réglementation (chiens, bivouac) |
| Météo-France, bulletin avalanche | XML par massif, validité en général jusqu'au lendemain 18 h, par l'API « DonneesPubliquesBRA » avec authentification sur le portail | Données publiques [FAIT, [fiche technique](https://donneespubliques.meteofrance.fr/client/document/descriptif_bulletinrisqueavalanche_formatxml_20231026_309.pdf)] ; gratuité de la clé [A VERIFIER] | Bulletin du massif choisi, téléchargé avant de partir |
| Météo-France, vigilance | API en temps réel | [FAIT, [data.gouv.fr](https://www.data.gouv.fr/datasets/api-vigilance-meteorologique-en-temps-reel)] | Gratuit (protège) ; le premium ajoute l'alerte sur la zone de la sortie |
| Hub'Eau | Qualité de l'eau potable par commune ; hydrométrie (Vigicrues) | Service public eaufrance ; licence exacte [A VERIFIER] [FAIT, [eau potable](https://www.data.gouv.fr/dataservices/hubeau-qualite-de-leau-potable), [hydrométrie](https://www.data.gouv.fr/dataservices/hubeau-hydrometrie)] | Hauteur des rivières près d'un bivouac ; eau potable de la commune |
| Camptocamp | Itinéraires de montagne, sorties | Contenu CC BY-SA 3.0 ; licence de l'API [A VERIFIER] [FAIT, [aide Camptocamp](https://www.camptocamp.org/articles/106920/en/help-guidebook)] | Itinéraires alpins, à étudier |

## 4. Le catalogue premium proposé

### 4.1 Randonnée et montagne (le cœur de l'offre)

| Fonction | Valeur | Dépendance | Statut |
|---|---|---|---|
| **Pont GPX** : ouvrir une trace (Komoot, Visorando, Strava, Garmin, montre), distance, dénivelé, altitudes, profil, temps de marche estimé, renvoi vers une autre application | Le service le plus utile à chaque sortie | Aucune | **Construit le 27/11/2026** |
| Attacher la trace à la fiche de sortie (itinéraire et heure de retour calculés) | Le proche sait exactement où chercher | Aucune | **Construit** |
| Mes traces enregistrées, sur le téléphone | Bibliothèque personnelle | Aucune | **Construit** |
| Trace affichée sur la carte hors ligne | Voir où l'on est par rapport à la trace | Fond de carte de la région concernée (palier E pour toute la France) | **Construit le 27/11/2026** |
| Compte à rebours sur l'écran verrouillé (Live Activity) | Rappel visible sans ouvrir l'application | Extension de widget | **Construit le 27/11/2026** |
| Refuges et points d'eau du massif hors ligne | Savoir où dormir et boire | Refuges.info (CC BY-SA, crédit et partage à l'identique) | À faire |
| Bulletin avalanche du massif hors ligne | L'information du jour, l'hiver | Clé Météo-France | À faire (compte portail à créer) |
| Itinéraires des parcs nationaux | Randonnées officielles et réglementation | Geotrek, licence par parc | À faire |
| Envoi du parcours vers une montre Garmin | Pont direct | Accord Garmin | Après la création de l'entreprise |
| Partenariat Komoot | Import direct depuis le compte | Contrat | À demander |

### 4.2 Voyage

Phrases d'urgence à montrer, dans 10 langues, relues par des traducteurs ; dossier de voyage hors ligne protégé par Face ID ; ambassades de France en données ouvertes ; liste de départ (Ariane, carte européenne d'assurance maladie, médecin) ; numéros d'urgence par pays vérifiés un par un.

### 4.3 Mer

« Mon bateau » et le matériel obligatoire de la Division 240 avec les dates de péremption ; message MAYDAY prérempli ; homme à la mer avec chronomètre et position ; plan de navigation laissé à terre.

### 4.4 Famille et foyer (transversal)

| Fonction | Valeur |
|---|---|
| Plusieurs profils d'enfants et suivi par le parent | Raison d'acheter la version famille |
| Péremption des stocks et du kit : rappel avant la date | Service continu, chaque mois |
| Plan familial partagé avec les proches (fichier chiffré) | Toute la famille a le même plan |
| Exercice familial guidé : « ce soir, coupure de courant simulée » | Préparer en jouant, une fois par trimestre |
| Alerte de vigilance sur les communes des proches | Veiller sur ses parents âgés |

### 4.5 Raccourcis et Siri (App Intents)

« Dis Siri, je pars en randonnée » (ouvre la fiche), « Dis Siri, je suis rentré » (arrête le compte à rebours), « Dis Siri, ma position » (coordonnées lues). Gratuit pour ce qui protège, premium pour le reste.

## 5. Ordre de construction proposé

1. **Pont GPX** et trace attachée à la fiche de sortie. Fait le 27/11/2026.
2. Trace sur la carte hors ligne, et compte à rebours sur l'écran verrouillé.
3. Refuges et points d'eau hors ligne (Refuges.info), avec crédit visible.
4. Bulletin avalanche (après création du compte sur le portail de Météo-France).
5. Rappels de péremption des stocks, et plusieurs profils d'enfants.
6. Voyage, puis Mer.

## 6. Avocat du diable

- **Le GPX n'est pas un argument marketing**, c'est une commodité : Visorando et WeTrek le font. Notre différence est ailleurs : la trace devient une **fiche de sortie** qu'un proche comprend, avec un compte à rebours et un message d'alerte prêt. C'est la sécurité, pas la navigation.
- **CC BY-SA (Refuges.info) impose le partage à l'identique** des données modifiées : garder ces données dans un module séparé et crédité, ne pas les mélanger à nos contenus propres.
- **Ne pas promettre la navigation** : SIJAMAIS n'est pas un GPS de randonnée. Le temps de marche est une estimation, à écrire comme telle.
- **Le plus gros risque reste le volume** : un premium riche demande des mises à jour de données régulières. Chaque source ajoutée est un engagement de maintenance.
