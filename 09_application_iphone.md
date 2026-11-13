# 09. MECUM, application iPhone gratuite avec version complète

Rédigé le 13 novembre 2026. Ce document remplace, pour le produit, la plateforme et les finances, les parties correspondantes de `03_produit_technique.md`, `05_finances.md` et `06_acquisition_marque.md`, qui restent valables pour le marché, le cadre légal, la charte éditoriale et la méthode de test. Chiffres issus de `modele_financier.xlsx` (version 2, 4 169 formules recalculées sans erreur). L'ancien modèle (pack et téléphone) est archivé dans `archives/`. Marqueurs : [FAIT], [EST], [HYP], [INT].

## 1. Décisions prises par Benjamin (12 et 13 novembre 2026)

| Sujet | Décision |
|---|---|
| Produit | Une application locale, hors ligne, sur des téléphones ordinaires. Plus de téléphone durci ni de carte mémoire au lancement |
| Nom de travail | MECUM |
| Modèle | Partie gratuite et version payante, sur le principe de HAVEN |
| Plateforme | iPhone d'abord. Pas d'Android au lancement |
| Identité visuelle | Ne pas ressembler à un produit "fait avec une IA". A travailler dans un second temps avec un graphiste |
| Disponibilité | 3 à 4 mois sans revenu. Prêt à produire des contenus chaque semaine |

## 2. Trois constats à garder en tête

1. **Le choix de l'iPhone est défendable, mais pas pour la raison avancée.** L'iPhone représente environ 34 à 36 % des smartphones en France, Android près de 65 % [FAIT, StatCounter mars et avril 2026, via presse]. Ce n'est donc pas "la plupart" des Français. En revanche, la cible (foyers aisés, 60 % des détenteurs de kit d'urgence sont de catégories supérieures) est probablement plus équipée en iPhone que la moyenne, les utilisateurs d'iPhone paient davantage dans les applications, et l'iPhone apporte gratuitement une IA locale en français (section 4). Je valide l'iPhone d'abord, et la page de test mesurera la demande Android.
2. **Le modèle à achat unique rapporte peu par client.** A 24,99 € TTC, Apple reverse la TVA et garde 15 % : il reste 21,24 € par achat [FAIT pour la commission, Apple, août 2026]. Une installation rapporte en moyenne 1,69 € dans le scénario central. Il faut des dizaines de milliers d'installations pour faire vivre une personne.
3. **Le projet ne peut pas te payer dans tes 3 à 4 mois de réserve.** Il faut un mois de test et trois à quatre mois de développement avant le premier euro. Dans le scénario central, le projet peut te verser l'équivalent de 1 500 € nets à partir du mois 30. Il faut donc organiser un revenu à côté à partir du mois 4 (section 8). C'est le point le plus important de ce document.

## 3. HAVEN : ce que la nouvelle capture apprend

| Offre | Prix [FAIT, capture du 13/11/2026] | Contenu |
|---|---|---|
| Gratuit | 0 | Premiers secours, cartes, bibliothèque, famille, inventaire, petit assistant |
| Pro à vie | 29,99 USD | 16 scénarios, identification de plantes, analyse par photo |
| Pro Family | 59,99 € | Pro pour un cercle familial |
| Watch | 29,99 € par an ou 3,99 € par mois, essai de 7 jours | Pro inclus, veille des conflits, alertes de catastrophes, suivi de la posture nucléaire, notifications |
| Watch Family | En plus de Pro Family | Carte familiale en direct, lieux, historique de 7 jours |

Deux enseignements :

- les prix de HAVEN ont monté. La fiche de l'App Store indiquait 24,99 USD et 34,99 USD lors de la recherche du 12 novembre ; l'application affiche 29,99 USD et 59,99 €. Le marché accepte ces niveaux ou HAVEN les teste ;
- HAVEN fait de la peur son revenu récurrent : conflits, nucléaire, menaces. MECUM ne le fera pas. Cela nous prive d'un abonnement facile, et c'est assumé. Un abonnement MECUM ne pourra porter que sur un service réel et calme (mises à jour des cartes et du corpus, synchronisation familiale), à étudier en année 2.

Tu confirmes aussi que les guides de HAVEN n'ont ni source, ni auteur, ni date, et que le contenu est en anglais par défaut (traduction automatique en option). C'est notre différence principale : des fiches françaises, signées, datées, sourcées.

Ce que tu as le plus aimé, la prise en main en quelques questions puis le téléchargement immédiat de la carte locale et du modèle, devient une exigence de la v1 (section 5).

## 4. Ce que l'iPhone change techniquement

