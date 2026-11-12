# Registre des hypothèses

Mis à jour le 12 novembre 2026. Chaque hypothèse structurante du dossier est listée avec sa source ou sa méthode de validation, son niveau de confiance et son effet sur la décision. Les identifiants S renvoient à `sources.md`.

Confiance : forte (donnée sourcée et recoupée), moyenne (une source ou une estimation solide), faible (supposition à tester).
Effet sur la décision : critique (peut inverser la recommandation), important (change les chiffres), secondaire.

## A. Marché et demande

| ID | Hypothèse | Source ou méthode de validation | Confiance | Effet sur la décision |
|---|---|---|---|---|
| H01 | Environ 10 % des foyers français ont un kit d'urgence, et 60 % de ces foyers sont de catégories supérieures | Etude Crédoc 2024 citée par la presse [S03, S04]. A vérifier dans l'étude d'origine | Moyenne | Important : base du calcul du marché adressable |
| H02 | La France compte environ 30 millions de ménages | Ordre de grandeur de mémoire, à confirmer sur le site de l'Insee | Moyenne | Secondaire |
| H03 | 5 à 10 % des ménages équipés et aisés s'intéressent à un outil numérique payant de préparation | Aucune donnée. Validation : taux d'inscription et de précommande de la page d'atterrissage | Faible | Critique : détermine la taille du marché adressable (3 à 7 M€ par an) |
| H04 | La majorité du public visé n'installera pas seule des applications libres hors ligne | Aucune donnée. Validation : 20 entretiens, question "l'avez-vous déjà fait ?" | Faible | Critique : c'est la raison d'être du produit |
| H05 | La demande n'est pas un simple pic d'actualité | Impulsions publiques répétées [S01, S06, S07]. Validation : Google Trends sur 24 mois, deux vagues de test espacées | Moyenne | Important |
| H06 | Le taux de conversion du dollar retenu est de 0,92 € | Hypothèse de calcul, à actualiser | Faible | Secondaire |
| H07 | Les marchés néerlandais, allemand et nordique sont accessibles avec un produit traduit | Niveaux de préparation plus élevés [S16, S17]. Validation : page d'atterrissage en néerlandais ou en allemand en année 2 | Faible | Important pour le scénario ambitieux seulement |

## B. Produit et approvisionnement

| ID | Hypothèse | Source ou méthode de validation | Confiance | Effet sur la décision |
|---|---|---|---|---|
| H08 | Un téléphone de type Armor 24 Pro s'achète environ 235 € HT auprès d'un distributeur européen, un Armor 22 Pro environ 160 € HT | Offres publiques les plus basses à 272 € TTC [S42] pour le premier, estimation par proportion pour le second. Validation : trois devis en semaine 1 | Moyenne pour le premier, faible pour le second | Important : marge des téléphones |
| H09 | L'achat direct à la marque fait gagner environ 15 % | Repères de places de marché professionnelles [S46]. Validation : demande de prix au service B2B d'Ulefone | Faible | Secondaire avant l'année 2 |
| H10 | Une carte microSD de marque de 256 Go coûte 28 € HT en gros, 15 € pour 128 Go | Estimation. Marché de la mémoire tendu. Validation : deux devis de grossistes | Faible | Important : marge du pack carte (voir grille 4 du classeur) |
| H11 | Préinstaller notre application sur un téléphone de marque tierce nous laisse le statut de distributeur | Principe "modifier fait devenir fabricant" [S55], non tranché pour une simple application. Validation : avis d'avocat | Faible | Critique pour l'offre téléphone. Repli : lot téléphone scellé et carte |
| H12 | Gemma 4 E2B tourne à environ 5 jetons par seconde sur une puce Helio G200 | Analogie avec des puces voisines [S48]. Validation : mesure sur téléphone de test | Moyenne | Secondaire : l'assistant est une option |
| H13 | Les téléphones retenus reçoivent la radio FM | Non confirmé [S42]. Validation : essai | Faible | Secondaire : radio à manivelle en accessoire |
| H14 | Le corpus complet en français tient dans 42 à 62 Go | Ordres de grandeur du catalogue Kiwix [S51]. Validation : téléchargement en semaine 1 | Moyenne | Important : choix de la carte (128 ou 256 Go) |
| H15 | Le guide "Tous responsables" est réutilisable commercialement | Supposition sur la licence des publications de l'Etat. Validation : mentions légales du guide, sinon demande écrite | Faible | Secondaire |
| H16 | La brique de lecture Kiwix impose de publier notre application en code ouvert | Licence à confirmer. Validation : lecture de la licence, avis d'avocat | Moyenne | Secondaire : acceptable dans notre modèle |
| H17 | Une application v1 est réalisable en 4 à 6 semaines pour 3 000 € d'appui extérieur | Estimation d'opérateur. Validation : deux devis de développeurs indépendants | Faible | Important : calendrier de la première vente |
| H18 | Une batterie de 22 000 mAh donne 3 à 4 semaines d'usage sobre | Calcul d'ordre de grandeur. Validation : protocole de test sur 30 jours | Faible | Important : c'est une promesse commerciale |

