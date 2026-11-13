# 02. Concurrence et substituts

> **Mise à jour du 13/11/2026.** Le produit a changé : application iPhone gratuite avec version complète. Pour HAVEN, la référence est désormais `09_application_iphone.md`. Ce document reste valable pour le reste de la cartographie. Correction : HAVEN propose une interface en français (traduction en option), avec un contenu resté en anglais et sans source, auteur ni date. Voir `08_analyse_haven.md`.

Document de la phase 1 du projet HUMAN, rédigé le 12 novembre 2026. Les identifiants S renvoient à `sources.md`, les identifiants H à `registre_hypotheses.md`. Marqueurs : [FAIT], [EST], [HYP], [INT].

## 1. Conclusion

1. L'hypothèse "cet assemblage n'existe pas" est fausse à l'échelle mondiale. Un smartphone durci préchargé avec une IA hors ligne, des applications de survie et des cartes est vendu 349,99 USD aux Etats-Unis [FAIT, S22]. Au moins trois autres appareils et plus de dix applications occupent le même terrain [S23 à S29].
2. Elle reste vraie en français. Je n'ai trouvé aucune offre packagée en langue française, avec cartes de France, contenus adaptés au cadre français et conformité européenne [FAIT négatif, recherche du 12/11/2026]. La fenêtre existe, mais elle est locale et temporaire.
3. Toutes les briques sont gratuites et libres : Kiwix, Organic Maps, Gemma 4, Project NOMAD [S30, S31, S49, S53]. Il n'y a pas de barrière technologique. La valeur est dans le choix des contenus, l'intégration, la langue, la confiance et le service.
4. Le substitut le plus dangereux n'est pas un concurrent. C'est le client qui installe trois applications gratuites sur le téléphone qu'il possède déjà, en une après-midi.
5. Le matériel est une commodité chinoise à faible marge, exposée à un risque réglementaire réel : l'ANFR a retiré deux téléphones durcis du marché français en 2025 [FAIT, S58].

Conséquence stratégique : se battre sur le logiciel et le contenu en français, et traiter le téléphone comme un accessoire que l'on revend, pas comme le produit.

## 2. Produits packagés "savoir ou IA hors ligne"

| Produit | Pays | Forme | Contenu | Prix | Statut | Faiblesses |
|---|---|---|---|---|---|---|
| Survival Node Gen 2 (Eastern Shore AI) [S22] | Etats-Unis | Smartphone durci préchargé, valise étanche, batterie solaire 24 000 mAh, deux sacs Faraday | IA hors ligne, 50 Go d'applications de survie, cartes des Etats-Unis | 349,99 USD | En vente | Source unique, anglais seulement, cartes américaines, pas de conformité européenne connue |
| The Ark [S23] | Etats-Unis | Appareil portable durci et application iOS | IA de survie hors ligne | Non trouvé | Réservation depuis 2024 | Deux ans d'annonces sans preuve de livraison trouvée |
| Prepper Disk Premium (Entropy Survival) [S29] | Etats-Unis | Raspberry Pi 4 en boîtier, point d'accès Wi-Fi, carte 512 Go | Wikipédia anglais complet, manuels médicaux, documents FEMA | 239,95 USD (269,95 hors promotion) | En vente, garantie 1 an | Pas un téléphone, pas d'écran, anglais, jugé "faisable soi-même pour moitié prix" [S36] |
| Trove [S24] | Non précisé | Clé USB 256 Go | Modèle d'IA, Wikipédia, cartes, 380 livres | Non trouvé | Page de vente | Nécessite un ordinateur, anglais |
| Kiwix Hotspot et image "Preppers" [S31] | Suisse | Raspberry Pi 5 préchargé, ou image de 200 Go à télécharger | Wikipédia et bibliothèques hors ligne | Image : 29 USD | En vente par l'éditeur de Kiwix lui-même | Pas d'IA, interface austère, pas de téléphone |
| Project N.O.M.A.D. [S30] | Etats-Unis | Logiciel libre à installer sur un mini-ordinateur | Kiwix, IA locale, recherche sémantique, cartes, cours | Gratuit | Environ 30 000 étoiles GitHub | Réservé aux bricoleurs, gourmand en ressources |
| Off Grid AI [S25] | Etats-Unis | Logiciel pour matériel embarqué | IA de survie hors ligne | Non trouvé | Lancé en juillet 2026 | Jeune, anglais |

Trois enseignements.

- Le concept est validé par l'offre, pas encore par la demande. Aucun de ces acteurs ne publie ses ventes. Leur multiplication prouve que des entrepreneurs y croient, pas que les clients achètent.
- Des clients paient une prime de commodité. Prepper Disk vend environ 240 USD un assemblage dont les composants valent une centaine de dollars et dont le contenu est gratuit [S29, S36]. La prime pour "prêt à l'emploi" existe donc, au moins aux Etats-Unis.
- Le prix de référence du "téléphone de survie avec IA" est déjà fixé : 350 USD, accessoires compris [S22]. Un produit français à 500 € ou plus devra justifier l'écart.

