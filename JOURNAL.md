# JOURNAL DU PROJET HUMAN

Journal tenu par le cofondateur opérationnel (IA). Il trace les décisions, les changements de cap, les hypothèses structurantes et les questions ouvertes. Les sources détaillées sont dans `sources.md`, les hypothèses dans `registre_hypotheses.md`.

Convention de statut des affirmations dans tous les documents :

| Marqueur | Signification |
|---|---|
| [FAIT] | Fait vérifié, source citée dans `sources.md` |
| [EST] | Estimation calculée à partir de faits, méthode explicitée |
| [HYP] | Hypothèse de travail, inscrite au registre |
| [INT] | Intuition d'opérateur, non étayée, à tester |

## 2026-11-12 : Lancement de la phase 1

**Mandat.** Benjamin de Villelongue (fondateur, CEO) demande une exploration complète de la thèse "smartphone durci minimaliste à forte autonomie avec IA locale hors ligne et base de connaissances de survie", pour une décision go / no-go / pivot sous 1 à 2 semaines. Budget initial 10 000 €, fonds propres jusqu'à 40 000 €.

**Décisions d'organisation.**

1. Le dépôt git `HUMAN` est le dossier de projet. Les livrables sont à la racine, les prototypes dans `prototype/`, les scripts dans `outils/`.
2. Ordre d'exécution : les 7 étapes du brief, dans l'ordre. La recherche web précède toute rédaction. Les documents sont rédigés une fois le socle factuel réuni, pour éviter les contradictions entre documents.
3. Aucune question bloquante n'est posée pendant le travail. Les manques sont comblés par des hypothèses explicites, consignées au registre.
4. Aucune dépense n'est engagée pendant cette phase (pas d'achat de nom de domaine, pas de recherche de marque payante, pas de publicité). Les vérifications de disponibilité sont faites avec des outils gratuits et signalées comme préliminaires.

**Arborescence cible.**

```
HUMAN/
  00_SYNTHESE_DECISION.md
  01_marche.md
  02_concurrence.md
  03_produit_technique.md
  04_legal.md
  05_finances.md
  06_acquisition_marque.md
  07_risques_decision.md
  modele_financier.xlsx
  registre_hypotheses.md
  sources.md
  plan_30_jours.md
  questions_ouvertes.md
  JOURNAL.md
  prototype/
    landing/            (landing page de test prête à publier)
    mvp_logiciel/       (spécification et prototype de la pile logicielle hors ligne)
  outils/               (scripts : génération du modèle financier, relevé de prix)
```

## 2026-11-12 : Recherche factuelle (étapes 1 à 4)

**Méthode.** Environ 75 recherches web, notes brutes consolidées puis reportées dans `sources.md` (74 sources datées, classées par fiabilité).

**Limite d'environnement.** La lecture directe des pages web était bloquée par la politique réseau. Toutes les informations viennent des extraits renvoyés par le moteur de recherche. Conséquence : chaque chiffre clé est à revérifier sur la page d'origine avant usage public. Les pages des concurrents américains, le catalogue Kiwix et Google Trends n'ont pas pu être consultés directement.

**Constat 1 : la thèse "cet assemblage n'existe pas" est fausse.** Un smartphone durci préchargé avec IA hors ligne est vendu 349,99 USD aux Etats-Unis (Survival Node Gen 2). Trois autres appareils et plus de dix applications occupent le terrain. Rien d'équivalent trouvé en français.

**Constat 2 : le statut de fabricant est hors de portée.** Ecoconception des smartphones (5 ans de mises à jour, 7 ans de pièces), cybersécurité radio, DAS. Précédent de retrait par l'ANFR de deux téléphones durcis chinois en 2025.

**Constat 3 : le marché français n'est pas mesuré.** 10 % de foyers équipés d'un kit, pas de donnée de vente, salon de référence à fréquentation stable. Le marché adressable du produit est estimé à 3 à 7 M€ par an, avec une confiance faible.

## 2026-11-12 : Changement de cap proposé

**Décision de travail.** Recommander un pivot : de "smartphone durci à notre marque" vers "pack de savoirs hors ligne en français (téléchargement et carte mémoire), avec téléphone du commerce en option". Motifs : faisabilité réglementaire, capital nécessaire, marge (93 % et 40 % sur le pack contre 17 à 20 % sur le téléphone), seule place libre repérée.

**Point tranché (ambiguïté A, B, C du brief).** Modèle C resserré : marque propre logicielle, revente de téléphones tiers, catalogue court d'accessoires. La place de marché (B) et le téléphone à notre marque (A) sont écartés. Détail chiffré dans `05_finances.md`, section 2.

**Variantes classées.** 1 : pack logiciel. 2 : boîtier familial hors ligne. 3 : kit 72 heures. La thèse initiale est classée cinquième sur six.

## 2026-11-12 : Modèle financier

**Construction.** Classeur généré par script (`outils/generer_modele_financier.py`), trois scénarios côte à côte, 6 762 formules, recalcul LibreOffice sans erreur.

**Correction en cours de route.** Première version calée sur les prix de lancement américains (359,99 USD pour le téléphone à 22 000 mAh, soit une hypothèse de 399 € TTC en Europe). Une recherche tardive a montré des offres européennes dès 272 € TTC. Le modèle a été recalé : prix de vente du téléphone prêt à l'emploi ramené de 529 à 449 € TTC, prix d'achat de 290 à 235 € HT. Effet : la marge par commande passe de 46 à 43 €, l'EBITDA central de l'année 3 de 27 000 à 16 500 €. La conclusion se durcit : la publicité payante n'est pas rentable sur ce panier.

**Correction de calendrier.** Les apports complémentaires ont été avancés au mois 2 (après la décision du jour 30) et le stock réduit à un demi-mois pendant la phase de précommande, pour que le scénario central ne passe jamais en trésorerie négative.

## 2026-11-12 : Marque et prototypes

**Nom de travail.** MECUM, retenu pour la page de test. Domaines mecum.fr, mecum.tech et mecum.app disponibles ce jour. VIATIK écarté (connotation du viatique), HAUBAN écarté (société homonyme). HUMAN conservé comme nom de code. Aucun domaine acheté, aucune marque déposée.

**Dépense non engagée.** Un outil payant de recherche d'antériorité de marque était accessible. Il n'a pas été utilisé, faute d'accord sur la dépense (question ouverte n° 7).

**Prototypes livrés.** Page d'atterrissage vérifiée dans un navigateur (ordinateur et téléphone, formulaire, variantes). Maquette de recherche hors ligne : 12 fiches de démonstration, 20 questions de contrôle réussies. Les fiches ne sont pas relues par un professionnel et ne doivent pas être diffusées.

## Ce qui n'a pas été fait, et pourquoi

| Elément | Raison | Suite |
|---|---|---|
| Relevé de prix automatique sur sites réels | Pas d'accès direct au web | Script fourni et testé hors ligne, à lancer par Benjamin |
| Recherche d'antériorité de marque | Dépense non autorisée | Question ouverte n° 7 |
| Courbes Google Trends | Non accessibles | Plan à 30 jours, jour 5 |
| Audience des créateurs francophones | Outils de mesure non accessibles | Plan à 30 jours, jour 11 |
| Mesure d'autonomie et de vitesse de l'IA sur téléphone | Aucun matériel | Plan à 30 jours, jours 6 et 7 |
| Devis fournisseurs | Nécessite une prise de contact au nom du fondateur | Plan à 30 jours, jour 2 |

