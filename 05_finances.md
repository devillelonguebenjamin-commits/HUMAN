# 05. Modèle économique et finances

Document de la phase 1 du projet HUMAN, rédigé le 12 novembre 2026. Tous les chiffres proviennent de `modele_financier.xlsx` (6 762 formules, recalculées sans erreur). Montants en euros hors taxe sauf mention contraire. Les identifiants S renvoient à `sources.md`, les identifiants H à `registre_hypotheses.md`. Marqueurs : [FAIT], [EST], [HYP].

Ces chiffres sont des scénarios, pas des prévisions. Presque toutes les hypothèses de demande sont à valider. Le classeur est fait pour être modifié : changez une cellule bleue de la feuille `Hypotheses`, tout se recalcule.

## 1. Conclusion

1. Le modèle recommandé est une marque propre centrée sur le logiciel et les contenus, complétée par la revente de téléphones du commerce et d'un catalogue court d'accessoires (modèle C resserré). La place de marché est écartée. Le téléphone à notre marque est écarté.
2. Le profit est dans le pack, pas dans le téléphone. Marge de contribution : 93 % sur le pack numérique, 40 % sur le pack carte, 17 à 20 % sur un téléphone revendu.
3. La publicité payante ne peut pas être le moteur. La marge de contribution moyenne est de 43 € par commande, pour un coût d'acquisition payant estimé à 40 €. L'activité ne tient que si la majorité des commandes vient de canaux gratuits : contenus, créateurs, bouche à oreille, liste d'adresses.
4. Dans le scénario central, c'est une petite entreprise : 90 000 € de chiffre d'affaires la première année, 440 000 € la troisième, un fondateur payé 30 000 € chargés en année 3 et un EBITDA de 16 000 €. Valeur de cession indicative : 40 000 à 75 000 €.
5. Le scénario prudent perd environ 12 000 € en six mois. C'est le coût réel du risque si les critères d'arrêt sont respectés.
6. Pour atteindre l'ambition initiale (projet valorisable avec une vraie sortie), il faut le scénario ambitieux : 1,5 M€ de chiffre d'affaires en année 3, ce qui suppose l'Europe et une part de commandes organiques très élevée.

## 2. Les trois modèles comparés

| Critère | A. Marque propre avec téléphone à notre marque | B. Place de marché de produits de survie | C. Hybride resserré : marque propre logicielle, téléphone tiers revendu, catalogue court |
|---|---|---|---|
| Capital avant la première vente | Plus de 100 000 € [EST] : lot minimal de 500 à 1 000 pièces à environ 175 USD [S46], essais et certifications | 20 000 à 50 000 € [EST] : plateforme, recrutement des vendeurs, acquisition des acheteurs | 8 500 à 15 000 € |
| Statut réglementaire | Fabricant (voir `04_legal.md`) | Opérateur de plateforme | Editeur et distributeur |
| Marge | 30 à 40 % visée [HYP], avant garantie et mises à jour dues pendant 5 ans | Commission de 10 à 15 % du volume d'affaires [EST] | 29 % en moyenne. Pack : 40 à 93 %. Téléphone : 17 à 20 %. Accessoires : 30 % |
| Volume pour dégager 100 000 € de marge | Environ 1 000 téléphones, vendus sans réseau de distribution | 670 000 à 1 000 000 € de volume d'affaires, soit plus de 8 000 commandes de 80 à 120 € | Environ 2 300 commandes au mix central |
| Concurrence | Ulefone, Oukitel, Doogee, Samsung | Amazon, 249 boutiques françaises [S20], boutiques spécialisées installées | Aucune offre packagée en français à ce jour |
| Ce qui est construit pour une cession | Une marque de matériel copiable et un stock | Du trafic | Une marque, un corpus, une liste de clients |
| Verdict | Exclu avec ce budget | Exclu : démarrage à froid sur deux faces, marge insuffisante | Recommandé |

Le "catalogue court" du modèle C n'est pas une place de marché. Ce sont cinq à dix références choisies (radio à manivelle, panneau solaire pliable, batterie externe, filtre à eau), achetées en gros ou livrées par le fournisseur, qui augmentent le panier et rendent service. Leur contribution est modeste dans le modèle (2 € par commande) et pourra être élargie si elle fonctionne.