## C. Prix, acquisition, ventes

| ID | Hypothèse | Source ou méthode de validation | Confiance | Effet sur la décision |
|---|---|---|---|---|
| H19 | Le public accepte 89 € pour le pack carte et 49 € pour le pack numérique | Repères : applications à 25 ou 35 USD [S26], Prepper Disk à 240 USD [S29]. Validation : test de prix sur la page | Faible | Critique : dix pour cent de prix valent 14 € par commande |
| H20 | Les seuils du test (3 % et 8 % d'inscription, 4 € et 8 € par inscrit) séparent correctement un échec d'un succès | Repères de praticien, non sourcés | Faible | Important : à réviser après la première vague, avant de lire les résultats de la seconde |
| H21 | Le public accepte une prime d'environ 90 € pour un téléphone prêt à l'emploi par rapport au téléphone nu et au pack achetés séparément | Analogie avec Prepper Disk [S29]. Validation : test de prix, précommandes | Faible | Critique pour l'offre téléphone |
| H22 | Le coût d'acquisition d'une commande payante est d'environ 40 € | Références de publicité en ligne, surtout américaines [S68]. Validation : campagnes de précommande | Faible | Critique : au-dessus de 43 €, chaque commande payante perd de l'argent |
| H23 | 25 commandes organiques sont atteignables dès le premier mois de vente, avec 9 % de croissance mensuelle pendant un an | Supposition du scénario central. Validation : taille de la liste d'attente, taux de conversion à la précommande | Faible | Critique : c'est l'hypothèse la plus fragile du modèle |
| H24 | Le mix de commandes est de 40 % de packs carte, 25 % de packs numériques, 35 % de téléphones | Supposition. Validation : choix exprimés sur la page, puis ventes | Faible | Important |
| H25 | 15 % des commandes incluent 45 € d'accessoires à 30 % de marge | Supposition | Faible | Secondaire |
| H26 | Les retours et le SAV coûtent 6 % du chiffre d'affaires des téléphones et 4 % de celui des packs | Supposition prudente | Faible | Important |
| H27 | Des ventes B2B par lots démarrent en année 2 (5 puis 15 unités par mois) | Supposition. Validation : dix rendez-vous de prospection | Faible | Secondaire |

## D. Coûts, financement, sortie

| ID | Hypothèse | Source ou méthode de validation | Confiance | Effet sur la décision |
|---|---|---|---|---|
| H28 | Les frais de paiement sont de 1,5 % plus 0,25 € par commande | Tarifs usuels de mémoire. Validation : grille du prestataire choisi | Moyenne | Secondaire |
| H29 | Les charges fixes de l'année 1 tiennent en 1 020 € par mois hors publicité | Estimation poste par poste (classeur) | Moyenne | Important |
| H30 | Le fondateur ne se rémunère pas la première année | Supposition, à confirmer par Benjamin (question ouverte n° 2) | A confirmer | Critique : sinon le besoin de financement double |
| H31 | Un prêt d'honneur de 10 000 € et un prêt bancaire équivalent sont accessibles au mois 9 | Dispositif existant [S65]. Validation : rendez-vous avec la plateforme locale | Moyenne | Important |
| H32 | Passer à l'import coûte environ 6 000 € de mise en conformité et 16 € par appareil | Copie privée à 14 € [S56], reste estimé | Faible | Secondaire avant l'année 2 |
| H33 | Une marque de ce type se cède entre 2,5 et 4,5 fois son EBITDA | Fourchettes de marché 2026 [S69] | Moyenne | Important pour l'objectif de sortie |
| H34 | Le budget juridique de démarrage est de 2 400 à 4 700 € | Estimation d'honoraires. Validation : deux devis | Faible | Secondaire |

## E. Hypothèses sur le fondateur

| ID | Hypothèse | Méthode de validation | Effet sur la décision |
|---|---|---|---|
| H35 | Benjamin peut produire lui-même deux articles et une vidéo par semaine pendant six mois | Essai pendant les 30 jours de test | Critique : l'acquisition gratuite en dépend entièrement |
| H36 | Benjamin accepte que le projet devienne un produit logiciel et de contenu plutôt qu'un produit matériel | Question ouverte n° 1 | Critique |
| H37 | Benjamin peut consacrer 12 mois au projet sans revenu tiré de l'entreprise | Question ouverte n° 2 | Critique |

## Lecture

Onze hypothèses sont critiques. Neuf d'entre elles (H03, H04, H19, H21, H22, H23, H35, H36, H37) peuvent être levées en 30 à 60 jours pour moins de 3 000 €. H11 demande un avis d'avocat. H30 demande une réponse de Benjamin. Aucune ne nécessite d'acheter du stock ou de créer une société.