## Questions ouvertes

Regroupées dans `questions_ouvertes.md`. Les quatre premières conditionnent le démarrage du test.

## Prochaine décision attendue

Réponses de Benjamin aux questions 1 à 4, puis lancement du plan à 30 jours. Décision go, no-go ou variante au jour 30, à consigner ici.

## 2026-11-12 : Décisions du fondateur après lecture de la synthèse

| Question | Décision de Benjamin |
|---|---|
| 1. Pivot | Accepté. Le projet devient une application locale pour téléphones ordinaires. Le téléphone durci n'est plus au coeur du projet |
| 4. Nom de travail | MECUM |
| Orientation produit | S'inspirer de HAVEN, en particulier de son modèle à partie gratuite |

**Conséquences à instruire.**

1. Modèle gratuit avec version payante : la partie gratuite devient le principal canal d'acquisition, ce qui répond au problème central du dossier (coût d'acquisition payant proche de la marge). Le modèle financier doit être refait autour de trois hypothèses nouvelles : installations gratuites par mois, taux de passage au payant, prix de la version complète.
2. Le pack sur carte mémoire et le téléphone prêt à l'emploi passent au rang d'options à tester plus tard.
3. La distribution par Google Play devient prioritaire, avec sa commission à intégrer.
4. L'analyse détaillée de HAVEN reste à faire : l'application n'est pas accessible depuis l'environnement de travail. Benjamin fournit des captures d'écran.

**Branche.** `main` créée sur le premier commit du dossier, pull request ouverte depuis la branche de travail.

**Questions encore ouvertes avant le jour 1.** La 2 (durée sans revenu, droits au chômage) et la 3 (production hebdomadaire de contenus).

## 2026-11-12 : Analyse de HAVEN sur captures d'écran