## 3. Economie unitaire (scénario central)

| Par unité vendue | Pack numérique | Pack carte 256 Go | Téléphone Essentiel | Téléphone Autonomie | Essentiel en lot B2B |
|---|---|---|---|---|---|
| Prix de vente TTC | 49 € | 89 € | 319 € | 449 € | 294 € |
| Prix de vente HT | 40,83 € | 74,17 € | 265,83 € | 374,17 € | 245,00 € |
| Achat et préparation | 1,00 € | 34,50 € | 182,50 € | 270,50 € | 182,50 € |
| Expédition | 0 € | 3,50 € | 8,50 € | 9,50 € | 3,00 € |
| Frais de paiement | 0,98 € | 1,58 € | 5,04 € | 6,99 € | 0 € |
| Provision SAV et retours | 0,82 € | 2,97 € | 15,95 € | 22,45 € | 14,70 € |
| Logistique | 0 € | 2,00 € | 2,00 € | 2,00 € | 2,00 € |
| Marge de contribution | 38,03 € | 29,61 € | 51,85 € | 62,73 € | 42,80 € |
| Taux de marge | 93 % | 40 % | 20 % | 17 % | 17 % |

Composition des coûts d'achat :

- pack carte : carte 256 Go de marque 28 € [EST], lecteur USB-C 3 €, emballage et guide papier 2,50 €, duplication 1 € ;
- téléphone Autonomie : appareil 235 € [EST à partir des offres européennes les plus basses, 272 € TTC, S42], carte et emballage 31,50 €, préparation 4 € ;
- téléphone Essentiel : appareil 160 € [HYP], carte 128 Go et emballage 18,50 €, préparation 4 €.

Pas de droits de douane tant que l'on achète dans l'Union. En import direct, les smartphones sont exonérés de droits [à confirmer], mais la redevance pour copie privée (14 € HT [S56]) et les éco-contributions s'ajoutent, et la TVA est due à l'importation.

Par commande moyenne (40 % de packs carte, 25 % de packs numériques, 20 % d'Essentiel, 15 % d'Autonomie, 15 % de commandes avec accessoires) :

| Indicateur | Valeur |
|---|---|
| Panier moyen HT, accessoires compris | 156 € |
| Marge de contribution avant acquisition | 43,16 € |
| Coût d'acquisition d'une commande payante [EST, S68] | 40 € |
| Marge d'une commande payante après acquisition | 3,16 € |
| Marge d'une commande organique | 43,16 € |

Une commande obtenue par la publicité ne rapporte presque rien. C'est le fait économique central du projet.

## 4. Prix de vente et prix psychologiques

| Produit | Prix central | Ancrage du client | Seuil psychologique | A tester |
|---|---|---|---|---|
| Pack numérique | 49 € | Applications américaines à 25 ou 35 USD [S26] | Sous 50 € | 39 € contre 49 € |
| Pack carte | 89 € | Carte nue à 30 ou 40 €. Prepper Disk à 240 USD [S29] | Sous 100 € | 79 € contre 99 € |
| Téléphone Essentiel | 319 € | Le même téléphone nu, 190 à 200 € en ligne [EST] | Sous 350 € | 299 € contre 329 € |
| Téléphone Autonomie | 449 € | Le même téléphone nu, dès 272 € en ligne [FAIT, S42]. Survival Node à 350 USD [S22] | Sous 450 € | 399 € contre 449 € |

Le client peut vérifier le prix du téléphone nu en dix secondes. La prime que nous demandons pour le "prêt à l'emploi" est donc visible : environ 90 € sur le modèle Autonomie une fois le pack déduit. Si le marché n'accepte que 399 €, la marge du téléphone tombe à 24 € et sa vente n'a plus d'intérêt économique (grille 3 de la feuille `Sensibilites`). Le test de prix de la page d'atterrissage porte en priorité sur ce point.

## 5. Scénarios sur 36 mois