| Sujet | Sur iPhone | Conséquence |
|---|---|---|
| Langage | Swift et SwiftUI, outils Apple | Développement sur Mac obligatoire. Question : as-tu un Mac ? |
| Compte développeur | Programme développeur Apple, 99 € par an [A CONFIRMER] | Au nom de la société, pour afficher "MECUM" et non ton nom |
| Commission | 15 % avec le programme petites entreprises, 26 % sinon, nouvelles conditions européennes au 1er octobre 2026 [FAIT, Apple] | Inscription au programme dès la création du compte |
| IA locale | Le cadre "Foundation Models" d'Apple donne accès gratuitement au modèle de langage intégré à l'iPhone, en français, hors ligne, sur iPhone 15 Pro et modèles suivants avec Apple Intelligence activé, depuis iOS 26 [FAIT, presse spécialisée, liste exacte des langues à vérifier] | Pas de modèle à embarquer ni à télécharger sur ces téléphones. Sur les autres, recherche seulement. C'est un avantage net sur HAVEN, dont le petit modèle fait planter l'application |
| Cartes hors ligne | MapLibre (licence BSD) et fichiers de carte vectorielle Protomaps à partir d'OpenStreetMap (ODbL) [à confirmer] | Un département téléchargé à l'installation, la France entière dans la version complète |
| Encyclopédie | La brique de lecture Kiwix est sous licence GPL [à confirmer]. Le code GPL est juridiquement délicat sur l'App Store | Ne pas l'embarquer. Construire notre propre base à partir des contenus libres (Wikipédia, Vikidia, Wikilivres sous CC BY-SA), au format SQLite, avec la même recherche que le prototype |
| Recherche | SQLite et sa recherche plein texte sont intégrés à iOS | Le moteur du prototype se porte tel quel |
| Stockage | Pas de carte mémoire sur iPhone. Téléchargements depuis notre serveur ou depuis Apple | Corpus de base léger (moins de 2 Go), compléments à télécharger |
| Remplacement de l'écran d'accueil | Impossible sur iPhone | Raccourcis et widget à la place |

## 5. Périmètre de la v1

### Prise en main en deux minutes

1. "Pour quoi voulez-vous MECUM ?" : la maison, la randonnée, la mer, la route, la famille (plusieurs choix).
2. "Où vivez-vous ?" : département, proposé à partir de la position si l'utilisateur l'autorise.
3. "Combien êtes-vous au foyer ? Des enfants, des personnes âgées, des animaux ?"
4. L'application télécharge la carte du département et prépare le kit de 72 heures adapté au foyer.
5. Si le téléphone le permet : "Voulez-vous activer l'assistant ? Il fonctionne sans réseau et cite ses sources."

### Gratuit et payant

Règle de conduite : **tout ce qui protège est gratuit. On paie pour la profondeur et le confort.**