## 3. Applications mobiles

| Application | Plateformes | Contenu | Prix | Français | Remarques |
|---|---|---|---|---|---|
| HAVEN [S26] | iOS, Android | IA sur l'appareil, cartes topographiques hors ligne, modules par scénario | Gratuit, version Pro en achat unique à 24,99 USD, famille 34,99 USD | Non confirmé | Classée première par une boutique française de survie [S32] |
| Prepper AI [S27] | iOS, Android | IA locale, 236 cartes hors ligne, plus de 48 livres | Achats intégrés | Non confirmé | |
| Preppi [S28] | Android | IA hors ligne, cartes, signal SOS | Non relevé | Non confirmé | 6 Go de RAM requis |
| Survivalist.AI [S32] | iOS surtout | IA hors ligne | Non relevé | Page en français | 6 Go de RAM requis |
| Google AI Edge Gallery [S33] | Android | IA locale généraliste (Gemma), gratuite | Gratuit | Oui (modèle multilingue) | Fournie par Google, sans contenu de survie |
| Kiwix [S31] | Toutes | Wikipédia, WikiMed, Vikidia et autres hors ligne | Gratuit | Oui | Le standard de fait |
| Organic Maps, OsmAnd [S53, S32] | iOS, Android | Cartes OpenStreetMap hors ligne, navigation | Gratuit ou peu cher | Oui | Excellentes |
| Survival Manual (libre) | Android | Manuel de survie de l'armée américaine, hors ligne | Gratuit | Partiel | Référence historique |

Constat : en anglais, le terrain applicatif est saturé et le prix du marché est de 25 à 35 USD en achat unique. En français, aucune application ne s'est imposée. Mais un éditeur américain peut traduire son application en quelques semaines. L'avance linguistique ne vaut que si elle s'accompagne de contenus réellement français (numéros d'urgence, cadre légal, cartes IGN, fiches validées par des professionnels français).

## 4. Smartphones durcis

| Modèle | Batterie | Puce et mémoire | Prix public relevé | Point notable |
|---|---|---|---|---|
| Ulefone Armor 22 Pro [S42] | 6 600 mAh | Helio G200, 8 Go | 239,99 USD au lancement (août 2026) | eSIM |
| Ulefone Armor 24 Pro [S42] | 22 000 mAh | Helio G200, 12/256 Go | 359,99 USD au lancement, offres européennes dès 272 € TTC | 647 g, 27,5 mm d'épaisseur |
| Ulefone Armor 27T Pro [S43] | 10 800 mAh | Non relevé | 449,99 € | Caméra thermique |
| Ulefone Armor 28 Pro [S42] | 10 600 mAh | Dimensity 7300, 16 Go | 529 USD (attendu) | Le plus apte à l'IA locale |
| Oukitel WP100 Titan [S41] | 33 000 mAh | Dimensity 7300, 16/512 Go | 620 à 980 € TTC selon revendeur | Projecteur intégré, marque visée par l'ANFR sur un autre modèle |
| Samsung Galaxy XCover 7 [S43] | 4 050 mAh amovible | 6 Go | 330 à 400 € | Grande marque, mises à jour longues |
| Crosscall (France) | Variable | Variable | Gamme professionnelle | Marque française installée dans le B2B, situation actuelle à vérifier |

Faiblesses communes des marques chinoises de téléphones durcis :

- suivi logiciel court. Ulefone annoncerait deux versions d'Android garanties sur ses nouveaux modèles (source non vérifiée), alors que le droit européen impose cinq ans de mises à jour [S54]. Aucune politique publiée trouvée pour Doogee et Oukitel ;
- conformité fragile. En février 2025, l'ANFR a ordonné le retrait de l'Ulefone Note 16 Pro et de l'Oukitel WP28 pour dépassement du débit d'absorption spécifique. Ulefone a corrigé par mise à jour, Oukitel non [FAIT, S58] ;
- poids et encombrement. Le modèle à 22 000 mAh pèse 647 g [S42], soit plus de trois fois un téléphone ordinaire. "Minimaliste" et "très forte autonomie" tirent dans des directions opposées ;
- émetteurs radio intégrés à usage réglementé sur certains modèles (voir `04_legal.md`).

Ces marques vendent déjà "le téléphone qui tient deux semaines". Nous n'apporterons rien sur le matériel. Elles peuvent en revanche précharger du contenu demain si le créneau devient visible : c'est une menace à moyen terme.

## 5. Communication de secours

