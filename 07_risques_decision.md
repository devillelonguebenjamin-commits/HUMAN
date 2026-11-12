# 07. Risques, scénarios de sortie et décision

Document de la phase 1 du projet HUMAN, rédigé le 12 novembre 2026. Il s'appuie sur les documents 01 à 06 et sur `modele_financier.xlsx`. Les identifiants S renvoient à `sources.md`. Marqueurs : [FAIT], [EST], [HYP], [INT].

## 1. Recommandation

**NO-GO sur la thèse telle qu'elle est formulée. PIVOT recommandé. GO pour 30 jours de validation, avec 2 500 € au plus engagés avant la décision.**

| Question | Réponse |
|---|---|
| Faut-il lancer un smartphone durci à notre marque avec IA locale ? | Non. Hors de portée du budget (statut de fabricant), marge faible, produit déjà vendu 350 USD aux Etats-Unis [S22], matériel non défendable |
| Faut-il lancer une place de marché ? | Non. 249 boutiques existent déjà [S20], commission de 10 à 15 %, démarrage à froid sur deux faces |
| Y a-t-il quelque chose à faire ? | Oui, plus petit et plus net : la référence francophone du savoir hors ligne, vendue en pack (téléchargement et carte mémoire), avec un téléphone du commerce en option |
| Faut-il s'engager maintenant ? | Non. Il faut d'abord acheter une preuve de demande pour 2 500 €, en 30 jours |
| Et si le test échoue ? | On arrête, avec une perte inférieure à 3 000 €, ou l'on teste la variante suivante du classement (section 3) |

### Niveaux de confiance

| Affirmation | Confiance | Fondement |
|---|---|---|
| La thèse initiale n'est pas viable avec 10 000 à 40 000 € | Elevée (85 à 90 %) | Obligations réglementaires documentées [S54, S55], prix publics relevés [S42], concurrents existants [S22 à S29] |
| Le test à 30 jours donnera un signal exploitable | Elevée (80 %) | Seuils fixés à l'avance, coût faible |
| Le pivot franchira les seuils de lancement | Faible à moyenne (35 à 45 %) | [INT] Offre abondante en anglais, substitut gratuit, mais aucune offre en français et un contexte public porteur |
| S'il les franchit, il atteindra au moins le scénario central en 3 ans | Moyenne (40 %) | [INT] Dépend de la capacité du fondateur à produire du contenu régulier |
| Le projet débouchera sur une cession supérieure à 250 000 € | Faible (5 à 10 %) | Suppose le scénario ambitieux et l'Europe |

Dit autrement : il y a environ une chance sur six que ce projet devienne une petite entreprise rentable, et une sur quinze qu'il réponde à l'ambition de départ. Ce n'est pas une raison de ne pas tester, parce que le test coûte peu. C'est une raison de ne rien engager au-delà du test sans preuve.

## 2. Incohérences relevées dans la thèse de départ

| Elément du brief | Problème | Résolution proposée |
|---|---|---|
| "Cet assemblage n'existe pas encore" | Faux. Au moins quatre appareils et dix applications aux Etats-Unis [S22 à S29] | Vrai seulement en français. Le projet devient une localisation exigeante, pas une invention |
| "Minimaliste" et "IA locale" | Contradictoires. Un modèle de langage demande 8 Go de mémoire et une puce récente [S47] | IA à la demande, recherche documentaire par défaut |
| "Très forte autonomie" et "minimaliste" | Un téléphone de 22 000 mAh pèse 647 g [S42] | Deux versions : Essentiel et Autonomie |
| "Place de marché" et "vendre tel quel" | Deux métiers différents | Marque propre avec catalogue court |
| "Radio" | Ambigu. La réception est libre, l'émission est réglementée | Réception seulement. Accessoires conformes pour l'émission |
| "20 % de B2B : collectivités, sécurité civile" | Ces acheteurs exigent du matériel professionnel et des marchés publics | Viser les entreprises, les associations et les petites communes, par lots |
| "Acquisition par les réseaux sociaux" et "jamais la peur" | La publicité payante n'est pas rentable sur ce panier, et la peur est ce qui convertit le mieux dans cette catégorie | Contenu gratuit de démonstration, créateurs à la commission |
| "Prendre une vraie part de ce marché" avec 10 000 à 40 000 € | Le marché adressable français de ce produit est de l'ordre de 3 à 7 M€ par an [EST] | Viser une niche rentable, puis l'Europe si la preuve est faite |
| "Je m'appuie sur l'IA pour la partie technique" | Suffisant pour un prototype, pas pour un produit garanti deux ans | Prévoir un développeur indépendant quelques jours par mois |

