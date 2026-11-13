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