Benjamin a fourni huit captures de HAVEN. Voir `08_analyse_haven.md`. Trois corrections au dossier : HAVEN a déjà une interface en français (le contenu reste anglais et américain), son socle gratuit couvre presque tout ce que le "pack" devait vendre, et son étendue ne peut pas être égalée par une personne seule. Probabilité de franchir les seuils du test ramenée de 35 à 45 % vers 25 à 35 %. Axe de différenciation proposé : contenu français vérifié, sécurité toujours gratuite, périmètre étroit. Livrables de la phase 1 à adapter après réponses de Benjamin (liste en section 6 de l'analyse).

## 2026-11-13 : iPhone d'abord, modèle financier version 2

**Réponses de Benjamin.** iPhone d'abord, pas d'Android au lancement. Les guides de HAVEN n'ont ni source, ni auteur, ni date, et sont en anglais par défaut. Prix de HAVEN relevés sur capture : Pro Family 59,99 €, Watch 29,99 € par an ou 3,99 € par mois. Ce qu'il apprécie : la prise en main par questions et le téléchargement immédiat de la carte et du modèle. Ce qui le gêne : l'esthétique "faite avec une IA" de l'application et de sa fiche App Store. Réserve personnelle : 3 à 4 mois sans revenu. Contenus chaque semaine : oui.

**Correction signalée.** L'iPhone ne représente pas "la plupart" des Français : 34 à 36 % des smartphones en 2026 (StatCounter). Le choix reste défendable pour la cible aisée et pour le modèle local d'Apple, gratuit et en français sur iPhone 15 Pro et suivants.

**Modèle financier version 2.** Application gratuite, version complète en achat unique, licences communes optionnelles. Scénario central : 34 000 installations et 2 070 achats en année 3, EBITDA de 6 900 € après 24 000 € de rémunération, revenu de 1 500 € nets possible au mois 30 seulement, 35 000 € de fonds propres consommés. La publicité ne paie pas (0,68 € par euro). L'ancien modèle est archivé.

**Conséquence la plus importante.** La réserve de 3 à 4 mois ne couvre que le test et le développement. Recommandation : un revenu extérieur à partir du mois 4.

**Piste ajoutée.** Module pour les communes (plan de sauvegarde hors ligne pour les habitants), testé dès le plan à 30 jours. Elle exploite l'expérience de Benjamin en vente aux collectivités.

**Livrables mis à jour.** `09_application_iphone.md` (nouveau), `00_SYNTHESE_DECISION.md`, `modele_financier.xlsx`, spécification iOS, page de test, plan à 30 jours, questions ouvertes, registre (section F), bandeaux de renvoi dans 02, 03, 05 et 06.

## 2026-11-13 (soir) : financement personnel

**Réponses de Benjamin.** Pas de Mac (tablette de 2021), achat d'un MacBook Pro prévu au Black Friday. Allocations chômage d'environ 1 000 € par mois, demande de révision et d'ARCE envisagée, estimée à 20 000 € en deux fois sur 6 mois. Après le lancement : temps partiel avec d'autres projets de création.

**Analyse.** La contrainte des 3 à 4 mois est levée par les allocations. Incohérence signalée : 20 000 € d'ARCE supposent environ 33 000 € de droits restants, soit 33 mois à 1 000 €, au-delà de la durée maximale d'indemnisation (18 mois avant 53 ans, à confirmer). Estimation plus réaliste : 10 800 € au plus. Recommandation : maintien des allocations plutôt qu'ARCE, choix à faire avant la création de la société avec France Travail et l'expert-comptable. Un MacBook Air de 16 Go suffit pour MECUM. Si la tablette est un iPad Pro M1, elle remplace l'iPhone de test. Risque nouveau : dispersion entre plusieurs projets, parade proposée de deux jours et demi par semaine minimum.

**Modèle financier.** Inchangé : il ne porte que sur la société. La ligne de 800 € pour un Mac devient inutile.

## 2026-11-13 (suite)

Tablette : iPad standard de 2021, sans Apple Intelligence. L'iPhone de test reste au budget, sauf iPhone récent déjà possédé. Droits France Travail pas encore connus : n'empêche pas de lancer le test, à obtenir avant le jour 22.

## 2026-11-18 : vérification du nom OKAOU

Benjamin souhaite garder OKAOU (jeu de mots sur "au cas où"). Il a exporté deux recherches du portail de l'INPI (entreprises, puis marques).

**Résultat : rouge.** Deux marques verbales françaises en vigueur couvrent déjà une application :

| Marque | Titulaire | Classes | Pourquoi c'est bloquant |
|---|---|---|---|
| OKAOU (n° 4881052, 2022) | Une personne physique (département 41) | 9, 35, 38, 42, 45 | Signe identique, "logiciels" en classe 9, développement et SaaS en classe 42, services de sécurité en classe 45 |
| OKAOU C LA (n° 4333844, 2017) | Société de Chassieu (69) | 41, 42, 45 | Formation, logiciels, services de sécurité pour les biens et les personnes. Dix ans le 31/01/2027 : renouvellement à surveiller |

Les autres marques (produits chimiques, alimentaire, construction, boissons, anciennes marques expirées de La Redoute et de Gan) sont dans d'autres secteurs.

**Conséquence.** OKAOU ne peut pas être utilisé publiquement pour l'application sans accord écrit, et il faudrait en principe deux accords. Toute variante qui se prononce "okaou" est exposée au même risque (similitude phonétique). Règle posée : aucun engagement (graphiste, développeur, compte Apple, publicité, deck) sous le nom OKAOU sans accord écrit. Le test de 30 jours et le deck pour les mairies restent sous MECUM. Date butoir : jour 22 du plan. Sans accord à cette date, plan B avec un nom qui change la sonorité.

## 2026-11-18 (suite) : AUKAZOU et OKAZOU

Recherche INPI "AUKAZOU" : 0 marque, 1 entreprise (non identifiée). Mais AUKAZOU se prononce comme OKAZOU, et la base contient deux marques en vigueur de même sonorité :

| Marque | Titulaire | Date | Classes | Couverture |
|---|---|---|---|---|
| OKAZOU (n° 5273379, verbale) | Une personne physique (département 972) | 29/06/2026 | 9, 35, 42 | Logiciels enregistrés, développement de logiciels, SaaS, hébergement |
| O'kazou (n° 4299916, semi-figurative, renouvelée) | Une personne physique (département 67) | 16/09/2016 | 19, 35, 36, 37, 41, 42, 45 | Dont éducation, formation, logiciels, SaaS, services de sécurité |

**Conclusion : rouge aussi.** Le territoire sonore "o-ka-ou / o-ka-zou" est saturé : quatre marques en vigueur (OKAOU 2022, OKAOU C LA 2017, OKAZOU 2026, O'kazou 2016) dans les classes logiciel, formation ou sécurité. Le plan B doit abandonner cette sonorité et probablement l'expression "au cas où". Prochain contrôle : vérifier MECUM dans la base des marques (jamais fait) et préparer une liste de noms à sonorité différente.

## 2026-11-18 (fin) : nom choisi, PARÉ (sous réserve)

**Décision de Benjamin.** MECUM abandonné (il ne l'aime pas), OKAOU et AUKAZOU écartés (sonorité saturée). Nom retenu : **PARÉ** (« être paré », prêt). Un export de la base des marques lui a été fourni.

**Lecture de l'export.** 500 lignes (plafond d'export), uniquement du 11/08/2025 au 27/10/2026. Les marques plus anciennes ne sont pas dans le fichier : **vérification incomplète**. Dans la fenêtre, 29 marques contiennent le mot PARE ou PARÉ isolé. La grande majorité sont des « pare-brise » (classes 12 et 37), hors sujet. A noter : PARÉS (marque de l'Union européenne n° 019311682, 2026, articles de sport, classes 10, 18, 21, 25, 28, 35, 41) et « MOUSSE OU CAPITAINE ? PARÉ À VIRER ! » (n° 5298375, classes 9 et 28, demande publiée). Aucune marque PARÉ seule en classes 9, 42 ou 45 dans la fenêtre.

**Réserves.** Recherche filtrée à refaire (classes de Nice, tranches de dates), contrôle de l'Union européenne et de l'OMPI, onglet Entreprises, domaines. Risques propres au nom : bruit de recherche (« pare » donne pare-brise et pare-feu), évocation d'Ambroise Paré (chirurgien, hôpitaux et cliniques), accent absent des noms de domaine.

**Règle.** Dossier non renommé tant que la recherche filtrée n'est pas propre. Si elle l'est, renommage global en une opération. Aucun engagement (graphiste, développeur, compte Apple, publicité) avant l'avis écrit du conseil.

## 2026-11-18 (fin) : domaines de PARÉ

Capture du registraire (OVHcloud), recherche "paré" avec accent : **paré.fr indisponible, paré.com déjà enregistré (transfert verrouillé)**. Disponibles : .eu (7,49 € puis 8,59 €/an), .org (7,99 € puis 12,99 €), .shop (2,99 € puis 39,89 €), .tech (7,99 € puis 56,29 €), .group (5,99 € puis 25,49 €), .biz (1,49 € puis 20,39 €), .art. Prix hors taxe. Pièges de renouvellement sur .shop, .tech, .biz.

Constat : le nom de domaine d'usage (sans accent, que le public tapera) reste à vérifier : pare.fr, pare.com, pare.eu, pare.app. Aucun achat tant que la recherche de marque filtrée n'est pas propre. Si un domaine est acheté, le doubler de sa version sans accent.

## 2026-11-18 (fin) : SIJAMAIS, premières vérifications

**Base INPI (recherche exacte, mise à jour du 13/11/2026).** SIJAMAIS : 0 entreprise, 0 brevet, 0 dessin, **1 marque, expirée** : n° 3009896, déposée le 25/02/2000 par une compagnie d'assurances, classes 36, 38 et 42. Aucune marque en vigueur.

**Domaines (OVHcloud, prix hors taxe).** sijamais.com déjà pris (transfert verrouillé). sijamais.fr déjà réservé (affiché "transférable"). Disponibles : .eu 7,49 € puis 8,59 €, .org 7,99 €, .cloud 1,99 € puis 19,29 €, .pro 2,99 € puis 26,29 €, .shop et .tech avec renouvellement élevé.

**Lecture.** Meilleur résultat de marque que PARÉ à ce stade (aucune marque vivante, aucune société), mais l'INPI rappelle qu'il faut compléter par une recherche de similitude. Même problème de domaines .fr et .com que PARÉ. A faire : recherche "SI JAMAIS" en deux mots, variantes phonétiques, Union européenne et OMPI, ouverture de sijamais.fr et sijamais.com.

## 2026-11-18 (fin) : nom retenu, SIJAMAIS

**Décision de Benjamin : on part sur SIJAMAIS.**

| Nom | Sort | Raison |
|---|---|---|
| MECUM | Abandonné | Goût du fondateur |
| OKAOU | Écarté | Marques OKAOU n° 4881052 (logiciels, sécurité) et n° 4333844 (formation, logiciels, sécurité) en vigueur |
| AUKAZOU | Écarté | Homophone d'OKAZOU : marques n° 5273379 (classes 9, 35, 42) et n° 4299916 (dont 41, 42, 45) en vigueur |
| PARÉ | Mis de côté | Export de marques incomplet, domaines .fr et .com pris, bruit « pare-brise », évocation d'Ambroise Paré |
| **SIJAMAIS** | **Retenu** | 0 société, 0 marque vivante (1 marque expirée d'un assureur, 2000). Domaines .fr et .com réservés, .eu disponible |

**Réserves.** Recherche de similitude, Union européenne et OMPI, ouverture de sijamais.fr et sijamais.com, avis écrit du conseil. Le dossier est renommé (documents, page de test, prompt du deck, générateur du modèle). Les entrées antérieures du journal gardent l'ancien nom.

**Règle maintenue.** Aucun engagement (graphiste, développeur, compte Apple, dépôt de marque) avant l'avis écrit du conseil. La page de test et ses annonces peuvent utiliser le nom : c'est peu coûteux et réversible.

## 2026-11-18 : stratégie auprès des collectivités et veille officielle

**Orientation de Benjamin.** Proposer SIJAMAIS aux mairies, à la région et à l'État sans demander de financement, mais de la visibilité : relais et recommandation aux citoyens. L'application doit reprendre toutes les recommandations officielles en vigueur, à la manière dont HAVEN reprend les manuels de l'armée américaine.

**Travail fait.** `10_veille_officielle.md` : 15 sources officielles civiles, 6 jeux de données publiques, règles de réutilisation (Licence Ouverte, droits des tiers, interdiction du logo de l'État), organisation de la veille.

**Conclusions.** (1) Tout contenu issu d'une source publique reste gratuit, condition d'une recommandation par une collectivité. (2) Pas d'équivalent public français du manuel de survie de l'armée américaine : le TTA 150 est un manuel militaire de combat ; en France, la protection des civils relève de la sécurité civile et du SGDSN. (3) Aucune trace d'un envoi de kits ou du guide aux foyers par l'État : le guide a été diffusé en ligne. (4) Cible de visibilité : Journée nationale de la résilience du 13 octobre 2027.

## 2026-11-18 : validation de toutes les propositions et maquette 0.1

**Décision de Benjamin.** « D'accord avec absolument tout. » Sont donc validés : les 37 propositions de la maquette (iPhone, 5 onglets, sombre par défaut, 6 modes sans chasse, scénarios de crise tous gratuits, pas de Bible ni de catégorie défense, pas d'équivalent de HAVEN Watch, abonnement 3,99 € par mois ou 29,99 € par an, famille 5,99 € ou 44,99 €), la règle de gratuité des contenus publics et la stratégie de veille officielle.

**Travail fait.** `prototype/maquette_app/index.html` : maquette cliquable de 17 écrans, thèmes sombre et clair, simulation gratuit et premium, vérifiée dans un navigateur sans erreur.

**Prochaine étape.** Mettre à jour le modèle financier pour l'abonnement, puis aligner les textes des fiches sur les sources officielles.

## 2026-11-18 : maquette 0.2, signalétique de sécurité

**Décision de Benjamin.** Direction visuelle A (signalétique de sécurité) pour la maquette. Photos libres de droits ou achetées à fournir plus tard par Benjamin pour les loisirs et le premium.

**Travail fait.** Maquette HTML et PDF en version 0.2 : 30 pictogrammes dessinés à la main, code couleur des panneaux de sécurité (rouge secours, jaune danger, vert sécurité, bleu eau), scénarios de crise en tuiles. Le PDF 0.1 est retiré du dépôt (il reste dans l'historique).

## 2026-11-18 : demande d'un module de communication hors réseau

**Demande de Benjamin.** Messagerie de proximité sans réseau, sur le principe du talkie-walkie : maillage Bluetooth et Wi-Fi entre téléphones, longue portée LoRa avec des boîtiers Meshtastic, relais et alertes officielles des communes. Plan à valider avant tout code.

**Travail fait.** `11_module_communication_hors_reseau.md` : analyse du dépôt (aucun code d'application), 8 incohérences avec l'existant, 5 limites techniques, architecture, 6 étapes chiffrées, 7 décisions à prendre.

**Points saillants.** (1) Un iPhone en arrière-plan relaie mal : le maillage entre téléphones fonctionne surtout application ouverte, le boîtier LoRa porte l'arrière-plan. (2) Multipeer et Wi-Fi Direct ne se parlent pas : Wi-Fi Aware (iOS 26 et Android) proposé à la place. (3) Meshtastic est sous GPL-3.0 : avis de l'avocat avant l'étape 3. (4) Charge totale estimée de 75 à 125 jours, hors du budget actuel de la v1. (5) Le réseau de relais LoRa peut devenir une offre payante pour les communes.

**En attente.** Validation de Benjamin (décisions R1 à R7). Aucun code écrit.

## 2026-11-23 : Mac reçu

MacBook Air M5 avec 24 Go de mémoire, choisi pour servir à la fois SIJAMAIS et la future activité d'automatisation IA de Benjamin. Le prérequis « Mac » des étapes 1 à 4 du module de communication est levé. Restent à décider : R1 à R7 (`11_module_communication_hors_reseau.md`).

## 2026-11-24 : module de communication reporté, recalage du plan de 30 jours

**Décision de Benjamin.** Le module de communication hors réseau n'est pas exploré pour l'instant.

**Constat.** Le test de 30 jours prévu à partir du 16/11 n'a pas démarré. Nouveau jour 1 fixé au lundi 30/11/2026 (`plan_30_jours.md`, section « Recalage »). La maquette remplace le « MVP zéro » pour les entretiens et les mairies.

## 2026-11-25 : marque SIJAMAIS, recherche TMview et décision de dépôt

**Décisions de Benjamin.** Pas d'avis écrit d'un conseil en propriété industrielle. Dépôt de la marque par lui-même à l'INPI avant le 30/11/2026. Réservation de `sijamais.eu` sur OVH.

**Recherche TMview (captures de Benjamin).** « SIJAMAIS » : une seule marque, expirée (Assurances générales de France, déposée en 2000, classes 36, 38, 42). « SI JAMAIS », filtré sur les classes 9, 41 et 42 : 47 résultats, dont une marque enregistrée au Canada (classes 35, 36, 41, association de courtiers d'assurance), sans effet en France. Les 2 résultats de l'office européen (EUIPO) restent à examiner : une marque de l'Union s'applique en France.

## 2026-11-25 : guides de survie, version 1.0

**Apport de Benjamin.** 35 guides en 5 catégories (Urgence, Se préparer, Survie et autonomie, Après la crise, Espace mairie), au format JSON avec une page de visualisation, fondés sur 14 sources : guide SGDSN 2025, PIMS, PFMS 2010, DRSD, ANSSI, affiche du kit 72 h, checklists et manuels privés.

**Revue** (`contenus/guides/REVUE_v1.0.md`). Partie Urgence fidèle au guide officiel, plan familial très réussi. À corriger avant diffusion : délai de déclaration en catastrophe naturelle (30 jours depuis 2023, et non 10), iode en pharmacie réservé aux zones proches des centrales, détecteur de fumée loin de la cuisine, tussilage toxique à retirer, passage du soleil au sud vers 13 h ou 14 h et non à midi, radios « ici » et non France Bleu, stocks incohérents, IFAK et trauma kit hors charte. Sources privées à réécrire ou à faire autoriser. Gestes de premiers secours absents. Le guide officiel recommande « s'échapper, se cacher, alerter, résister » face à une attaque : la proposition 14 de la maquette est corrigée en conséquence.

## 2026-11-25 : guides version 1.1 intégrés à la maquette

**Validation de Benjamin** (« ok ») de la revue des guides 1.0.

**Travail fait.** `contenus/guides/guides_v1.1.json`, produit par `outils/construire_guides_v11.py` : toutes les corrections de la revue, 9 guides ajoutés (arrêt cardiaque, saignement, personne inconsciente, étouffement, brûlure, monoxyde de carbone, coupure d'électricité, canicule, grand froid), IFAK et trauma kit retirés, tussilage retiré, espace mairie reformulé avec le vocabulaire du plan communal de sauvegarde. Chaque guide porte désormais son niveau (25 consignes officielles, 19 conseils pratiques), sa date, son statut de relecture et ses points à vérifier. 20 sources décrites avec leur statut de réutilisation. Intégration dans la maquette par `outils/integrer_guides_maquette.py` (50 écrans, navigation sans JavaScript vérifiée).

**Reste à faire.** Relecture des guides de premiers secours par un formateur agréé, vérification des points listés dans `a_verifier`, demandes d'autorisation aux auteurs privés (La Libellule, APARS56, Atelier ILYS, Résilience urbaine).

## 2026-11-25 : guides cyberattaque

**Demande de Benjamin.** « Et cyberattaque ? » Le sujet n'était traité qu'en quelques lignes (désinformation, communication de crise de la mairie).

**Travail fait.** Deux guides ajoutés à la version 1.1 (46 guides) : « Cyberattaque et arnaques en ligne » pour les habitants (rançongiciel, compte piraté, message frauduleux, attaque d'ampleur nationale, prévention, 17Cyber, 33700, Pharos) et « Cyberattaque contre la commune » dans l'espace mairie (premières heures, CSIRT régional, notification à la CNIL sous 72 heures, communication pendant l'attaque d'après la checklist de l'ANSSI). Tuiles « Cyberattaque » et « Monoxyde de carbone » ajoutées à l'onglet Urgence.

## 2026-11-26 : assistant IA local et schémas des guides

**Demandes de Benjamin.** (1) Cadrer l'IA locale et l'ajouter à la maquette. (2) Améliorer les guides avec Claude Design : schémas et images libres de droits.

**Travail fait.** `12_assistant_ia_local.md` : modèle d'Apple sur l'appareil (4 096 jetons, génération guidée, garde-fous pouvant refuser), trois niveaux (recherche sur tous les iPhones, reformulation sur les iPhones compatibles, aucune génération pour la santé), règle « rien qui ne soit pas dans un guide », tests avant développement. Nouveauté d'iOS 27 notée : modèle dans le nuage gratuit pour les petits développeurs, écarté en v1 car il exige du réseau. Assistant de la maquette rendu interactif : recherche réelle dans les 46 guides, bandeau d'urgence et étapes exactes pour la santé, simulation d'un iPhone non compatible ; 15 questions de test sur 15 correctes. `prompts/claude_design_schemas_guides.md` : 24 schémas prioritaires, style signalétique, SVG, aucune image IA, règles et registre des crédits photo (`contenus/images/CREDITS.csv`).

## 2026-11-26 : IA locale validée, onglet Assistant

**Décisions de Benjamin.** IA locale par le modèle d'Apple : recommandations IA1 à IA4 validées. Demande d'un onglet dédié à l'assistant et de plusieurs propositions dans la maquette.

**Travail fait.** Trois variantes de navigation dans la maquette (A : assistant au centre de la barre, bouton rond surélevé, recommandée ; B : onglet classique ; C : barre de question sur chaque écran), sélectionnables dans le panneau de gauche ou dans Réglages. Champ « Posez une question » sur l'accueil. Écran Assistant refait : en-tête, saisie avec dictée, questions fréquentes classées par couleur, explication du fonctionnement. Préparer reste accessible depuis l'accueil dans les variantes A et B.

## 2026-11-26 : variante A retenue, étude du réseau d'entraide

**Décisions de Benjamin.** Variante A (assistant au centre de la barre d'onglets) retenue ; les variantes B et C sont retirées de la maquette. Nouvelle idée : permettre aux habitants volontaires de déclarer leurs compétences et moyens (santé, secourisme, hébergement, matériel, réparation) et de les afficher sur la carte. Demande d'étude RGPD.

**Travail fait.** `13_reseau_entraide.md`. Conclusion : bonne idée, conforme à l'esprit du guide officiel, mais une carte publique gérée par SIJAMAIS contredirait la promesse « aucune donnée », exposerait les aidants (cambriolage, harcèlement, usurpation) et imposerait une analyse d'impact (localisation à grande échelle). Proposition en deux temps : profil d'aidant local partagé par QR code en v1 ; réseau d'entraide géré par la mairie (responsable du traitement, réserve communale) dans l'offre aux communes, avec trois niveaux de visibilité. SAUV Life et Staying Alive à recommander pour les secouristes.

## 2026-11-26 : réseau d'entraide validé, fichier Word des guides

**Décisions de Benjamin.** Recommandations E1 à E5 du réseau d'entraide validées. Besoin d'un fichier Word des guides à joindre au prompt Claude Design.

**Travail fait.** `contenus/guides/SIJAMAIS_guides_v1.1.docx` (43 pages, produit par `outils/guides_en_word.js`) : couverture, mode d'emploi, sommaire, les 46 guides avec identifiant, niveau, bandeaux d'urgence, emplacements des 24 schémas, sources et points à vérifier. Guides : SAUV Life et Staying Alive ajoutés (arrêt cardiaque, entraide), profil d'aidant mentionné. Maquette : écran « Mon profil d'aidant » (catalogue à cocher, contact facultatif sans adresse, partage par QR code, trois niveaux de visibilité du futur réseau communal, majeurs seulement), accessible depuis Famille ; couche « Aidants » sur la carte et liste d'exemples fictifs de la commune.

## 2026-11-26 : schémas des guides intégrés

**Apport de Benjamin.** Les 24 schémas réalisés avec Claude Design (SVG), leurs textes alternatifs et un PDF de maquettes d'écran.

**Vérification.** Aucun script, lien externe ni dégradé dans les SVG. Contenu conforme aux guides (électrodes du défibrillateur, position latérale de sécurité, méthode de la montre adaptée à l'heure française). Le kit de 72 heures est une composition originale, sans reprise de l'illustration protégée de l'affiche officielle. Défaut mineur : dans « Étouffement », le chiffre 2 touche le titre.

**Travail fait.** Schémas rangés dans `contenus/guides/schemas/`, ajoutés aux guides comme blocs « schéma » (`guides_v1.1.json`), affichés dans la maquette sur fond clair dans les deux thèmes, et intégrés au fichier Word (53 pages). Idée reprise des maquettes de Claude Design : le bandeau « Urgence vitale » porte deux boutons, 15 et 112. Leur barre d'onglets n'est pas reprise : la variante A reste la référence.

## 2026-11-26 : début du code de l'application

**Demande de Benjamin.** « Commençons le coding de l'app. »

**Environnement.** Création d'un environnement cloud personnel « HUMAN » autorisant download.swift.org, validée par Benjamin : compilateur Swift 6.1.2 installé dans le conteneur. La compilation de XcodeGen dans le conteneur a été refusée par le système de sécurité : le projet Xcode sera produit sur le Mac de Benjamin (Homebrew puis `xcodegen generate`).

**Travail fait.** `app/` : cœur `SijamaisKit` en Swift pur (lecture des 46 guides et de leurs 14 types de blocs, moteur de recherche identique à la maquette, règles de l'assistant, score de préparation, foyer, listes) avec 20 tests, tous réussis sous Linux ; application SwiftUI (prise en main, accueil, urgence avec appel direct, assistant au centre de la barre d'onglets avec passerelle vers le modèle d'Apple d'iOS 26, guides avec schémas vectoriels, préparer, réglages, lampe torche, carte en attente) ; catalogue d'images (24 schémas, icône) produit par `outils/preparer_ressources_app.py`. Le code SwiftUI n'a pas pu être compilé sans Xcode : à compiler sur le Mac, erreurs éventuelles à renvoyer.

## 2026-11-26 : première compilation réussie sur le Mac

**Résultat.** Homebrew et XcodeGen installés par Benjamin, projet généré, **application compilée et lancée du premier coup** sur le simulateur iPhone 18 Pro. Prise en main, accueil, assistant au centre et guides fonctionnent.

**Corrections après ses essais.** (1) Sécurité : « Je n'arrive plus à respirer » affichait les gestes à faire sur une autre personne (arrêt cardiaque). Désormais, quand la personne parle d'elle-même d'une urgence de santé, l'assistant répond d'abord « Appelez le 15 ou le 112 maintenant, 114 par SMS si vous ne pouvez pas parler ». (2) « Le rythme du massage cardiaque » ne trouvait pas l'étape « 100 à 120 par minute » : synonymes ajoutés. (3) « J'ai peur » ne trouvait rien : renvoi au guide « Prendre soin du moral » (avec le 3114). (4) Titre « Urgence vitale » tronqué dans le bandeau rouge. 22 tests, tous réussis.

## 2026-11-26 : carte hors ligne, étape A

**Décision de Benjamin.** Lancement de l'étape A du plan des cartes (`14_cartes_hors_ligne.md`).

**Travail fait.** MapLibre 7.1.0 ajouté au projet ; onglet Carte branché sur un fichier PMTiles local (fond Protomaps tiré d'OpenStreetMap), avec un style SIJAMAIS (relief des routes, eau, végétation, bâtiments, noms des communes et des rues) et les services utiles en couleur (hôpitaux, pompiers, pharmacies, police, mairies), position GPS, légende et mention obligatoire d'OpenStreetMap. Polices Noto Sans (licence OFL) embarquées pour les noms. Script `outils/extraire_carte.sh` pour extraire la Loire-Atlantique sur le Mac : le site de Protomaps n'est pas accessible depuis l'environnement de Claude. Défibrillateurs (Géo'DAE) reportés à l'étape B, data.gouv.fr étant lui aussi inaccessible d'ici.

## 2026-11-26 : retours d'essai sur la carte et l'assistant

**Retours de Benjamin.** (1) La carte s'affiche mais sans aucun point, et paraît brute. (2) L'assistant est trop dépendant des mots-clés et certaines réponses sont « hors sol ». Demande d'un prompt circulaire pour faire progresser l'assistant par cycles.

**Diagnostic carte.** Les points de la carte Protomaps n'existent qu'à partir du zoom 12 (hôpitaux) ou 15 à 16 (pharmacies, pompiers), alors que la carte s'ouvrait au zoom 11. Correction : couche de points de secours propre à SIJAMAIS, produite par `outils/extraire_points.py` (OpenStreetMap et Géo'DAE, à lancer sur le Mac), visible dès le zoom 9 pour les hôpitaux et les pompiers, avec lettres (H, 18, 17, +, DAE, M) et noms ; style du fond retravaillé (bordures de routes, habitat, plages, zones de santé, quartiers) ; ouverture au zoom 12. L'installation du générateur de style officiel de Protomaps (paquet npm) a été refusée par le système de sécurité : non contourné.

**Assistant.** `prompts/claude_amelioration_assistant.md` : boucle en cinq temps entre un Claude évaluateur et Claude Code, 12 thèmes, 40 questions par cycle, format JSON des cas de test, synonymes, intentions, règles, contenus et sources. `contenus/assistant/etat_assistant.md` : fiche d'état à joindre à chaque cycle.

## 2026-11-27 : cycle 1 de l'assistant intégré (urgences vitales et premiers secours)

**Entrée.** Livrable du Claude évaluateur, relu et transmis par Benjamin : 40 cas de test, synonymes, intentions, 6 règles, 2 guides proposés (AVC, étouffement du nourrisson), 3 questions.

**Travail fait.** (1) Les 40 cas sont rejoués à chaque version (`contenus/assistant/cycle1/cas_de_test.json`, test `Cycle1Tests`). (2) Nouvelle couche de triage avant la recherche par mots (`SijamaisCore/Triage.swift`) : mots trompeurs, hors périmètre (posologie, diagnostic, vétérinaire, plantes, armes, feux de jardin, appareils), signes graves sans guide (AVC, convulsions, ingestion de produit, asthme, électrocution, réaction allergique, noyade) avec 15 ou 112 tout de suite, urgence personnelle, priorité entre urgences, nourrisson sans gestes de l'adulte, toux efficace, mer (196), chaleur avec confusion ou fièvre. (3) Questions de clarification avec boutons (« Pour vous ou pour un proche ? », « Répond, respire ? », « Saignement abondant ? »), au plus deux questions. (4) Synonymes en expressions et mots anglais ; bandeau « Emergency: call 112 » pour une question en anglais. (5) 196 ajouté au guide des numéros, marqué « à vérifier ». **Résultat : 40 cas sur 40, et 31 questions nouvelles sur 31 après correction ; 28 tests réussis.**

**Avocat du diable.** Les règles ont été écrites en connaissant les 40 cas. Mesure honnête sur des questions jamais vues : 10 bonnes sur 16, puis 11 sur 16, puis 9 sur 15 avant correction, avec des erreurs graves (« mon fils a avalé une pile » renvoyait au guide Grand froid, « un enfant s'est noyé » à l'étouffement). Après correction par famille de cas, ces 31 questions sont devenues des tests. Le triage par règles progresse vite mais restera fragile : la recherche par le sens (plongements d'Apple) et les cycles suivants restent nécessaires.

## 2026-11-27 : cycle 2 de l'assistant intégré (alertes et risques majeurs)

**Entrée.** Livrable du Claude évaluateur : 40 cas, synonymes, intentions, 5 règles, découpage du guide « risques », 3 questions.

**Travail fait.** Nouvelle étape du triage (`SijamaisCore/RisquesMajeurs.swift`) : chaque risque du guide « Que faire selon le risque » est repéré séparément et seule sa section est affichée, mot pour mot, sans reformulation (nouveau mode « consigne »). Le guide reste unique à l'écran. Règles : barrage et corne de brume, rumeurs, FR-Alert, enfants à l'école, odeur de gaz en premier, flamme pendant une mise à l'abri, iode sur instruction du préfet, attaque cardiaque jamais confondue avec un attentat, métaphores (« tempête de critiques »), hors périmètre (filtre artisanal, juridique, météo, radios des secours, dégât des eaux, alerte enlèvement), clarifications (évacuer ou rester, feu dehors, « alerte » seul). Contractions élargies (« lecole », « lascenseur », « diode »). Ligne du 3114 toujours affichée avec le guide Moral. **Résultat : 40 cas sur 40, 17 questions nouvelles sur 17 après correction, aucun recul sur le cycle 1 ; 33 tests réussis.**

**Écarts avec l'évaluateur, à trancher par Benjamin.** « la sirène sonne » et « séisme » seuls : réponse directe (mise à l'abri, avec la consigne de la corne de brume ; séisme « pendant » et « après ») plutôt qu'une question qui retarde l'action. Fumée dans l'escalier : urgence (bandeau 15, 112), comme au cycle 1. Le passage « Odeur de gaz : éloignez-vous et appelez les secours » avait été déclaré absent à tort (recherche sensible aux majuscules) : il existe dans le guide « Rentrer chez soi » et est affiché depuis le 27/11/2026 (correction au moment des cycles 3 à 6).

**Avocat du diable.** 37 sur 40 au premier passage ; 13 sur 20 sur des questions nouvelles avant correction, dont une erreur grave (« ma rue est une piscine » déclenchait la règle de noyade et le 15).

## 2026-11-27 : cycles 3 à 6 de l'assistant intégrés

**Entrée.** Un document Word de Benjamin avec quatre livrables de l'évaluateur (160 cas) : préparation et coupures ; survie ; après la crise, cyber et désinformation ; Espace mairie ; plus un point d'arbitrage général.

**Mesure de départ.** 14 cas réussis sur 160 : sur des thèmes jamais travaillés, l'assistant échouait presque toujours.

**Travail fait.** (1) Détection de la détresse suicidaire en tête du triage, avec le 3114 et un bouton d'appel. (2) Une trentaine de cas hors périmètre. (3) Guides de l'Espace mairie exclus de la recherche des particuliers, activés par des mots d'élu ou d'agent. (4) Clarifications pour les demandes courtes. (5) Aiguillages par thème (`SijamaisCore/Themes.swift`). (6) Composition des réponses : procédures et listes courtes entières avec leur titre, mises en garde toujours affichées, 14 lignes au plus. (7) Guides jamais reformulés : risques, eau, cueillette, retour, assurance, cyberattaque, cyberattaque de la commune, monoxyde. (8) Correction d'une erreur du cycle 2 : le passage « Odeur de gaz : éloignez-vous et appelez les secours ou l'urgence gaz » existe bien (guide Retour) et est maintenant affiché. **Résultat : 128 cas sur 160 ; les 32 échecs restants sont marqués « échec connu » avec leur cause ; 38 tests réussis, sans recul sur les cycles 1 et 2.**

**Avocat du diable.** Sur 16 questions nouvelles, 9 bonnes avant correction, dont une erreur grave : « je veux plus vivre » ne déclenchait aucune alerte. Liste élargie, resserrée contre les fausses alertes (« pendre le linge »), et testée. Les échecs connus montrent la limite de la recherche par mots : une bonne réponse assemble souvent plusieurs guides.

**En attente de Benjamin.** Arbitrages listés dans `contenus/assistant/arbitrages_cycles_1_a_6.md`.

## 2026-11-27 : arbitrages validés, guides 1.2

**Décision de Benjamin.** « OK sur tout » sur les 13 arbitrages de `contenus/assistant/arbitrages_cycles_1_a_6.md`.

**Travail fait.** Guides 1.2 (`outils/construire_guides_v12.py`) :
- Stocks aligné sur l'interdiction du guide Monoxyde.
- Cueillette transformé en guide de prudence ; les fiches de plantes sont mises de côté.
- Eau : méthode à l'eau de Javel retirée, schéma corrigé.
- Numéros : numéro vert du signal d'alerte retiré, 196 confirmé, 0 800 112 112 ajouté.
- Assurance actualisé : délais de versement, franchise, hébergement.

Application, fichier Word (`SIJAMAIS_guides_v1.2.docx`) et maquette régénérés.

Autres travaux :
- Brouillons AVC, étouffement du nourrisson et hypothermie, hors application, à relire par un formateur PSC1.
- Interrupteur « Espace mairie » dans les réglages.
- Liens directs vers les outils des guides sous les réponses.

Environnement cloud : sites officiels ajoutés au réseau autorisé, avec l'accord de Benjamin dans l'invite d'autorisation. **39 tests réussis.**

**Non fait.** Numéros GRDF et Enedis : pages officielles illisibles automatiquement (accès refusé ou numéro chargé par script), donc non ajoutés. Garantie tempête : pas de page officielle trouvée. Guide Retour : pas de source plus récente que 2010 trouvée.

## 2026-11-27 : écran « S'équiper » et liens affiliés

**Décision de Benjamin.** Mélanger conseil neutre et liens affiliés Amazon, pour une deuxième source de revenus. Argument retenu : certaines communes n'ont pas les commerces nécessaires pour le kit 72 h. Mes réserves (image auprès des mairies, revenus modestes) ont été données ; la décision est prise.

**Travail fait.**
- Catalogue de 39 articles tirés mot pour mot des listes des guides (`contenus/equipement/catalogue_v1.json`, script `outils/construire_catalogue.py`). Chaque article indique les commerces où le trouver ; 31 peuvent porter un lien Amazon vers une recherche, sans marque.
- Pas de lien pour les médicaments, le lait infantile, l'eau, la nourriture, les pansements, le thermomètre et les masques.
- Écran « S'équiper » : tuile à l'accueil et lien en bas des guides concernés. Une case par article coche aussi la liste du guide ; filtre « seulement ce qui me manque ».
- Jamais de lien dans l'urgence ni dans l'assistant. Aucun lien tant que l'identifiant Amazon Partenaires n'est pas renseigné.
- Mode d'emploi et points à vérifier dans `contenus/equipement/README.md`. 44 tests réussis.

**Choix de placement.** Pas de sixième onglet (5 au plus sur iPhone, barre déjà pleine) : écran à un geste depuis l'accueil et les guides. À revoir si Benjamin préfère échanger avec un onglet existant.

## 2026-11-27 : retours d'essai de Benjamin sur l'assistant (5 captures)

**Constat.** Les trois premières captures venaient d'une version antérieure (Javel encore présente) : « comment faire du feu », la baignoire et « je viens de poignarder quelqu'un » étaient déjà corrigés dans la version actuelle. Restaient cinq problèmes réels.

**Corrections.**
1. « J'ai marché sur un clou » renvoyait au guide Assurance : « marche » était trouvé à l'intérieur de « démarche ». Le moteur ne reconnaît plus un mot qu'au début d'un mot du guide.
2. Fractures et entorses (« je me suis cassé la jambe ») : message d'orientation (15 ou 112, et la consigne de compression si ça saigne abondamment).
3. Objet qui perce la peau (clou, épine, verre) : pharmacien ou médecin, « Ne retirez jamais un objet planté ».
4. « Je saigne de la tête » : les boutons disent « ça saigne beaucoup » au lieu de « il saigne ».
5. Le modèle d'Apple commentait les passages (« Le premier guide « stocks »... ») au lieu de répondre :
   - sa consigne lui interdit de parler des passages et des guides ;
   - une réponse qui dit « ne mentionnent pas » ou « aucune information » devient « pas de guide » ;
   - une réponse qui commente les passages est refusée, et le guide s'affiche tel quel.

« J'ai faim » renvoie désormais au guide Stocks. 7 questions de Benjamin ajoutées aux tests ; 45 tests réussis.

## 2026-11-27 : parcours guidé dans l'assistant

**Constat de Benjamin.** Essais en famille et avec des amis : la plupart des réponses tombent à côté, parce que l'assistant dépend des mots-clés. Demande : guider la personne par des questions à choix.

**Travail fait.** Arbre de décision (`contenus/assistant/parcours_v1.json`, construit par `outils/construire_parcours.py`) : 8 situations de départ, 14 questions, 67 fins de parcours. Chaque fin passe par le moteur de l'assistant déjà testé ; un test vérifie que les 67 mènent au guide et au mode attendus (65 sur 67 au premier essai ; deux trous du moteur corrigés : « grand froid » et « sac d'évacuation »). L'onglet Assistant s'ouvre sur « Être guidé pas à pas » ; un bouton près de la saisie relance le parcours. 47 tests réussis.

## 2026-11-27 : ressources premium (randonnée, mer, voyage) et Espace enfants

**Demande de Benjamin.** Chercher les ressources des modes premium randonnée, navigation et voyage international, et étudier un Espace enfants pour les parents.

**Travail fait.** `15_premium_rando_mer_voyage_kids.md` : sources officielles et droits de réutilisation par mode, outils premium proposés, Espace enfants (contenu par âge, règles Apple et CNIL, gratuit ou payant), ordre proposé et démarches. Questions PK1 à PK5 ajoutées.

**Points saillants.** SCAN 25 exclu de la Licence Ouverte ; marées du Shom sous licence payante ; conseils aux voyageurs sans jeu de données ouvert ; tracés GR revendiqués par la FFRandonnée ; bulletin avalanche et Plan IGN réutilisables ; Division 240 modifiée le 21 mai 2026. Espace enfants : hors catégorie « Enfants » de l'App Store, sans lien Amazon ni assistant libre, aucune donnée envoyée.

**Décision de Benjamin.** « Oui je suis ok » : ordre enfants, randonnée, voyage, mer ; écran d'aide enfant gratuit, parcours et jeux dans la version famille ; profil enfant dans l'application ; demandes aux organismes. Brouillons des courriers à l'IGN, au Shom et au ministère des Affaires étrangères dans `courriers/`, à relire et signer par Benjamin. Rien n'a été envoyé.

## 2026-11-27 : Espace enfants, contenu et maquette

**Travail fait.**
- Contenu : `contenus/enfants/parcours_v0.1.json` (script `outils/construire_enfants.py`), 13 modules et 24 mises en situation, deux tranches (6-10 ans avec un parent, 10-14 ans seul). Vocabulaire de l'école (« Apprendre à porter secours », « Gestes qui sauvent », PPMS), consignes reprises des guides 1.2. Mode d'emploi et points à relire dans `contenus/enfants/README.md`.
- Maquette : 21 écrans (script `outils/integrer_enfants_maquette.py`), entrée depuis Famille. Vérifiée dans un navigateur : aucun lien mort, aucune erreur, aucun lien externe dans l'espace enfants, verrou famille vers « Demande à tes parents ».

**Choix faits.** Gratuits : « J'ai besoin d'aide », la carte « Montrer à un adulte », « Appeler les secours » (6-10), « Alerter les secours » et « Besoin d'en parler » (10-14), parce qu'ils protègent. Barre d'onglets masquée dans l'espace enfants : sans cela, l'enfant pouvait rejoindre l'assistant sans contrôle parental. Pas de contenu « attentat-intrusion ».

**Remarqué en passant.** Le guide « Numéros d'urgence » (guides 1.2) contient deux fois le 196 (« Secours en mer » et « Urgence en mer »).

## 2026-11-27 : parcours guidé sans effet (vidéo de Benjamin)

**Constat.** Sur la vidéo, le bouton « Être guidé pas à pas » ne fait rien, et les questions tapées ne s'affichent pas.

**Cause probable.** Le fichier du parcours (`parcours.json`) n'était pas dans l'application compilée : XcodeGen n'ajoute un nouveau fichier de ressources qu'après `xcodegen generate`. Sans lui, le bouton n'avait aucun effet et rien ne le signalait. Pour la saisie : le champ fait plusieurs lignes, et la touche Entrée y ajoutait un retour à la ligne au lieu d'envoyer.

**Corrections.**
- Le parcours et la liste d'équipement sont embarqués dans SijamaisCore, et donc inclus à chaque compilation.
- La touche Entrée envoie la question.
- Si le parcours manque malgré tout, l'assistant le dit au lieu de ne rien faire.
- 48 tests réussis.

## 2026-11-27 : parcours pas à pas du plan familial

**Demande de Benjamin.** Le parcours guidé de l'assistant est validé (« génial, c'est parfait ») ; même système pour la partie Famille.

**Travail fait.**
- La tuile « Famille » ouvre un écran avec trois éléments : l'avancement du plan, l'assistant « Construire mon plan pas à pas », et une carte d'urgence à partager.
- L'assistant compte 12 étapes, avec des choix rapides et un champ libre. Les réponses remplissent les champs du guide « Mon plan familial ». Les risques cochés emportent leur consigne mot pour mot.
- Fichiers : `contenus/famille/`, `outils/construire_famille.py`, `SijamaisCore/PlanFamilial.swift`, `Views/FamilleView.swift`.
- 51 tests réussis.

## 2026-11-27 : Espace enfants dans l'application

**Décision de Benjamin.** « go » pour intégrer l'Espace enfants, priorité 1 du plan premium (`15_premium_rando_mer_voyage_kids.md`).

**Travail fait.**
- Contenu `contenus/enfants/parcours_v0.1.json` embarqué dans SijamaisCore : 13 modules, 24 mises en situation.
- Tuile « Espace enfants » à l'accueil. L'espace s'ouvre en plein écran : ni barre d'onglets, ni assistant, ni lien vers l'extérieur, ni achat.
- Pour sortir, un contrôle parental : une multiplication, comme Apple le recommande.
- Deux tranches d'âge : 6 à 10 ans et 10 à 14 ans.
- Chaque module se déroule en trois temps :
  - la leçon, phrase par phrase ;
  - le quiz, où une mauvaise réponse est expliquée sans gronder, avec « Réessayer » ;
  - un badge étoile à la fin.
- Écran « J'ai besoin d'aide », gratuit : appeler un parent, appeler le 112, montrer sa carte.
- Carte « Montrer à un adulte » : remplie par un parent après le contrôle parental, gardée chiffrée dans le trousseau de l'iPhone, jamais copiée vers un autre appareil.
- Les modules payants portent la mention « Version famille », mais restent ouverts tant que l'abonnement n'est pas codé.
- Tests : chaque quiz a une seule bonne réponse expliquée ; aucune adresse internet, sauf le tchat du 119 en texte simple ; modules gratuits conformes à l'offre. 56 tests réussis.

**Avant diffusion.** Relectures prévues dans `contenus/enfants/README.md` : formateur PSC1, enseignant du primaire, gendarme ou policier.

## 2026-11-27 : écran Premium et abonnement (StoreKit 2)

**Décision de Benjamin.** « ok » pour l'étape 1 : écran Premium et abonnement en mode test.

**Travail fait.**
- Offres et règles dans SijamaisCore : 4 abonnements aux prix décidés ; 4 univers (Enfants disponible ; Randonnée, Voyage, Mer annoncés « bientôt ») ; liste de ce qui reste gratuit.
- Moteur d'abonnement StoreKit 2 : achat, achat en attente, restauration, Partage familial, remboursements.
- Écran Premium, accessible par une tuile à l'accueil et par les réglages.
- Verrouillage des 10 modules « version famille » de l'Espace enfants, sans aucun achat possible côté enfant.
- Fichier de test StoreKit branché au schéma Xcode, pour essayer sans compte Apple Developer.
- Démarches de mise en vente dans `contenus/premium/README.md`. 59 tests réussis.

**À faire par Benjamin avant la vente.** Compte Apple Developer et contrat des applications payantes ; création des 4 abonnements avec les mêmes identifiants ; conditions d'utilisation et politique de confidentialité.

## 2026-11-27 : mode Randonnée et montagne (première version)

**Décision de Benjamin.** « ok » pour le mode Randonnée, priorité 2 du plan premium.

**Travail fait.**
- **« Alerter les secours en montagne », gratuit**, aussi accessible depuis l'écran Urgence :
  - position GPS en degrés décimaux et en degrés, minutes, secondes, avec l'altitude et la précision ;
  - message à lire au 112 dans l'ordre demandé par les secours (qui, où, combien, quoi, météo) ;
  - gros bouton 112 et conseils (112 même téléphone verrouillé, rester sur place, économiser la batterie). Sources : PGHM des Hautes-Alpes, FFME.
- **Fiche de sortie, premium** :
  - itinéraire, départ, retour, participants, véhicule, proche à prévenir ;
  - message prêt à envoyer par SMS ou à partager ;
  - « Je pars » programme deux rappels locaux, à l'heure de retour puis une heure après ;
  - un bandeau rouge propose d'appeler le proche ou le 112 si l'heure est dépassée ;
  - aucune alerte n'est jamais envoyée automatiquement.
- **Guides utiles en accès libre** : orientation, signaux, priorités, trousse de survie, eau, abri.
- L'univers Randonnée passe à « Disponible » dans l'écran Premium. 62 tests réussis.

**À venir.** Bulletin avalanche de Météo-France, carte de France entière hors ligne (palier E des cartes), contenus officiels du ministère des Sports à intégrer aux guides.
