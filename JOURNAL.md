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