## 3. Variantes classées

| Rang | Variante | Capital | Marge | Défendabilité | Risque réglementaire | Avis |
|---|---|---|---|---|---|---|
| 1 | Pack de savoirs hors ligne en français (téléchargement et carte), téléphone du commerce en option | 8 500 à 15 000 € | 40 à 93 % sur le pack | Moyenne : corpus, marque, communauté | Faible | Recommandée |
| 2 | Boîtier familial hors ligne : petit serveur Wi-Fi qui diffuse la même bibliothèque à tous les appareils de la maison | 15 000 à 25 000 € | 40 à 50 % visés [HYP] | Faible à moyenne. Kiwix et Prepper Disk existent [S29, S31] | Moyen : assembler un appareil sous notre marque fait de nous un fabricant, mais sans les règles propres aux smartphones | A tester en option sur la page d'atterrissage. Bon produit de deuxième génération |
| 3 | Kit 72 heures conforme au guide officiel, assemblé en France | 15 000 à 30 000 € | 30 à 40 % [EST] | Faible. Croix-Rouge et pompiers vendent déjà le leur [S03, S05] | Faible | Marché le plus large, concurrence la plus forte, logistique lourde. Pertinent comme accessoire, pas comme coeur |
| 4 | Application seule, par abonnement | 5 000 à 10 000 € | Plus de 80 % | Faible : HAVEN et autres [S26] | Faible | Le marché refuse l'abonnement (achat unique à 25 USD). Intégrée à la variante 1 |
| 5 | Thèse initiale : smartphone durci à notre marque | Plus de 100 000 € | 30 à 40 % avant obligations | Faible | Elevé | Ecartée. A reconsidérer seulement au-delà de 2 000 téléphones vendus par an |
| 6 | Place de marché | 20 000 à 50 000 € | 10 à 15 % du volume | Faible | Moyen | Ecartée |

## 4. Matrice des risques

Probabilité : faible, moyenne, élevée. Impact de 1 (gênant) à 5 (mortel).

| N° | Famille | Risque | Probabilité | Impact | Parade | Signal précoce |
|---|---|---|---|---|---|---|
| R1 | Marché | Le client ne paie pas pour ce qu'il peut assembler gratuitement | Elevée | 5 | Test de demande avant tout investissement. Valeur ajoutée propre : fiches validées, recherche unifiée, cinq minutes d'installation | Taux d'inscription sous 3 %, commentaires "c'est gratuit" |
| R2 | Marché | Demande portée par un pic d'actualité | Moyenne | 3 | Tester sur deux semaines distinctes, seuils avec marge | Coût par inscrit qui double d'une semaine à l'autre |
| R3 | Marché | Une application américaine sort en français | Elevée à 24 mois | 4 | Aller vite, contenus réellement français, partenariats locaux | Fiche en français sur les boutiques d'applications |
| R4 | Marché | L'Etat ou la Croix-Rouge publient une application gratuite | Moyenne | 4 | Se positionner en complément, proposer nos fiches en partenariat | Appels d'offres, annonces de la sécurité civile |
| R5 | Technique | L'IA donne une réponse dangereuse, relayée publiquement | Moyenne | 5 | Pas de génération sur les sujets sensibles, citations obligatoires, 100 questions pièges rejouées à chaque version | Tests internes sous 95 % de réponses correctes |
| R6 | Technique | Fondateur non technique, dépendance à un prestataire | Elevée | 3 | Architecture simple, briques libres, code ouvert, deux prestataires identifiés | Délais de la v1 dépassés de plus de 4 semaines |
| R7 | Technique | Installation trop difficile pour le public visé | Moyenne | 4 | Test avec cinq personnes non techniciennes avant toute vente | Moins de 70 % d'installations réussies sans aide |
| R8 | Légal | La préinstallation nous fait requalifier en fabricant | Faible à moyenne | 4 | Avis d'avocat avant la première vente de téléphone. Lot "téléphone scellé et carte" en solution de repli | Avis défavorable |
| R9 | Légal | Retrait du marché du modèle revendu (précédent de 2025 [S58]) | Faible à moyenne | 3 | Deux modèles référencés, six semaines de stock au plus, marque qui corrige | Publications de l'ANFR |
| R10 | Légal | Qualification en dispositif médical ou mise en cause pour un conseil de santé | Faible | 5 | Finalité éducative écrite, aucune fonction de diagnostic, relecture médicale, assurance | Réclamation d'un client, courrier d'une autorité |
| R11 | Légal | Nouvelles charges : hausse de la copie privée [S56], règlement sur la cyberrésilience en 2027 [S55] | Moyenne | 2 | Rester distributeur, veille semestrielle | Publication au Journal officiel |
| R12 | Réputation | Assimilation au "business de la peur" [S13] | Moyenne | 4 | Charte éditoriale, alignement sur la parole publique, transparence des prix | Article ou vidéo critique |
| R13 | Réputation | Rejet par la communauté technique ("arnaque, tout est gratuit") | Elevée | 3 | Publier nous-mêmes le tutoriel gratuit, code ouvert, reversement à Kiwix | Fils de discussion hostiles |
| R14 | Approvisionnement | Fin de série du téléphone, hausse du prix des cartes mémoire | Elevée | 2 | Produit indépendant du téléphone, deux fournisseurs de cartes, prix révisables | Devis en hausse de plus de 15 % |
| R15 | Approvisionnement | Le fournisseur n'assume pas la garantie | Moyenne | 3 | Acheter à des distributeurs établis dans l'Union, provision de 6 % | Délais de retour supérieurs à 30 jours |
| R16 | Trésorerie | Stock de téléphones invendu | Moyenne | 3 | Précommandes, lots de 20 au plus au début | Plus de six semaines de stock |
| R17 | Trésorerie | Fonds retenus par le prestataire de paiement sur les précommandes | Faible à moyenne | 3 | Délais annoncés courts, prestataire prévenu, deux prestataires | Retenue de plus de 10 % |
| R18 | Trésorerie | Coût d'acquisition supérieur à la marge | Elevée | 4 | Publicité limitée aux tests, priorité au gratuit | Marge négative par commande payante pendant deux mois |
| R19 | Fondateur | Charge de travail d'une personne seule : contenus, vidéo, service client, logistique | Elevée | 3 | Séquencer, sous-traiter la logistique au-delà de 150 colis par mois | Rythme de publication non tenu trois semaines de suite |

