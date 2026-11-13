# 03. Faisabilité produit et technique

> **Mise à jour du 13/11/2026.** Le produit a changé : application iPhone gratuite avec version complète. Pour le matériel, la plateforme et l'architecture, la référence est désormais `09_application_iphone.md`. Ce document reste valable pour l'analyse de l'IA locale, des contenus et de leurs licences.

Document de la phase 1 du projet HUMAN, rédigé le 12 novembre 2026. Les identifiants S renvoient à `sources.md`, les identifiants H à `registre_hypotheses.md`. Marqueurs : [FAIT], [EST], [HYP], [INT]. La spécification détaillée du logiciel est dans `prototype/mvp_logiciel/SPECIFICATION.md`.

## 1. Conclusion

1. Le produit est faisable techniquement avec le budget, à une condition : ne pas fabriquer de téléphone. Tout ce qu'il faut existe déjà, en logiciel libre et en matériel du commerce.
2. Fabriquer ou importer un téléphone sous notre marque n'est pas faisable avec 10 000 à 40 000 €. Les obligations du fabricant (cinq ans de mises à jour, sept ans de pièces détachées, essais radio et cybersécurité) dépassent à elles seules l'enveloppe (voir `04_legal.md`).
3. L'IA locale fonctionne sur un téléphone durci récent, lentement mais utilement : 5 à 10 mots par seconde. Son coût en énergie est négligeable sur une grosse batterie. Sa vraie limite est la fiabilité : elle doit citer ses sources et s'effacer derrière des fiches validées pour tout ce qui touche à la santé.
4. Il y a une contradiction dans le cahier des charges initial entre "minimaliste, basse consommation" et "IA locale". Un modèle de langage exige une puce récente et 8 Go de mémoire au moins. On la résout en faisant de l'IA une fonction à la demande, et de la recherche documentaire le mode normal.
5. Le produit défendable est le logiciel et le corpus en français. Je propose de le livrer sous trois formes : téléchargement, carte mémoire préchargée, téléphone du commerce accompagné de la carte.

## 2. Matériel

### 2.1 Téléphones candidats

| Modèle | Batterie | Puce, mémoire | Poids | Prix public | Vitesse estimée de l'IA locale | Avis |
|---|---|---|---|---|---|---|
| Ulefone Armor 22 Pro [S42] | 6 600 mAh | Helio G200, 8 Go | Non relevé | 239,99 USD au lancement, environ 190 à 200 € TTC en Europe [EST] | Environ 5 jetons par seconde [EST] | Candidat "Essentiel" |
| Ulefone Armor 24 Pro [S42] | 22 000 mAh | Helio G200, 12/256 Go | 647 g | 359,99 USD au lancement, dès 272 € TTC en Europe [FAIT] | Environ 5 jetons par seconde [EST] | Candidat "Autonomie" |
| Ulefone Armor 28 Pro [S42] | 10 600 mAh | Dimensity 7300, 16 Go | Non relevé | 529 USD attendu | Environ 10 jetons par seconde [FAIT pour cette puce, S48] | Meilleur pour l'IA, plus cher |
| Oukitel WP100 Titan [S41] | 33 000 mAh | Dimensity 7300, 16/512 Go | Très lourd | 620 à 980 € TTC | Environ 10 jetons par seconde | Trop cher, marque à risque de conformité [S58] |
| Samsung Galaxy XCover 7 [S43] | 4 050 mAh amovible | 6 Go | Léger | 330 à 400 € | Insuffisant pour l'IA (mémoire) | Option "grande marque" pour le B2B |

La vitesse sur Helio G200 est estimée par analogie avec des puces de même classe (environ 5 jetons par seconde sur Dimensity 7020 et 6100+ [S48]). A mesurer sur les trois téléphones de test du plan à 30 jours (H12).

### 2.2 Autonomie réelle