| | Prudent A1 | Prudent A2 | Prudent A3 | Central A1 | Central A2 | Central A3 | Ambitieux A1 | Ambitieux A2 | Ambitieux A3 |
|---|---|---|---|---|---|---|---|---|---|
| Commandes B2C | 170 | 339 | 440 | 580 | 1 529 | 2 542 | 1 138 | 3 780 | 7 182 |
| Téléphones vendus, B2B compris | 43 | 85 | 146 | 203 | 595 | 1 070 | 512 | 1 881 | 3 712 |
| Chiffre d'affaires | 19 700 | 39 200 | 59 300 | 90 400 | 253 100 | 440 500 | 219 000 | 773 500 | 1 505 000 |
| Marge sur coûts variables | 3 700 | 7 400 | 10 200 | 25 000 | 72 700 | 131 300 | 66 500 | 258 600 | 501 000 |
| Publicité, contenus, créateurs | 4 800 | 9 000 | 12 000 | 11 000 | 30 000 | 51 600 | 21 000 | 78 000 | 156 000 |
| Autres charges et investissements | 15 200 | 7 200 | 13 200 | 19 200 | 35 600 | 63 200 | 29 200 | 111 000 | 243 000 |
| dont rémunération du fondateur | 0 | 0 | 6 000 | 0 | 18 000 | 30 000 | 0 | 30 000 | 54 000 |
| EBITDA | -16 300 | -8 800 | -15 000 | -5 300 | 7 100 | 16 500 | 16 300 | 69 600 | 102 000 |
| Trésorerie en fin d'année | -3 300 | -13 300 | -28 700 | 22 100 | 14 200 | 19 100 | 56 100 | 69 300 | 135 700 |

| Indicateur sur 36 mois | Prudent | Central | Ambitieux |
|---|---|---|---|
| Fonds propres apportés | 15 000 | 25 000 | 40 000 |
| Emprunts mobilisés | 0 | 20 000 | 50 000 |
| Perte cumulée maximale | -40 000 (mois 36) | -11 900 (mois 3) | -15 000 (mois 3) |
| Mois où l'EBITDA cumulé devient positif | Jamais | Mois 24 | Mois 9 |
| Trésorerie minimale | Négative dès le mois 9 | 1 400 (mois 8) | 3 800 (mois 1) |
| Valorisation indicative (2,5 à 4,5 fois l'EBITDA de l'année 3) | 0 | 41 000 à 74 000 | 255 000 à 459 000 |

### Ce qui distingue les scénarios

| Hypothèse clé | Prudent | Central | Ambitieux |
|---|---|---|---|
| Commandes organiques le premier mois de vente | 10 | 25 | 40 |
| Croissance mensuelle des commandes organiques, puis après 12 mois | 5 %, puis 2 % | 9 %, puis 4 % | 11 %, puis 5 % |
| Coût d'acquisition payant | 60 € | 40 € | 32 € |
| Prix du pack carte, du téléphone Autonomie (TTC) | 79 €, 419 € | 89 €, 449 € | 89 €, 479 € |
| Part des téléphones dans les commandes | 25 % | 35 % | 45 % |
| Passage à l'import direct | Jamais | Mois 19 | Mois 13 |

### Lecture

- Prudent : la demande organique ne décolle pas, la publicité coûte plus qu'elle ne rapporte (perte de 38 € par commande payante). La trésorerie passe sous zéro au mois 9. Si l'on arrête au mois 6 comme le prévoient les critères d'arrêt, la perte est d'environ 12 300 €, moins la valeur de revente du stock.
- Central : l'activité paie ses charges dès le quatrième mois, rémunère modestement le fondateur à partir de l'année 2 et dégage peu de résultat. La trésorerie est tendue au mois 8, au moment où l'on passe de la précommande au stock.
- Ambitieux : il faut 40 commandes organiques par mois dès le lancement et 11 % de croissance mensuelle pendant un an. C'est le profil d'un lancement porté par un ou deux créateurs influents ou par un événement médiatique. Le volume de l'année 3 dépasse le marché français adressable estimé (voir `01_marche.md`) : ce scénario suppose l'Europe.

## 6. Point mort

Commandes mensuelles nécessaires pour couvrir les charges fixes (scénario central, feuille `Sensibilites`, grille 2) :