Les cinq risques majeurs : R1, R18, R3, R5, R12.

## 5. Critères d'arrêt

Fixés maintenant, pour ne pas être négociés plus tard. Un seul critère atteint suffit à arrêter ou à pivoter.

| Echéance | Critère d'arrêt | Perte maximale à cette date |
|---|---|---|
| Jour 20 | Moins de 3 % d'inscription à la liste d'attente sur 1 000 visiteurs, après deux versions du message | 2 500 € |
| Jour 20 | Coût par inscrit supérieur à 8 € sur les deux vagues | 2 500 € |
| Jour 30 | Moins de 8 entretiens sur 20 où la personne se dit prête à payer 79 € ou plus pour le pack | 2 500 € |
| Jour 30 | Avis d'avocat : la revente de téléphones est impossible sans statut de fabricant, et le pack seul n'a pas atteint ses seuils | 4 600 € |
| Jour 60 | Moins de 15 précommandes payées en trois semaines | 8 000 à 10 000 € |
| Jour 120 | Moins de 70 % d'installations réussies sans aide, ou plus de 12 % de retours sur les téléphones | 15 000 € |
| Mois 6 | Moins de 15 commandes organiques par mois au troisième mois de vente | 12 000 à 15 000 € |
| Mois 9 | Trésorerie inférieure à trois mois de charges fixes sans emprunt accordé | 15 000 à 20 000 € |
| A tout moment | Incident de sécurité lié à un conseil erroné, sans correction possible sous 7 jours | |
| A tout moment | Fonds propres engagés supérieurs à 25 000 € sans EBITDA mensuel positif depuis trois mois | 25 000 € |

Critères de poursuite : ils sont le miroir des précédents et figurent dans `06_acquisition_marque.md`, section 7.

## 6. Comment détecter tôt ce qui peut tout tuer

| Menace | Indicateur à suivre | Fréquence | Coût |
|---|---|---|---|
| Absence de demande payante | Taux d'inscription, précommandes, commandes organiques | Hebdomadaire | 0 € |
| Publicité non rentable | Coût par commande contre marge de contribution | Hebdomadaire | 0 € |
| Concurrent en français | Recherche "survie hors ligne" sur les boutiques d'applications, alertes sur les noms des concurrents | Mensuelle | 0 € |
| Problème de conformité | Publications de l'ANFR, fiches européennes des modèles revendus | Mensuelle | 0 € |
| Dérive de qualité de l'IA | Jeu de 100 questions, taux de réponses correctes et sourcées | A chaque version | 0 € |
| Dérive de réputation | Lecture des commentaires, veille sur le nom de la marque | Hebdomadaire | 0 € |
| Tension de trésorerie | Semaines de charges fixes en réserve, semaines de stock | Mensuelle | 0 € |