Une batterie de 22 000 mAh contient environ 85 Wh [EST : 22 Ah x 3,85 V]. Ordres de grandeur [EST] :

| Usage | Consommation estimée | Autonomie sur 85 Wh |
|---|---|---|
| Veille en mode avion, écran éteint | 0,5 à 1 Wh par jour | 3 à 5 mois théoriques |
| Usage sobre : 1 heure d'écran par jour, mode avion | 3 à 4 Wh par jour | 3 à 4 semaines |
| Usage courant avec réseau mobile | 6 à 10 Wh par jour | 8 à 14 jours |

Les promesses des fabricants ("deux semaines") sont du même ordre [S41]. Aucune de ces valeurs n'est mesurée. Une promesse commerciale d'autonomie devra reposer sur notre propre protocole de test, publié, sous peine de pratique commerciale trompeuse.

### 2.3 Radio

- Réception FM : présente sur beaucoup de téléphones durcis, non confirmée pour l'Armor 24 Pro [S42]. A vérifier modèle par modèle (H13). Le kit officiel recommande une radio à piles [S02] : une radio à manivelle à 25 € en accessoire est plus sûre que de promettre la FM sur le téléphone.
- Emission : certains modèles intègrent un talkie-walkie UHF ou VHF de forte puissance [S67]. Leur usage hors des canaux PMR446 à 500 mW exige une licence. A exclure du produit (voir `04_legal.md`).

### 2.4 Circuits d'approvisionnement

| Circuit | Quantité minimale | Prix d'achat estimé | Notre statut juridique | Faisable avec le budget |
|---|---|---|---|---|
| Détaillants et grossistes européens (exemple : BigBuy [S45]) | 1 pièce | Proche du prix public HT, soit environ 160 € (Essentiel) et 235 € (Autonomie) [HYP, H08] | Distributeur | Oui |
| Achat direct à la marque (service B2B d'Ulefone) | 50 à 100 pièces [HYP] | Environ 15 % de moins [HYP, H09] | Importateur | Oui à partir de l'année 2, avec mise en conformité |
| Fabricant sous marque blanche à Shenzhen [S46] | 100 à 1 000 pièces | 172 à 185 USD pour un modèle d'entrée de gamme | Fabricant | Non : obligations hors de portée |

Recommandation : rester distributeur tant que les volumes sont inférieurs à 500 téléphones par an. Le passage à l'import fait gagner 9 à 21 € par appareil après redevance pour copie privée, pour un coût fixe de mise en conformité de l'ordre de 6 000 € [EST]. Il se rentabilise au-delà de 400 à 450 unités par an.

## 3. Logiciel

### 3.1 Principe

Une application Android unique, qui fonctionne sans aucun réseau, organisée en quatre fonctions : chercher, lire, s'orienter, demander. Elle peut servir d'écran d'accueil (un lanceur Android est une simple application : aucune modification du système du téléphone n'est nécessaire).

```
+---------------------------------------------------------------+
|                    Application (Android)                      |
|  Accueil sobre : Urgence | Chercher | Cartes | Bibliothèque   |
+----------------------+----------------------+-----------------+
| Fiches réflexes      | Recherche unifiée    | Outils          |
| validées (français)  | plein texte          | lampe, SOS,     |
| premiers secours,    | + sémantique         | boussole,       |
| eau, feu, abri,      | (toujours active)    | position GPS,   |
| orientation, panne   |                      | listes de kit   |
+----------------------+----------+-----------+-----------------+
| Bibliothèque hors ligne         | Cartes hors ligne           |
| lecteur de fichiers ZIM (Kiwix) | OpenStreetMap vectoriel     |
| Wikipédia, WikiMed, Vikidia,    | France entière, relief,     |
| Wikilivres, manuels             | points d'eau, abris         |
+---------------------------------+-----------------------------+
| Assistant (optionnel, à la demande, 8 Go de mémoire minimum)  |
| petit modèle de langage local, réponses construites sur les   |
| passages retrouvés, sources affichées, coupé sous 15 % de     |
| batterie ou en cas de surchauffe                              |
+---------------------------------------------------------------+
| Stockage : carte mémoire de 128 ou 256 Go                     |
+---------------------------------------------------------------+
```