| Charges fixes mensuelles | 100 % de commandes organiques | 25 % payantes | 50 % payantes | 75 % payantes |
|---|---|---|---|---|
| Année 1 : 1 020 € (sans rémunération) | 24 | 31 | 44 | 78 |
| Année 2 : 2 970 € (fondateur à 1 500 €) | 69 | 90 | 128 | 226 |
| Année 3 : 6 070 € (fondateur à 2 500 €, sous-traitance) | 141 | 183 | 262 | 461 |

Le point mort de la première année est bas : 24 commandes par mois, moins d'une par jour. C'est ce qui rend le test raisonnable. En revanche, payer correctement le fondateur exige 140 à 260 commandes par mois, soit cinq à dix fois plus.

## 7. Besoin en fonds de roulement

- Les clients particuliers paient à la commande. Les fournisseurs sont payés à l'achat. Le besoin se résume au stock.
- Pendant les six premiers mois de vente, le modèle suppose un demi-mois de stock : les ventes se font surtout en précommande, le client paie avant que nous achetions. Stock de 2 200 à 2 800 €.
- Ensuite, un mois et demi de stock : 8 900 € au mois 8, 17 000 € en fin d'année 1, 29 300 € en fin d'année 2, 36 600 € en fin d'année 3.
- C'est ce saut du mois 8 qui consomme la trésorerie et qui justifie un emprunt (section 9).
- La TVA est supposée neutre. En réalité, le premier stock génère un crédit de TVA remboursé avec quelques semaines de délai : prévoir 1 000 à 2 000 € de décalage.

## 8. Comment employer 10 000 € puis jusqu'à 40 000 €

Principe : chaque tranche n'est engagée que si la précédente a franchi son seuil. Détail dans la feuille `Emploi_des_fonds`.

| Etape | Période | Emplois principaux | Montant | Cumul | Condition pour passer à la suivante |
|---|---|---|---|---|---|
| 1. Valider la demande | Jours 1 à 30 | Page d'atterrissage et publicité de test 1 350 €, trois téléphones de test 950 €, entretiens 200 €, avocat 1 500 €, marque 600 € | 4 600 € | 4 600 € | Seuils du test atteints (voir `plan_30_jours.md`). L'avocat et la marque ne sont engagés qu'après les premiers résultats |
| 2. Première vente réelle | Jours 31 à 90 | Société 900 €, application v1 3 000 €, relecture des fiches 1 200 €, premier stock de cartes 3 400 €, 20 téléphones 4 000 €, publicité et créateurs 2 400 € | 14 900 € | 19 500 € | 40 précommandes payées avant d'acheter le stock de cartes, 15 avant d'acheter les téléphones |
| 3. Montée en charge | Mois 4 à 12 | Stock 8 000 €, contenus et salons 4 000 €, application v2 5 000 €, réserve 3 500 € | 20 500 € | 40 000 € | Plus de 60 commandes par mois pendant deux mois, taux de remboursement sous 8 % |

Trois règles de trésorerie :

1. les 10 000 € initiaux couvrent l'étape 1 et la préparation de l'étape 2. Ils ne financent aucun stock ;
2. le stock est financé par les précommandes, puis par l'emprunt. Jamais par l'apport initial ;
3. ne jamais descendre sous trois mois de charges fixes en réserve.

## 9. A quel moment emprunter, et quoi

| Moment | Instrument | Montant indicatif | Pourquoi | Condition |
|---|---|---|---|---|
| Avant le jour 30 | Aucun | 0 | On n'emprunte pas pour tester une demande | |
| Mois 5 à 6 : dépôt du dossier | Prêt d'honneur (réseau Initiative France ou Réseau Entreprendre) | 10 000 à 20 000 € | Taux zéro, à la personne, sans garantie, 1 à 7 ans, différé possible [FAIT, S65] | Société créée, quatre à cinq mois de ventes à montrer, passage en comité |
| Mois 8 à 9 : déblocage | Prêt bancaire adossé | Montant équivalent, environ 4,5 % sur 5 ans [EST] | Le prêt d'honneur doit rester inférieur au tiers du financement total [S65] et sert de levier auprès des banques | Idem |
| Année 2 | Crédit de stock ou affacturage B2B | Selon le volume | Financer l'import direct et les lots B2B | Plus de 500 téléphones par an |
| Année 2 ou 3 | Aides à l'innovation de Bpifrance, aides régionales | A étudier | Financer l'application v3 et l'extension européenne | Eligibilité incertaine : l'innovation technologique est faible. A vérifier avec la chambre de commerce |