## 7. Scénarios de sortie

Ordres de grandeur, sans promesse. Les multiples viennent d'observations de 2026 sur les marques de commerce en ligne : 1,5 à 7 fois l'EBITDA ajusté, 3,5 à 5,5 fois pour les marques différenciées, 2 à 3 fois en cas de dépendance à un seul canal [S69].

| Scénario à 3 ans | Situation | Acquéreurs plausibles | Valeur indicative |
|---|---|---|---|
| Arrêt | Critères d'arrêt atteints | Aucun. Revente du stock et du nom de domaine | Perte de 2 500 à 15 000 € selon la date d'arrêt |
| Petit actif | Scénario prudent prolongé : une liste de quelques milliers d'adresses, une application, peu de résultat | Boutique spécialisée française, créateur de contenu | 10 000 à 40 000 € [EST] |
| Entreprise artisanale | Scénario central : 440 000 € de chiffre d'affaires, 16 000 € d'EBITDA après 30 000 € de rémunération | Boutique de survie ou d'outdoor, repreneur individuel | 41 000 à 74 000 € sur l'EBITDA, jusqu'à 115 000 à 210 000 € si l'acquéreur raisonne sur le revenu total du dirigeant (46 500 €) |
| Marque de référence | Scénario ambitieux : 1,5 M€ de chiffre d'affaires, 102 000 € d'EBITDA, présence dans deux ou trois pays | Distributeur d'équipement de plein air, éditeur d'applications voulant le marché francophone, marque de téléphones durcis | 255 000 à 460 000 € |
| Cas favorable hors modèle | Licence du corpus à une marque de téléphones, à un assureur ou à un opérateur pour ses programmes de prévention | Partenaire industriel | Redevance de quelques euros par appareil, ou rachat. Non chiffrable aujourd'hui |

Ce qui a de la valeur pour un acquéreur, par ordre décroissant : la liste de clients et d'abonnés, le corpus de fiches validées en français, la marque et son référencement, l'application. Le stock et les relations fournisseurs n'en ont pas.

Conséquence pour la conduite du projet : si la cession est l'objectif, chaque euro et chaque heure doivent aller vers ces quatre actifs, pas vers le matériel.

## 8. Réponses aux cinq questions de la mission

| Question | Réponse |
|---|---|
| Le marché est-il assez grand et assez solide ? | Solide dans son principe, porté par les pouvoirs publics. Trop étroit en France pour l'ambition affichée : quelques millions d'euros par an pour ce type de produit. Assez grand pour une petite entreprise |
| Le produit est-il faisable et défendable avec le budget ? | Faisable dans sa version logicielle. Non faisable comme téléphone de marque propre. Faiblement défendable : par l'exécution et la langue, pas par la technologie |
| Quel est le chemin le plus court vers une première vente réelle ? | Page d'atterrissage (jour 4), liste d'attente (jour 20), société et précommandes du pack carte (jours 31 à 50), livraison (jours 60 à 75). Environ dix semaines et 8 000 à 10 000 € |
| Qu'est-ce qui peut tout tuer, et comment le détecter tôt ? | Le substitut gratuit et un coût d'acquisition supérieur à la marge. Détection en trois semaines par le taux d'inscription et le coût par inscrit |
| Faut-il y aller, arrêter ou pivoter ? | Pivoter vers le pack logiciel en français, tester 30 jours pour 2 500 €, décider sur des seuils fixés à l'avance |

## 9. Avocat du diable sur ma propre recommandation

- Je recommande peut-être un pivot par confort d'analyste. Un produit logiciel à 49 ou 89 € est plus facile à défendre sur le papier, mais il est aussi plus facile à copier et il vaut moins cher à la revente qu'une marque de matériel. Si le fondateur veut une entreprise de matériel, la bonne réponse est de chercher 200 000 € et un associé technique, pas d'adapter l'ambition au budget.
- Le test peut donner un faux positif. S'inscrire à une liste d'attente ne coûte rien. C'est pourquoi le vrai juge de paix est l'étape des précommandes payées, au jour 60.
- Le test peut donner un faux négatif. Un message maladroit ou une mauvaise semaine peuvent tuer une bonne idée. C'est pourquoi le plan prévoit deux vagues et trois messages avant de conclure.
- Mes probabilités de la section 1 sont des intuitions d'opérateur, pas des calculs. Elles servent à calibrer l'engagement, pas à prédire.