### 3.2 Briques réutilisées et licences

| Fonction | Brique | Licence | Conséquence |
|---|---|---|---|
| Lecture des encyclopédies hors ligne | Bibliothèque libkiwix et format ZIM [S31] | GPL version 3 [à confirmer] | Notre application devra être publiée en code ouvert si elle intègre cette brique. Acceptable : la valeur est dans le corpus, la marque et le service. Alternative : lancer l'application Kiwix officielle par lien |
| Cartes | Organic Maps ou MapLibre avec données OpenStreetMap [S53] | Apache 2.0 pour le code, ODbL pour les données | Mention d'attribution obligatoire |
| Modèle de langage | Gemma 4 E2B, 2,58 Go [S47, S49] | Apache 2.0 | Usage commercial libre |
| Moteur d'exécution du modèle | LiteRT-LM de Google ou llama.cpp | Apache 2.0, MIT | Libre |
| Recherche plein texte | SQLite FTS5 | Domaine public | Libre |
| Recherche sémantique | Petit modèle d'embeddings multilingue (100 à 300 Mo) | Apache 2.0 ou MIT selon le modèle | A choisir à la v2 |

Point de vigilance : Android et les services Google restent ceux du fabricant du téléphone. Nous n'y touchons pas. Une image système modifiée ferait de nous un fabricant et exigerait une nouvelle certification Google [S66].

### 3.3 Budget de stockage

| Contenu | Taille estimée | Statut |
|---|---|---|
| Wikipédia en français avec images | 30 à 40 Go | [EST] à vérifier sur le catalogue Kiwix (H14) |
| WikiMed en français, Wikilivres, Vikidia, Wiktionnaire | 3 à 8 Go | [EST] |
| Cartes vectorielles de France et pays voisins | 5 à 8 Go | [EST] |
| Modèle de langage et modèle d'embeddings | 3 Go | [FAIT, S47] |
| Fiches réflexes, guides officiels, manuels, livres du domaine public | 1 à 3 Go | [EST] |
| Total | 42 à 62 Go | Tient sur une carte de 128 Go, confortable sur 256 Go |

Une version "Essentiel" sans images (environ 20 Go) tient sur une carte de 64 Go ou dans la mémoire interne d'un téléphone récent.

### 3.4 L'IA locale : contraintes réelles

| Contrainte | Donnée | Conséquence pour le produit |
|---|---|---|
| Taille du modèle | 2,58 Go pour Gemma 4 E2B, 3,65 Go pour E4B [FAIT, S47] | Pas un problème de stockage |
| Mémoire vive | 6 Go au minimum pour E2B, 8 Go pour E4B [S47] | Exclut les téléphones d'entrée de gamme. 8 Go recommandés pour E2B |
| Vitesse | 47 à 52 jetons par seconde sur un téléphone haut de gamme de 2026, 10 sur Dimensity 7300, 5 sur une puce modeste [FAIT, S47, S48] | Réponse de 150 mots en 20 à 60 secondes sur nos téléphones. Acceptable si l'utilisateur est prévenu |
| Energie | 0,26 à 0,67 joule par jeton pour un modèle de 7 milliards de paramètres [FAIT, S50]. Soit 0,02 à 0,06 Wh par réponse de 300 jetons pour un modèle de 2 à 4 milliards [EST] | 100 questions par jour consomment 2 à 6 Wh, soit 2 à 7 % d'une batterie de 85 Wh. L'énergie n'est pas le facteur limitant |
| Chauffe | Ralentissement thermique signalé en usage prolongé [S47] | Limiter la longueur des réponses, couper l'assistant en cas de surchauffe |
| Fiabilité | Sur 22 questions de sécurité, 21 bonnes réponses pour les grands modèles, 14 pour un modèle léger [FAIT, S34] | Un modèle de téléphone se trompe environ une fois sur trois sans garde-fou. Inacceptable pour des gestes de secours |