Dans le scénario central, 20 000 € d'emprunt au mois 9 suffisent. Si la trésorerie le permet, un apport personnel supplémentaire évite l'emprunt bancaire, mais le prêt d'honneur reste intéressant : il ne coûte rien et crédibilise le dossier.

## 10. Sensibilités

Marge d'une commande payante selon le coût d'acquisition et le niveau des prix (scénario central, grille 1) :

| Coût d'acquisition | Prix -10 % | Prix actuels | Prix +10 % |
|---|---|---|---|
| 25 € | 4 € | 18 € | 32 € |
| 32 € | -3 € | 11 € | 25 € |
| 40 € | -11 € | 3 € | 17 € |
| 50 € | -21 € | -7 € | 7 € |
| 60 € | -31 € | -17 € | -3 € |

Marge d'un téléphone Autonomie selon son prix d'achat et son prix de vente (grille 3) :

| Prix d'achat HT | Vendu 399 € TTC | Vendu 449 € TTC | Vendu 479 € TTC |
|---|---|---|---|
| 205 € (import direct) | 54 € | 93 € | 116 € |
| 235 € (grossiste européen) | 24 € | 63 € | 86 € |
| 250 € | 9 € | 48 € | 71 € |

Marge d'un pack carte selon le coût de la carte et le prix de vente (grille 4) :

| Coût de la carte 256 Go | Vendu 79 € TTC | Vendu 89 € TTC | Vendu 99 € TTC |
|---|---|---|---|
| 24 € | 26 € | 34 € | 41 € |
| 28 € | 22 € | 30 € | 37 € |
| 38 € | 12 € | 20 € | 27 € |

Les quatre leviers par ordre d'effet sur le résultat :

1. la part de commandes organiques. Passer de 50 % à 75 % d'organique divise par presque deux le volume nécessaire au point mort ;
2. le niveau de prix accepté. Dix pour cent de prix en plus valent 14 € par commande ;
3. la part du pack numérique. Chaque commande déplacée du pack carte vers le pack numérique rapporte 8 € de plus et supprime la logistique ;
4. le prix d'achat des téléphones. L'import direct ajoute 9 à 21 € par appareil, pour un coût fixe de 6 000 €.

## 11. Avocat du diable

- "Le scénario central est prudent." Non. Il suppose 25 commandes organiques dès le premier mois et 9 % de croissance mensuelle pendant un an, sans équipe. Beaucoup de marques en ligne lancées par une personne seule n'atteignent pas 50 000 € de chiffre d'affaires la première année. Le scénario prudent est au moins aussi probable que le central.
- "Les marges s'amélioreront avec le volume." Seulement sur les téléphones, et seulement en devenant importateur, avec les obligations associées. Les marges du pack sont déjà à leur niveau final.
- "Le B2B relèvera la rentabilité." A 17 % de marge sur des lots à prix négocié, le B2B apporte du volume et des références, pas du profit.
- "Il suffit de vendre plus cher." Le prix du téléphone nu est public. La prime de préparation ne tiendra que si le pack a une valeur perçue forte.

## 12. Utiliser le classeur

| Feuille | Contenu |
|---|---|
| `Lisez_moi` | Mode d'emploi et conventions |
| `Hypotheses` | Toutes les hypothèses, une colonne par scénario. Bleu : modifiable. Jaune : à valider en priorité |
| `Unitaire` | Economie unitaire par produit et par scénario |
| `Synthese` | Résultats annuels et indicateurs des trois scénarios |
| `M_Prudent`, `M_Central`, `M_Ambitieux` | Projections mensuelles sur 36 mois |
| `Sensibilites` | Quatre grilles, scénario au choix en B3 |
| `Emploi_des_fonds` | Etapes de dépense et conditions |

Pour régénérer le classeur après modification du script : `python3 outils/generer_modele_financier.py modele_financier.xlsx`, puis ouvrir le fichier dans Excel ou LibreOffice pour recalculer.