| | Gratuit | Version complète (24,99 € à tester) |
|---|---|---|
| Urgence | Numéros, position, lampe, signal lumineux, 15 fiches vitales relues | Idem |
| Fiches | Toutes les fiches de sécurité : secours, eau, coupure, inondation, canicule, froid, évacuation | Fiches d'approfondissement : autonomie, randonnée, mer, jardin, réparations, cuisine sans courant |
| Préparation | Kit de 72 heures selon le guide officiel, plan du foyer, score de préparation | Inventaire complet, dates de péremption, objectif 14 jours, plusieurs foyers |
| Cartes | Un département hors ligne avec points utiles (défibrillateurs, points d'eau, secours) | France entière, relief, traces enregistrées |
| Bibliothèque | Sélection courte, import de ses propres PDF | Encyclopédie complète en français, rayon enfants par niveau |
| Assistant | Recherche dans les fiches | Recherche dans toute la bibliothèque, assistant qui cite ses sources (iPhone 15 Pro et suivants) |
| Famille | | Version famille (49,99 € à tester) : partage de la version complète, plan du foyer commun |

Ecarté de la v1 : veille en ligne, maillage Bluetooth, identification par photo, Android, téléphone et carte mémoire.

## 6. Finances (scénarios du modèle version 2)

### Ce que rapportent un achat et une installation

| | Prudent | Central | Ambitieux |
|---|---|---|---|
| Prix TTC de la version complète | 19,99 € | 24,99 € | 29,99 € |
| Prix moyen payé (avec la version famille) | 22,99 € | 29,99 € | 37,49 € |
| Revenu net par achat, après TVA et commission | 16,28 € | 21,24 € | 26,56 € |
| Part des nouveaux utilisateurs qui achètent dans le mois | 2 % | 3,5 % | 5 % |
| Revenu net attendu par installation | 0,66 € | 1,69 € | 3,18 € |
| Coût d'une installation payante | 4,00 € | 2,50 € | 1,50 € |
| Revenu par euro de publicité | 0,17 € | 0,68 € | 2,12 € |

La publicité ne rapporte plus qu'elle ne coûte que dans le scénario ambitieux. Comme dans la première version du dossier, l'acquisition doit être gratuite : référencement dans l'App Store, contenus, presse, bouche à oreille.

### Résultats sur 36 mois

| | Prudent A1 | A2 | A3 | Central A1 | A2 | A3 | Ambitieux A1 | A2 | A3 |
|---|---|---|---|---|---|---|---|---|---|
| Installations | 1 600 | 4 300 | 5 700 | 6 700 | 21 000 | 34 300 | 27 100 | 106 000 | 215 500 |
| Achats | 40 | 140 | 210 | 290 | 1 130 | 2 070 | 1 660 | 7 740 | 17 400 |
| Revenu net de l'application | 700 | 2 300 | 3 400 | 6 100 | 23 900 | 44 000 | 44 000 | 205 400 | 462 000 |
| Licences communes | 0 | 0 | 0 | 200 | 7 200 | 20 900 | 1 500 | 21 600 | 66 000 |
| Charges, publicité comprise | 26 500 | 12 400 | 14 300 | 29 600 | 34 800 | 58 000 | 43 100 | 89 200 | 161 000 |
| dont ta rémunération | 0 | 0 | 0 | 0 | 12 000 | 24 000 | 0 | 30 000 | 48 000 |
| EBITDA | -25 800 | -10 100 | -10 900 | -23 300 | -3 700 | 6 900 | 2 300 | 137 800 | 367 000 |

| Indicateur | Prudent | Central | Ambitieux |
|---|---|---|---|
| Fonds propres apportés | 30 000 € | 35 000 € | 35 000 € |
| Perte cumulée maximale | -46 900 € | -28 800 € | -22 900 € |
| Mois où le projet peut te payer 1 500 € nets | Jamais | Mois 30 | Mois 8 |
| Trésorerie | Négative dès le mois 17 | Toujours positive, au plus bas 1 000 € | Positive (creux de 400 € au mois 4) |
| Valorisation indicative (2,5 à 4,5 fois l'EBITDA de l'année 3) | 0 | 17 000 à 31 000 € | 0,9 à 1,7 M€ |

Lecture :

- **Central** : une petite application qui couvre ses frais en année 3 et te paie peu, après avoir consommé 35 000 € de tes fonds propres. Ce n'est pas un projet de cession.
- **Ambitieux** : une application de référence, 18 000 installations par mois en année 3, une vraie valeur de cession. Il suppose 1 500 installations dès le premier mois et 14 % de croissance mensuelle pendant un an. C'est le profil d'une application mise en avant par Apple ou relayée par de grands médias. Probabilité faible [INT : 5 à 10 %].
- **Prudent** : à arrêter. Les critères d'arrêt le détectent avant le mois 9.

### Le point mort en une ligne

Avec les charges de l'année 2 du scénario central (2 350 € par mois, dont 1 000 € de rémunération), il faut 110 achats par mois à 24,99 €, soit environ 3 700 installations par mois à 3 % de passage au payant (feuille `Sensibilites`, grilles 1 et 2).

## 7. Une piste à tester tout de suite : les communes

Ton métier, c'est la vente aux grands comptes et aux collectivités. Le modèle grand public n'utilise pas ce talent. Une piste l'utilise :

- 22 000 communes doivent tenir un plan communal de sauvegarde, et les communes exposées à un risque majeur doivent informer leurs habitants (document d'information communal sur les risques majeurs, mis à jour au moins tous les 5 ans) [FAIT, ministère de l'Ecologie et AMF] ;
- proposer aux communes un module MECUM : les consignes et les lieux de leur plan (points de rassemblement, numéros, risques locaux), disponibles hors ligne dans l'application gratuite de leurs habitants. La commune paie une licence annuelle (600 à 1 200 € à tester) ;
- c'est cohérent avec la règle "la sécurité est gratuite pour l'habitant", et c'est un revenu récurrent qui ne repose pas sur la peur.

Concurrence : des applications communales d'information et d'alerte existent déjà (IntraMuros, Illiwap, Alerte Citoyens) [FAIT]. Elles diffusent des messages en ligne. Aucune ne semble proposer un contenu de préparation hors ligne, mais elles peuvent l'ajouter. Le modèle n'en tient compte que modestement (12 à 21 000 € par an en année 3 dans le central). Si dix rendez-vous en mairie montrent un intérêt réel, cette piste peut devenir le moteur du projet. Elle est testée dès le plan à 30 jours.

## 8. Ton temps et ton revenu

| Période | Ce qui se passe | Ton revenu |
|---|---|---|
| Mois 1 | Test de demande, entretiens, devis | Ta réserve |
| Mois 2 à 4 | Société, développement de la v1, fiches, identité visuelle | Ta réserve, épuisée vers le mois 4 |
| Mois 5 à 12 | Sortie, contenus chaque semaine, améliorations | Il faut un revenu extérieur |
| Année 2 | Croissance si les seuils sont franchis | 1 000 € chargés par mois dans le central, insuffisant seul |

Options, de la plus sûre à la plus risquée :

1. **Un emploi ou une mission à temps partiel à partir du mois 4**, dans la vente B2B que tu connais. MECUM devient un projet de deux à trois jours par semaine. C'est ma recommandation.
2. **Les allocations chômage, si tu y as droit.** Elles changent tout : le maintien des allocations pendant la création finance le développement sans pression. Je ne sais pas si c'est ton cas (question ouverte).
3. **Le prêt d'honneur.** Il est fait pour cela : jusqu'à quelques dizaines de milliers d'euros à taux zéro, à la personne. Il ne se décroche qu'avec des premiers résultats, donc pas avant le mois 6 au mieux.
4. **Tout miser sur le projet sans revenu.** Je le déconseille : il te mettrait en difficulté personnelle vers le mois 5, au moment exact où le projet a besoin de calme et de régularité.

## 9. Recommandation mise à jour

**Go pour le test de 30 jours, avec deux questions au lieu d'une :**

1. des iPhoniens français préfèrent-ils une application française vérifiée à HAVEN, au point d'envisager de payer 24,99 € ? (page de test et entretiens) ;
2. des communes paieraient-elles un module de plan de sauvegarde hors ligne ? (dix rendez-vous en mairie)

Engagement maximal avant la décision : 2 100 € (page, publicité de test, iPhone d'occasion pour tester l'assistant, entretiens).

Niveaux de confiance mis à jour [INT] :

| Affirmation | Confiance |
|---|---|
| Le test donnera un signal exploitable | Elevée (80 %) |
| L'application grand public franchit les seuils du test | Faible (25 à 35 %) |
| La piste des communes montre un intérêt réel | Inconnue. C'est précisément ce que le test doit dire |
| Le projet te verse un revenu complet avant 24 mois | Faible (10 à 15 %) |

## 10. Ce qui change dans les autres livrables

| Livrable | Statut |
|---|---|
| `modele_financier.xlsx` | Refait (version 2). L'ancien est dans `archives/` |
| `prototype/mvp_logiciel/SPECIFICATION.md` | Réécrite pour iPhone (version 0.2) |
| `prototype/landing/` | Adaptée : application gratuite, version complète, test de prix, intérêt Android et communes |
| `plan_30_jours.md` | Adapté : iPhone de test, comparaison avec HAVEN, rendez-vous en mairie, devis de développeurs iOS |
| `00_SYNTHESE_DECISION.md`, `questions_ouvertes.md`, `registre_hypotheses.md`, `JOURNAL.md` | Mis à jour |
| `02_concurrence.md` | Correction : HAVEN propose une interface en français |
| `03`, `05`, `06` | Bandeau de renvoi vers ce document |

## Sources ajoutées le 13/11/2026

| Source | Ce qu'elle établit |
|---|---|
| Tech-Insider, "Android vs iOS 2026" (StatCounter). https://tech-insider.org/fr/android-vs-ios-2026/ | France, mars 2026 : Android 65,1 %, iOS 34,5 % |
| Apple Newsroom, changements pour les applications dans l'Union européenne (août 2026). https://www.apple.com/gn/newsroom/2026/08/apple-announces-changes-for-apps-in-the-european-union/ ; MacRumors. https://www.macrumors.com/2026/08/18/eu-app-store-fee-change/ | Commission de 15 % pour le programme petites entreprises, 26 % au taux standard, au 1er octobre 2026 |
| InfoQ, "Apple Foundation Models iOS 26". https://www.infoq.com/news/2025/07/apple-foundation-models-ios26 ; Phonearena. https://www.phonearena.com/news/apple-announces-foundation-models-framework-to-give-developers-direct-access-to-apple-intelligence_id171162 | Modèle local d'Apple accessible gratuitement aux développeurs, iPhone 15 Pro et suivants, français pris en charge |
| Ministère de l'Ecologie, guide des bonnes pratiques de résilience territoriale. https://www.ecologie.gouv.fr/sites/default/files/documents/Guide%20des%20bonnes%20pratiques%20de%20resilience%20territoriale.pdf | Obligation du document d'information communal sur les risques majeurs |
| Illiwap, IntraMuros, Alerte Citoyens (fiches éditeurs). https://www.illiwap.com/media/1416/download/fr_mairie.pdf?v=1 ; https://www.getapp.fr/software/2070387/intramuros | Applications communales d'information et d'alerte existantes |
| Captures d'écran de HAVEN fournies par Benjamin, 12 et 13/11/2026 (non versées au dépôt) | Offres et prix de HAVEN, absence de sources dans les guides |