| Solution | Coût | Ce qu'elle fait | Limite | Rapport à notre produit |
|---|---|---|---|---|
| Appel d'urgence par satellite des iPhone récents | Inclus | Message d'urgence sans réseau | Urgence seulement | Rend moins nécessaire un appareil dédié à l'alerte |
| Orange Message Satellite [S37] | 5 € par mois | SMS et position sans réseau | Pixel 9 et 10 seulement | Idem, appelé à se généraliser |
| Starlink direct vers mobile [S38] | Non commercialisé | Messages puis données | Pas autorisé en France à ce jour | Menace à 2 ou 3 ans sur l'argument "sans réseau" |
| Garmin inReach Mini 3 [S39] | 450 à 500 € et 10 à 60 € par mois | Messagerie satellite mondiale, SOS | Abonnement | Complément, pas concurrent |
| Noeuds LoRa Meshtastic [S40] | 40 à 100 € | Messagerie texte locale sans réseau | Portée et débit faibles, communauté de bricoleurs | Accessoire possible du catalogue |
| Radio à manivelle ou à piles | 15 à 60 € | Réception d'information | Réception seule | Produit de base du kit officiel [S02], accessoire évident |
| Talkies-walkies PMR446 | 30 à 150 € la paire | Voix locale sans licence | Quelques kilomètres | Accessoire possible |

Lecture : la communication de secours est en train d'être absorbée par les téléphones ordinaires et les opérateurs. Ne pas bâtir la promesse sur "communiquer sans réseau". La promesse qui tient est "savoir sans réseau".

## 6. Le substitut le plus dangereux : le faire soi-même

| Option | Coût | Temps | Résultat |
|---|---|---|---|
| Téléphone existant, Kiwix, Organic Maps, Google AI Edge Gallery, quelques PDF | 0 € | 3 à 6 heures de téléchargement et de réglages | Equivalent fonctionnel à 80 % |
| Idem, plus une carte mémoire de 256 Go | 25 à 40 € | Idem | Idem, sans saturer le téléphone |
| Téléphone durci acheté en ligne, plus les mêmes applications | 200 à 300 € | Idem | Equivalent à notre "téléphone prêt à l'emploi" |
| Notre pack carte (hypothèse) | 89 € | 5 minutes | Contenus choisis en français, fiches validées, recherche unifiée, mises à jour |
| Notre téléphone prêt à l'emploi (hypothèse) | 319 à 449 € | 0 minute | Idem, plus garantie et assistance en France |

Pourquoi des clients paieraient-ils quand même ? Quatre raisons plausibles, toutes à vérifier :

1. le temps et la compétence. La majorité des ménages du segment 1 n'installera jamais Kiwix [HYP, H04] ;
2. la confiance. Des fiches de premiers secours relues par des professionnels français valent plus qu'une réponse d'IA non sourcée [HYP] ;
3. la cohérence. Une seule application, une seule recherche, une interface lisible en situation de stress ;
4. le cadeau. Un objet physique s'offre, une liste d'applications ne s'offre pas [INT].

Et pourquoi ne paieraient-ils pas ? Le public le plus motivé (segment 2) est précisément celui qui sait faire seul et qui le dit [S36]. Le produit doit donc viser ceux qui ne savent pas ou ne veulent pas, ce qui renchérit l'acquisition : ils ne cherchent pas activement ce produit.

## 7. Carte des positions

| | Savoir généraliste | Savoir de survie organisé | IA conversationnelle |
|---|---|---|---|
| Gratuit, à assembler | Kiwix, Organic Maps | Survival Manual, PDF | Google AI Edge Gallery, NOMAD |
| Payant, application | | HAVEN, Prepper AI, Preppi (anglais) | HAVEN, Survivalist.AI |
| Payant, objet prêt à l'emploi | Prepper Disk, Kiwix Hotspot (anglais) | Survival Node (anglais) | Survival Node, The Ark |
| Payant, prêt à l'emploi, en français, conforme UE | Personne | Personne | Personne |

La dernière ligne est la place disponible. Elle est défendable deux à trois ans par l'exécution (contenus, marque, communauté), pas par la technologie.

## 8. Menaces à surveiller

| Menace | Probabilité à 24 mois | Signal précoce |
|---|---|---|
| Un éditeur américain (HAVEN) lance une version française | Elevée | Fiche de l'application en français sur les boutiques |
| Ulefone ou une autre marque précharge un "mode survie" | Moyenne | Annonces produit au salon de Barcelone en février |
| Google ou Apple intègrent un assistant hors ligne généraliste suffisant | Elevée | Fonctions hors ligne des assistants intégrés |
| La Croix-Rouge ou l'Etat publient une application gratuite de référence | Moyenne | Appels d'offres publics, communication de la sécurité civile |
| Une boutique française de survie assemble la même offre | Moyenne | Catalogue des boutiques spécialisées, déjà prescriptrices d'applications [S32] |

## 9. Avocat du diable

- "Personne ne le fait en français, donc il y a une place." Ou bien personne ne le fait parce que le marché francophone est trop petit pour amortir le travail de contenu. Les deux explications sont compatibles avec les faits.
- "L'IA locale est un différenciant." Tous les concurrents l'ont. Et c'est la partie la moins fiable du produit : sur un test de 22 questions de sécurité, un modèle léger n'en réussit que 14 [S34]. L'IA est un argument d'appel et un risque de réputation, pas un avantage durable.
- "Le matériel durci nous distingue." Il nous aligne sur un prix public transparent : le client voit le même téléphone à 272 € en ligne [S42].