### 3.5 Solution réaliste : trois niveaux

| Niveau | Fonctionnement | Matériel requis | Risque d'erreur | Version |
|---|---|---|---|---|
| 1. Recherche | L'utilisateur tape sa question. L'application affiche les fiches et passages les plus pertinents, sans rien générer | Tout téléphone Android avec 4 Go de mémoire | Nul sur le fond : seul du contenu validé ou sourcé est affiché | v1, mode par défaut |
| 2. Réponse citée | Le modèle rédige une réponse courte à partir des seuls passages retrouvés, et affiche ses sources. S'il ne trouve rien, il le dit | 8 Go de mémoire | Faible à moyen | v2, option |
| 3. Sujets sensibles | Pour la santé, les médicaments, les champignons et plantes, l'électricité : aucune génération. Renvoi direct vers la fiche validée et rappel du 15 et du 112 | Tous | Nul | v1 |

Le niveau 1 est la vraie réponse à la demande du client. Le niveau 2 est l'argument d'appel. Le niveau 3 est l'assurance de la marque. Un prototype du niveau 1 est fourni dans `prototype/mvp_logiciel/` : il fonctionne et se teste en ligne de commande.

## 4. Contenus et licences

| Contenu | Licence | Usage commercial | Action |
|---|---|---|---|
| Wikipédia, Wikilivres, Wiktionnaire, Vikidia en français | CC BY-SA | Oui, avec attribution et partage à l'identique. Les noms et logos Wikipédia sont des marques : ne pas les utiliser comme argument de marque | Intégrer via les fichiers Kiwix |
| WikiMed (articles médicaux de Wikipédia) | CC BY-SA | Oui | Intégrer, avec avertissement |
| OpenStreetMap | ODbL | Oui, avec attribution | Intégrer |
| Guide "Tous responsables" et fiches publiques sur les risques [S01, S02] | Publication de l'Etat, licence à vérifier (probablement Licence Ouverte) [HYP, H15] | Probable | Vérifier, puis intégrer |
| Manuels de survie de l'armée américaine (FM 21-76 et suivants) | Domaine public aux Etats-Unis | Oui | Traduire nous-mêmes (la traduction nous appartient) |
| Livres français du domaine public (Projet Gutenberg, Wikisource) | Domaine public | Oui | Sélection : classiques, manuels anciens |
| Gemma 4 | Apache 2.0 [S49] | Oui | Intégrer |
| "Là où il n'y a pas de docteur" (Hesperian) | Libre en non commercial seulement [S52] | Sur autorisation | Demander l'autorisation, sinon exclure |
| Khan Academy | CC BY-NC-SA [à confirmer] | Non | Exclure |
| Cartes IGN au 1/25 000 | Gratuites pour un usage non commercial seulement [à confirmer] | Non sans licence | Se limiter aux données IGN ouvertes |
| Contenus de la Croix-Rouge, de la Protection civile | Droits réservés | Non | Proposer un partenariat |
| Manuels scolaires d'éditeurs | Droits réservés | Non | Exclure. Utiliser Vikidia, Wikilivres et des manuels libres (Sésamath, licence à vérifier) |

Ce qu'il faut produire nous-mêmes, et qui fera la différence :

1. 60 à 100 fiches réflexes en français, courtes, illustrées, lisibles en situation de stress : premiers secours, eau, feu, abri, orientation, panne de courant, inondation, canicule, grand froid, évacuation, communication. Rédaction assistée par IA, relecture obligatoire par un formateur de secourisme et un médecin (1 200 € au budget).
2. L'index et les parcours : "que faire si...", listes de contrôle du kit, liens entre fiches, cartes et articles.
3. Le volet enfants : une sélection organisée de Vikidia et de Wikilivres par niveau scolaire. Simple à produire, utile pour le segment des parents.

