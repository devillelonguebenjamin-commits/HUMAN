# Premium : randonnée, mer, voyage, et un Espace enfants

Rédigé le 27 novembre 2026. Objet : recenser les ressources à intégrer dans les trois modes premium (randonnée et montagne, navigation en mer, voyage à l'étranger) et étudier un Espace enfants destiné aux parents. Marqueurs : [FAIT] vérifié par recherche ce jour, [A VERIFIER] trouvé mais à confirmer sur la source ou auprès de l'organisme, [MEMOIRE] connu sans vérification ce jour.

Hypothèse de lecture : « navigation » est compris comme **navigation de plaisance en mer**, comme le mode « mer » de la maquette. L'orientation à pied (boussole, coordonnées) est traitée dans le mode randonnée.

## 1. Cadre déjà décidé

| Règle | Conséquence pour ces modes |
|---|---|
| Abonnement 3,99 € par mois ou 29,99 € par an, famille 5,99 € ou 44,99 € (JOURNAL, décision validée) | Le premium doit apporter un service continu : mises à jour des cartes et des bulletins, outils, contenus propres |
| Tout contenu issu d'une source publique reste gratuit, y compris dans les modes voyage, mer et montagne (`10_veille_officielle.md`) | Les consignes officielles ci-dessous sont **gratuites**. Le premium porte sur **nos outils et nos contenus propres** |
| Tout ce qui protège est gratuit (`09_application_iphone.md`) | Les numéros d'urgence du pays de séjour et l'écran « Alerter » de chaque mode restent gratuits |
| Aucune génération de texte sur la santé, citations obligatoires | Pas de conseil de vaccination personnalisé, pas de conduite à tenir inventée pour une morsure de vipère |

## 2. Randonnée et montagne

### 2.1 Ressources officielles (gratuites dans l'application)

| Ressource | Organisme | Ce qu'on en tire | Statut |
|---|---|---|---|
| Conseils randonnée pédestre, « Sortir en montagne », prévention été et hiver | Ministère des Sports | Préparer la sortie, matériel, eau et nourriture, orages et changements de temps, balisage et lecture de carte | [FAIT] [randonnée](https://www.sports.gouv.fr/randonnee-pedestre-9828), [sortir en montagne](https://www.sports.gouv.fr/sortir-en-montagne-1204), [été](https://sports.gouv.fr/prevention-montagne-ete) |
| Recommandations pour la randonnée en montagne l'été | FFRandonnée | Consignes de la fédération | [FAIT] [ffrandonnee.fr](https://www.ffrandonnee.fr/randonner/securite/recommandations-pour-la-randonnee-en-montagne-l-ete). Droit de reprise à demander, ce n'est pas une administration |
| Bons réflexes en montagne | Gendarmerie | Avant et pendant la sortie | [FAIT] [gendarmerie.interieur.gouv.fr](https://www.gendarmerie.interieur.gouv.fr/conseils/vie-pratique/activites-en-montagne-quels-sont-les-bons-reflexes-a-adopter) |
| Alerter : le 112 et rien d'autre | PGHM des Hautes-Alpes, FFME | Appeler directement un PGHM ou une CRS fait perdre du temps. Le 112 fonctionne téléphone verrouillé. Préparer : nom, lieu, nombre de victimes, blessures, météo. Économiser la batterie | [FAIT] [Petzl, article du PGHM](https://www.petzl.com/FR/fr/Professionnel/Actu/2024-1-5/Le-secours-en-montagne-en-France), [FFME](https://www.ffme.fr/wp-content/uploads/2019/06/alerter.pdf) |
| Localisation automatique à l'appel du 112 (AML) | FFRandonnée | Les limites de la géolocalisation, à expliquer honnêtement | [FAIT] [ffrandonnee.fr](https://www.ffrandonnee.fr/s-informer/actualites/les-limites-de-la-geolocalisation). Couverture actuelle [A VERIFIER] |
| Gratuité des secours en montagne | FFME, Cour des comptes (février 2026) | Gratuit en principe, « pas systématique dans tous les cas ». Ne jamais écrire « les secours sont gratuits » sans cette réserve | [FAIT] FFME ; conclusions du rapport 2026 [A VERIFIER] |
| Bulletin d'estimation du risque d'avalanche (BRA), 36 massifs | Météo-France | Téléchargement du bulletin du massif choisi avant de partir, lisible sans réseau. Format XML avec images, par l'API « DonneesPubliquesBRA » | [FAIT] [descriptif technique](https://donneespubliques.meteofrance.fr/client/document/descriptif_bulletinrisqueavalanche_formatxml_20231026_309.pdf), [data.gouv.fr](https://www.data.gouv.fr/datasets/bulletin-destimation-du-risque-davalanche). Données publiques de Météo-France gratuites depuis le 1er janvier 2024 [FAIT, [info.gouv.fr](https://www.info.gouv.fr/actualite/meteo-france-la-reutilisation-des-donnees-publiques-devient-gratuite)] ; conditions actuelles de l'API [A VERIFIER] |
| Vigilance météo en temps réel | Météo-France | Déjà prévue pour l'alerte ; utile aussi avant une sortie (orages) | [FAIT] [API Vigilance](https://www.data.gouv.fr/datasets/api-vigilance-meteorologique-en-temps-reel) |
| Tiques et maladie de Lyme | Santé publique France, ARS | Prévention, vérification après la sortie, délai d'apparition des signes (3 à 30 jours) | [FAIT] [santepubliquefrance.fr](https://www.santepubliquefrance.fr/maladies-et-traumatismes/maladies-a-transmission-vectorielle/borreliose-de-lyme/documents/depliant-flyer/maladie-de-lyme-et-prevention-des-piqures-de-tiques) |
| Morsure de vipère | ARS Auvergne-Rhône-Alpes | Aucune page de Santé publique France trouvée. Les conseils trouvés convergent (allonger, rassurer, 15 ou 112, noter l'heure) mais viennent de sites médicaux privés | [A VERIFIER] [ARS](https://www.auvergne-rhone-alpes.ars.sante.fr/morsure-de-serpents-comment-se-proteger). Brouillon à faire relire par un médecin ou le centre antipoison |

### 2.2 Cartes et tracés : ce qu'on peut embarquer

| Donnée | Droit de réutilisation | Décision proposée |
|---|---|---|
| Plan IGN et référentiels IGN | Licence Ouverte Etalab 2.0 depuis le 1er janvier 2021 | Fond de carte du premium. [FAIT, [CGU IGN](https://geoservices.ign.fr/ressources_documentaires/Espace_documentaire/CGU-ressourcesgeoportail.pdf)] |
| **SCAN 25** (le « Top 25 ») | **Exclu de la Licence Ouverte**, avec le SCAN 100 et le SCAN OACI. Licence propre, et conditions générales pour un usage numérique grand public | Pas de SCAN 25 au lancement. Demander un devis à l'IGN. WeTrek (ex-IGNrando) le réserve d'ailleurs à son abonnement. [FAIT] |
| Sentiers OpenStreetMap | ODbL : citer la source, partager à l'identique une base de données dérivée | Utilisable. La base dérivée doit pouvoir être republiée sous ODbL |
| Tracés des GR et GRP | La FFRandonnée revendique un droit d'auteur sur les tracés et la marque GR® est déposée. Non libérés sous ODbL en 2021, statut contesté | **Ne pas écrire « GR » dans l'application** et ne pas importer de tracés GR sans accord de la fédération. [FAIT, [wiki OSM](https://wiki.openstreetmap.org/wiki/Ffrp-lettre-ouverte)] |

### 2.3 Nos outils (premium)

1. **Fiche de sortie** : itinéraire, heure de retour prévue, participants, matériel. Elle prépare un message à envoyer à un proche avant de partir (le conseil « prévenir quelqu'un » des sources officielles, rendu concret).
2. **Compte à rebours du retour** : si l'heure est dépassée, l'application propose d'appeler le proche ou le 112. Aucun envoi automatique (risque de fausse alerte).
3. **Message d'alerte prêt à lire** : position en clair et en coordonnées, nombre de victimes, blessures, météo, dans l'ordre demandé par les secours. Partagé avec le mode mer (script MAYDAY).
4. **Bulletin avalanche et vigilance du massif**, téléchargés avec la carte.
5. **Sac selon la saison et la durée** : liste construite à partir des listes officielles, reliée à l'écran « S'équiper ».
6. **Boussole, coordonnées, altitude, économiseur de batterie** (mode avion, luminosité, rappel de garder 20 %).
7. **Traces enregistrées et carte France entière**, déjà prévues au palier E de `14_cartes_hors_ligne.md`.

**Concurrence.** Visorando Premium : environ 6 $ par mois ou 25 $ par an sur l'App Store américain (mai 2026), plus 18,99 $ par an pour les cartes IGN [FAIT, [App Pricing Lab](https://apppricinglab.com/iap/apple/969793415)]. WeTrek fait payer le Top 25 et le hors ligne illimité. Les deux sont plus forts que nous sur les bibliothèques de randonnées. **Ne pas se battre sur les tracés : se battre sur la sécurité** (fiche de sortie, alerte, avalanche, premiers secours), que ni l'un ni l'autre ne mettent au centre [A VERIFIER en testant les deux applications].

## 3. Navigation de plaisance en mer

### 3.1 Ressources officielles (gratuites)

| Ressource | Organisme | Ce qu'on en tire | Statut |
|---|---|---|---|
| Comment alerter les secours en mer | Ministère de la Mer | **VHF canal 16 en priorité** (lien direct avec le CROSS, localisation plus rapide). **196** depuis un téléphone, gratuit, 24 h sur 24, qui ne remplace pas la VHF. 112 depuis la plage | [FAIT] [mer.gouv.fr](https://mer.gouv.fr/comment-alerter-les-secours-en-mer), [la VHF](https://mer.gouv.fr/gestes-et-conseils-la-radio-vhf-un-outil-pour-ameliorer-sa-securite). Le 196 est encore marqué « à vérifier » dans le guide des numéros : cette page permet de le passer en vérifié |
| Plaisance et loisirs nautiques : les bons réflexes | Ministère de la Mer | Consignes générales | [FAIT] [mer.gouv.fr](https://mer.gouv.fr/plaisance-et-loisirs-nautiques-decouvrez-les-bons-gestes-adopter) |
| **Division 240** : matériel d'armement et de sécurité obligatoire | Ministère de la Mer | Matériel exigé selon la distance d'un abri : moins de 2 milles, 2 à 6, 6 à 60, plus de 60. **Modifiée par l'arrêté du 21 mai 2026** | [FAIT] [matériel et limites](https://www.mer.gouv.fr/le-materiel-darmement-et-de-securite-et-les-limites-dutilisation), [évolutions 2026](https://www.mer.gouv.fr/mise-jour-des-referentiels-techniques-de-la-plaisance-evolutions-des-divisions-240-et-241). Texte consolidé après mai 2026 [A VERIFIER] |
| Guide des loisirs nautiques en mer, édition 2026 | Ministère de la Mer | Brochure grand public, sécurité et environnement | [A VERIFIER] trouvée citée, version 2026 complète non lue |
| Sécurité en mer, fiche presse du 26 mai 2026 | Ministère de la Transition écologique | Baignade, zones surveillées, chiffres de la saison | [FAIT] [ecologie.gouv.fr](https://www.ecologie.gouv.fr/sites/default/files/documents/2026.05.26.Fiche%20presse_S%C3%A9curit%C3%A9%20en%20mer.pdf) |
| Messages MAYDAY et PAN PAN | Livret SNSM et AXA | MAYDAY : détresse avec danger de mort ; PAN PAN : urgence sans danger de mort immédiat | [FAIT] [livret](https://passion.axa.fr/contents/univers-plaisance/livret-plaisance-prevention.pdf). Reprise mot pour mot : accord de la SNSM nécessaire |
| Météo marine | Météo-France | Données gratuites depuis 2024 ; observations en mer (bouées, navires) sous Licence Ouverte | Bulletins côtiers et bulletins météo spéciaux par API [A VERIFIER] |

### 3.2 Ce qu'on ne peut pas embarquer simplement

| Donnée | Problème | Décision proposée |
|---|---|---|
| **Prédictions de marée du Shom** | Licence spécifique et payante, distincte de la licence non commerciale [FAIT, [répertoire 2026 du Shom](https://diffusion.shom.fr/media/wysiwyg/licence/Document_RIP_2026-VF.pdf)] | Pas de marées au lancement. Demander un devis au Shom. Les surcotes du Shom sont, elles, sous Licence Ouverte |
| Cartes marines | Données du Shom, mêmes contraintes | Hors périmètre. **SIJAMAIS n'est pas un outil de navigation** et doit l'écrire. Responsabilité sans faute étendue aux logiciels à partir du 9 décembre 2026 (S61) |

### 3.3 Nos outils (premium)

1. **« Mon bateau »** : longueur, type, zone de navigation habituelle. L'application en tire la liste de la Division 240 qui s'applique, à cocher, avec les dates de péremption (fusées, extincteurs, gilets). La réglementation elle-même reste consultable gratuitement.
2. **Script MAYDAY prérempli** : nom du bateau, indicatif, nombre de personnes, position mise à jour, à lire à voix haute sur le canal 16. Bouton 196 en dessous.
3. **Plan de navigation laissé à terre** : même principe que la fiche de sortie en randonnée.
4. **Homme à la mer** : fiche et chronomètre, position marquée d'un geste.
5. **Baignade en famille** : drapeaux de plage, courants, enfants ; contenu partagé avec l'Espace enfants.

**Taille du marché** : plus petite que la randonnée, et le contenu est plus lourd juridiquement (Division 240 qui change, Shom, SNSM). À traiter en dernier.

## 4. Voyage à l'étranger

### 4.1 Ressources officielles

| Ressource | Organisme | Ce qu'on en tire | Statut |
|---|---|---|---|
| Conseils aux voyageurs, par pays | Ministère de l'Europe et des Affaires étrangères | Sécurité par pays, carte des zones | [FAIT] [diplomatie.gouv.fr](https://www.diplomatie.gouv.fr/fr/conseils-aux-voyageurs). **Aucun jeu de données sous licence ouverte trouvé.** Le ministère dit lui-même que son fichier .xls ne répond pas aux critères de l'open data [FAIT, [data.gouv.fr](https://www.data.gouv.fr/datasets/647f3dec91a13a775b028aaa)] |
| Ariane, inscription des voyageurs | Même ministère | Le seul moyen d'être prévenu et localisé par le centre de crise | [FAIT] [dépliant 2023](https://www.diplomatie.gouv.fr/IMG/pdf/flyer_a5_cav-ariane_2023_v2_cle02a89e.pdf). Lien et rappel avant le départ, rien d'autre |
| **Ambassades de France dans le monde** | Même ministère | Adresses et coordonnées géographiques, consultables sans réseau | [FAIT] Licence Ouverte 2.0, mise à jour d'avril 2024 [data.gouv.fr](https://data.gouv.fr/en/datasets/ambassades-de-france-dans-le-monde-1). Données de plus de deux ans : à recouper |
| Recommandations sanitaires aux voyageurs 2026 | Haut Conseil de la santé publique, ministère de la Santé | Écrites pour les professionnels de santé (juillet 2026) | [FAIT] [sante.fr](https://www.sante.fr/node/7327843). **On ne les reprend pas en conseil** : on dit « consultez votre médecin ou un centre de vaccinations internationales avant le départ » |
| Carte européenne d'assurance maladie | Assurance maladie | À commander avant un séjour dans l'Union européenne | [MEMOIRE] |
| Numéros d'urgence dans l'Union : 112 | Commission européenne | Le 112 fonctionne dans toute l'Union | [FAIT] [Your Europe](https://europa.eu/youreurope/citizens/travel/security-and-emergencies/emergency/indexamp_fr.htm) |

**Conseils aux voyageurs : comment faire.** L'article L. 321-1 du code des relations entre le public et l'administration permet en principe de réutiliser une information publique, mais le ministère ne la publie pas dans un format réutilisable, et un conseil de sécurité recopié puis périmé est dangereux. Proposition : **ne pas recopier**. Télécharger la page du pays au moment où l'utilisateur prépare son voyage, l'afficher datée, et inviter à la mettre à jour. Écrire au centre de crise et de soutien pour demander l'accord et un format.

### 4.2 Ressources libres

| Ressource | Licence | Usage |
|---|---|---|
| Guides de conversation de Wikivoyage | CC BY-SA 4.0 : citer les auteurs, partager à l'identique les contenus dérivés ; images à vérifier une par une [FAIT, [page de réutilisation](https://en.wikivoyage.org/wiki/Wikivoyage:List_of_phrasebooks)] | Phrases utiles, à garder dans un module séparé et crédité pour isoler le partage à l'identique |
| Numéros d'urgence par pays | **Aucune source officielle et ouverte trouvée.** Le tableau de Microsoft contient des erreurs visibles | Construire notre propre fichier, vérifié pays par pays sur les sites nationaux, daté. Gratuit, car il protège |

### 4.3 Nos outils (premium)

1. **Cartes « montrer à quelqu'un »** : phrases d'urgence affichées en grand dans la langue locale (« J'ai besoin d'un médecin », « Appelez une ambulance », « Je suis allergique à… »), à tendre à un passant. Traductions faites par des traducteurs et relues, pas par une machine.
2. **Dossier de voyage hors ligne** : copies du passeport et de l'assurance, numéro d'assistance, adresse de l'ambassade. Stocké seulement sur le téléphone, protégé par Face ID. Jamais sur nos serveurs.
3. **Liste de départ** : Ariane, carte européenne d'assurance maladie, rendez-vous médical, prises électriques, médicaments et ordonnances.
4. **Carte de la ville hors ligne** (OpenStreetMap) avec ambassade, hôpitaux et pharmacies.

## 5. Espace enfants

### 5.1 Pourquoi c'est une bonne idée

- **Le parent achète, l'enfant utilise.** C'est l'argument qui manque à la version famille (5,99 € ou 44,99 €) : un parent ne paie pas pour lui une deuxième fois, il paie pour que son enfant ait l'application. Avec le Partage familial d'Apple, un abonnement peut être partagé avec les enfants du foyer [MEMOIRE, à confirmer dans la documentation StoreKit].
- **L'école prépare déjà le terrain.** « Apprendre à porter secours » est enseigné de la maternelle à 10 ans, puis les « Gestes qui sauvent » au collège (deux heures, PSC1 proposé) [FAIT, [eduscol](https://eduscol.education.gouv.fr/6986/sensibilisation-aux-gestes-qui-sauvent-et-formation-aux-premiers-secours)]. Le plan particulier de mise en sûreté (PPMS) est unifié depuis la circulaire du 8 juin 2023 et les élèves s'exercent chaque année à la mise à l'abri et à l'évacuation [FAIT, [eduscol](https://eduscol.education.gouv.fr/4782/assurer-la-securite-des-ecoles-et-des-etablissements)]. **Reprendre le vocabulaire de l'école** : l'enfant reconnaît ce qu'il a appris, et le parent voit une application sérieuse.
- **Peu de concurrence visible.** Une recherche n'a trouvé aucune application ludique en français pour apprendre aux enfants à alerter. Signal faible, à confirmer en fouillant l'App Store.
- **Argument pour les mairies** : la commune distribue déjà le DICRIM ; un parcours enfants peut s'utiliser en classe.

### 5.2 Contenu proposé (deux tranches d'âge)

| | 6 à 10 ans (avec un parent) | 10 à 14 ans (seul sur son iPhone) |
|---|---|---|
| Alerter | Apprendre le 112, le 15, le 17 et le 18 en jouant. Savoir dire son nom, son adresse, ce qui se passe | Idem, plus : un téléphone verrouillé peut appeler les secours ; le 114 par SMS pour les enfants sourds ou malentendants |
| Se protéger | Les postures du PPMS, avec les mots de l'école | Que faire seul à la maison : coupure de courant, orage, odeur de gaz, inondation, alerte FR-Alert |
| Premiers gestes | Mettre quelqu'un sur le côté, appuyer sur ce qui saigne (repris d'« Apprendre à porter secours ») | Les « Gestes qui sauvent » ; renvoi vers une session PSC1 |
| Se perdre | « Je suis perdu » : à qui demander de l'aide | Carte « Montrer à un adulte » : nom de l'enfant, téléphone des parents, allergies |
| Peurs | Orage, tonnerre, coupure, sirènes : expliquer sans faire peur | Rumeurs et fausses alertes sur les réseaux |
| Écoute | | 119 (enfance en danger) [MEMOIRE], 3018 (cyberharcèlement) [FAIT, [solidarites.gouv.fr](https://www.solidarites.gouv.fr/agressions-cyberharcelement-violences-si-tu-besoin-daide-des-numeros-existent)] |

Format : mises en situation courtes avec des illustrations dessinées (pas de photos d'accident, pas d'image générée), quiz sans chronomètre ni score humiliant, un badge par module terminé. Le parent voit ce qui a été fait.

### 5.3 Règles à respecter

1. **Ne pas classer l'application dans la catégorie « Enfants » de l'App Store.** Cette catégorie impose ses règles à toute l'application, et pour toujours dans les mises à jour, même si on la quitte [FAIT, [règles d'Apple](https://developer.apple.com/app-store/review/guidelines/)]. Un profil enfant dans une application générale suffit, à condition de respecter quand même l'esprit des règles 1.3 et 5.1.4.
2. **Dans l'Espace enfants : aucun lien Amazon, aucun achat, aucun lien vers l'extérieur, aucune statistique d'usage.** Sortir de l'espace demande un contrôle parental (Apple recommande ces « parental gates » [FAIT, [developer.apple.com](https://developer.apple.com/app-store/parental-gates/)]).
3. **Pas d'assistant libre pour les enfants** : boutons et parcours écrits à l'avance seulement. Le triage actuel n'a pas été testé sur un vocabulaire d'enfant.
4. **Aucun compte, aucune donnée envoyée.** Sous 15 ans, un traitement fondé sur le consentement exige celui d'un parent avec celui de l'enfant [FAIT, [CNIL, recommandation 4](https://cnil.fr/fr/node/319)]. Si tout reste sur le téléphone, la question ne se pose presque pas. La carte « Montrer à un adulte » contient des données de santé de l'enfant : stockage local et chiffré seulement.
5. **Âge** : l'interface « Declared Age Range » d'iOS 26 permet de connaître la tranche d'âge sans la date de naissance, et les parents du Partage familial décident du partage [FAIT, [Apple](https://developer.apple.com/support/age-assurance)]. Elle sert à proposer le bon parcours, pas à vérifier.
6. **Relecture** par un enseignant du primaire et par un formateur PSC1, en plus du médecin déjà prévu.

### 5.4 Gratuit ou premium ?

- **Gratuit** : l'écran « J'ai besoin d'aide » de l'enfant (gros boutons : appeler un parent, appeler le 112, « je suis perdu »). Il protège.
- **Version famille** : les parcours et les jeux, plusieurs profils d'enfants, le suivi par le parent.

## 6. Ordre proposé

| Rang | Mode | Pourquoi |
|---|---|---|
| 1 | **Espace enfants** | Ce qui différencie le plus SIJAMAIS de HAVEN, ce qui donne une raison d'acheter la version famille, et la donnée la plus simple juridiquement (contenus écrits par nous) |
| 2 | **Randonnée et montagne** | Le plus grand public, le meilleur angle publicitaire autorisé (`04_legal.md`), données ouvertes (Plan IGN, bulletin avalanche) |
| 3 | **Voyage** | Ambassades ouvertes, mais les conseils aux voyageurs demandent un accord du ministère |
| 4 | **Mer** | Public plus petit, réglementation qui vient de changer, marées payantes |

## 7. Démarches à lancer

| Organisme | Demande |
|---|---|
| IGN | Devis et conditions du SCAN 25 pour une application grand public payante |
| Shom | Devis pour les prédictions de marée dans une application |
| Centre de crise et de soutien du ministère des Affaires étrangères | Accord et format pour les conseils aux voyageurs |
| FFRandonnée | Droit de reprendre ses recommandations ; position sur les tracés |
| SNSM | Droit de reprendre les procédures MAYDAY et PAN PAN |
| Météo-France | Conditions actuelles de l'API du bulletin avalanche et des bulletins marins |
| Un enseignant du primaire | Relecture des parcours enfants |