## 5. Plan de MVP

Principe : prouver la valeur avec des briques existantes avant d'écrire une ligne de code spécifique.

| Semaine | Livrable | Moyens | Coût |
|---|---|---|---|
| 1 | "MVP zéro" : trois téléphones de test configurés à la main avec Kiwix, Organic Maps, Google AI Edge Gallery et 10 fiches en PDF. Mesures d'autonomie et de vitesse | Benjamin, 3 jours | 950 € (téléphones et cartes) |
| 1 à 2 | Vidéo de démonstration de 90 secondes pour la page d'atterrissage. Image maîtresse de la carte mémoire | Benjamin, assistance IA | 0 € |
| 2 à 4 | 30 fiches réflexes rédigées, format défini, moteur de recherche du prototype branché dessus | Benjamin, assistance IA | 0 € |
| 3 à 5 | Relecture professionnelle des 30 premières fiches | Formateur de secourisme, médecin | 1 200 € |
| 4 à 8 | Application v1 (niveau 1 et niveau 3) : accueil, fiches, recherche, ouverture de Kiwix et d'Organic Maps par liens. Publication en test fermé | Benjamin avec assistance IA, revue par un développeur Android indépendant (5 à 6 jours) | 3 000 € |
| 6 à 9 | Premières cartes dupliquées et livrées aux précommandes | Duplicateur de cartes | 3 400 € (100 cartes, emballages) |
| 10 à 16 | Application v2 : assistant de niveau 2 avec citations, lecteur de bibliothèque intégré | Idem | 5 000 € |

Total jusqu'à la première vente réelle : environ 8 500 € hors stock de téléphones. Compatible avec l'enveloppe initiale si les dépenses sont engagées par étapes (voir `plan_30_jours.md`).

Réserve importante : Benjamin n'a pas d'expérience de développement. Une application Android simple est à la portée d'un débutant assisté par IA, mais la publication, les tests sur plusieurs appareils et la maintenance demandent un développeur de métier quelques jours par mois. C'est prévu dans les charges du modèle financier (300 à 800 € par mois).

## 6. Ce qui peut tuer le produit sur le plan technique

| Risque | Détection précoce |
|---|---|
| L'assistant donne une réponse dangereuse reprise sur les réseaux sociaux | Jeu de 100 questions pièges rejoué à chaque version, niveau 3 strict |
| Le téléphone choisi est retiré du marché ou n'est plus mis à jour | Deux modèles référencés en permanence, pas de stock supérieur à 6 semaines |
| Les fichiers Kiwix en français sont trop lourds ou mal mis à jour | Vérification du catalogue en semaine 1 |
| L'installation de la carte déroute les clients non techniciens | Test avec 5 personnes non techniciennes avant toute vente |
| Google restreint l'installation d'applications hors de sa boutique | Publication parallèle sur Google Play dès la v1 |

## 7. Avocat du diable

- "Avec l'IA, je peux tout développer seul." Possible pour un prototype. Faux pour un produit vendu avec une garantie légale de deux ans, des mises à jour dues au client et une responsabilité sur le contenu.
- "Le produit est défendable." Rien de ce qui est décrit ici ne peut être protégé. Un concurrent financé peut le reproduire en trois mois. La seule défense est d'être la référence francophone avant que quelqu'un d'autre ne le soit, et de tenir un niveau de qualité des fiches qu'un assembleur pressé n'atteindra pas.
- "Le téléphone minimaliste est un plus." Les téléphones durcis sont l'inverse du minimalisme : Android complet, applications préinstallées du fabricant, 650 g. Le minimalisme sera celui de notre écran d'accueil, pas celui de l'appareil.
