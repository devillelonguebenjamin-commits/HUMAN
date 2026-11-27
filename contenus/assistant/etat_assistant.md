# État de l'assistant SIJAMAIS

Fiche à joindre à chaque cycle d'amélioration (`prompts/claude_amelioration_assistant.md`). Mise à jour par Claude Code après chaque intégration. **Cycles 1 à 6 intégrés le 27/11/2026. Arbitrages validés et appliqués (guides 1.2). Prochaine étape : cycle 7 transversal ou recherche par le sens.**

## Ce que l'assistant sait faire (version 0.4 du 27/11/2026)

L'assistant répond en deux étages, sur l'iPhone, sans réseau.

### Étage 1 : le triage (nouveau, cycle 1)

Avant toute recherche, la question est préparée (minuscules, sans accents, contractions développées : « jai » devient « j ai », « ya » devient « il y a »), puis passe dans cet ordre :

1. **Mots trompeurs** : « brûlures d'estomac » (hors périmètre digestif), « téléphone inconscient » (appareil), « j'étouffe de chaleur » (le mot « étouffe » est retiré, la question va vers Canicule).
2. **Hors périmètre** : animaux (vétérinaire), armes et défense (17 ou 112), feux de jardin (mairie), plantes pour soigner, posologie et diagnostic (pharmacien, médecin, 15). Réaction allergique grave : traitée avant comme urgence vitale.
3. **Signes graves sans guide** : AVC, convulsions, ingestion d'un produit ou d'un objet (pile, javel, médicaments, champignons), overdose, asthme, électrocution, gorge ou visage qui gonfle, noyade. Réponse : « Appelez le 15 ou le 112 immédiatement (114 par SMS)... Je n'ai pas encore de guide sur ces signes », avec bandeau urgence vitale.
4. **Après coup** (cauchemars, « après avoir... ») : guide Moral. **Se former** : guide Entraide et engagement. **Information** (applis, trousse, formation) : pas de triage vital, recherche par mots.
5. **Urgence personnelle** : la personne parle d'elle (je, j', moi), d'aucun tiers (il, elle, mon mari, bébé, voisin...), et décrit une détresse vitale (respirer, poitrine, cœur, étouffer, malaise, s'évanouir, « je vais tomber », saigner beaucoup) : « Appelez le 15 ou le 112 maintenant ».
6. **Cas particuliers** : noyade ; mer ou bateau (196 et 112) ; chaleur avec confusion ou fièvre (alerte Canicule) ; **nourrisson** (bébé, nourrisson, « 6 mois ») : alerte « 15 ou 112, haut-parleur » et conseil « Nourrisson : les gestes sont différents », **jamais les gestes de l'adulte** ; étouffement avec toux efficace : seulement « encouragez-la à tousser ».
7. **Priorité entre urgences** : incendie du logement (plus refroidir la brûlure s'il y en a une) > monoxyde de carbone (appareil à combustion et symptômes) > saignement abondant > arrêt cardiaque > inconscient qui respire > étouffement > brûlure. Les lignes affichées sont prises **mot pour mot** dans les guides (vérifié par un test).
8. **Clarification**, avec boutons, au plus deux questions de suite :
   - « malaise » seul : « Pour moi » ou « Pour un proche » ;
   - quelqu'un de tombé, inconscient, qui ne se réveille pas : « Ne répond pas, ne respire pas » (arrêt cardiaque), « Ne répond pas mais respire » (PLS), « Répond » (orientation) ;
   - « il saigne » sans précision : « Il saigne beaucoup » (gestes) ou « Petite plaie » (pharmacien).
9. **Petits maux** (fièvre, saignement de nez, mal au ventre...) : pas de guide, pharmacien ou médecin, 15 en cas de signe grave.

### Étape « alertes et risques majeurs » (nouvelle, cycle 2)

Placée juste après les mots trompeurs, avant tout le reste. Le guide « Que faire selon le risque » regroupe 13 risques : l'assistant repère le risque et n'affiche **que sa section**, mot pour mot, **sans reformulation** (mode « consigne », comme la santé). Le guide reste un seul guide à l'écran.

1. **Hors périmètre du thème** : fabriquer un filtre ou un masque (renvoi à la consigne « bâtiment clos, linge humide »), conseil juridique (service-public.gouv.fr, guide Assurance), météo (Météo-France, l'application est hors ligne), écouter ou pirater les radios des secours, dégât des eaux domestique (lave-linge, tuyau), alerte enlèvement.
2. **Métaphores** : « tempête de critiques », « sous le feu des critiques » vont au guide Moral. Toute réponse du guide Moral affiche la ligne du **3114**.
3. **Rumeur** (TikTok, WhatsApp, « il paraît », vidéo) sur un barrage, une évacuation, une sirène : « N'écoutez que les annonces officielles », les 4 questions avant de partager, et la description de la vraie sirène de barrage.
4. **Barrage** : corne de brume, rupture : « j'évacue immédiatement et je gagne les points hauts » (bandeau urgence vitale). Barrage sans signal : description de la corne de brume et consignes.
5. **Information** : essais de sirène, fin d'alerte, radios, FR-Alert (« aucune inscription »), risques de ma commune (Géorisques, DICRIM, DDRM).
6. **Consigne de rester à l'abri reçue** (haut-parleur, SMS de la préfecture, confinement) : les 7 réflexes.
7. **Enfants à l'école** : « N'allez pas chercher vos enfants » en premier.
8. **Odeur de gaz**, même avec un autre risque : « N'allumez aucune flamme », « Couper le gaz » en premier. **Flamme pendant une mise à l'abri** (réchaud, bougie, groupe électrogène sans symptôme) : « aucune flamme » et l'alerte monoxyde ; avec symptômes : guide Monoxyde.
9. **Risques**, chacun avec la ligne la plus utile en tête : séisme (« Après » si le bâtiment est fissuré, « côtes » près de la mer, ascenseur), tsunami, nucléaire (« Ne prenez l'iode que sur instruction du préfet » en premier, sauf question « où retirer l'iode »), accident industriel et matières dangereuses (« Fermez portes et fenêtres » en tête si la personne veut ouvrir ; bandeau urgence si elle respire mal), attentat (« S'échapper, se cacher, alerter » ; jamais pour « attaque cardiaque »), animaux et évacuation, inondation (y compris « il pleut, ma rue est une piscine »), feu de forêt (« En voiture : restez dans le véhicule » en tête), tempête et cyclone (« Ne restez pas sous un arbre isolé », « œil du cyclone »), volcan, mouvement de terrain.
10. **Sirène habituelle** : mise à l'abri, radio, et dans la même bulle la consigne de la corne de brume ; en voiture, « ne restez pas dans un véhicule » en tête.
11. **Clarification** : « Je dois évacuer ou rester ? » (Inondation, Nuage toxique, Feu de forêt, Corne de brume ; rappel : sans consigne, on reste à l'abri), « Il y a un feu dehors » (forêt, en voiture, bâtiment), « alerte » seul (sirène, FR-Alert, corne de brume).

### Règles des cycles 3 à 6 (nouvelles), placées juste après les mots trompeurs

1. **Détresse suicidaire**, avant tout : « idées noires », « envie d'en finir », « je veux plus vivre », « marre de la vie »... Pour soi : « Appelez maintenant le 3114 », 15 ou 112, 114 ; pour un proche : « Ne laissez pas la personne seule » ; bouton « Appeler le 3114 » ; jamais reformulé.
2. **Hors périmètre** : droit (port d'un couteau, diffamation, attaquer son assureur), marques et achats, branchement d'un groupe électrogène, durée de conservation des aliments, stockage de carburant, vacances, numéros gaz et électricité (absents des guides), disjoncteur, batterie de voiture, régime, piégeage, boire son urine, feu de camp de loisir, abri de jardin, vengeance contre un arnaqueur, ménage, main courante au commissariat, drone, sport, piqûre d'ortie, harcèlement, **identification de plantes ou de champignons** (sauf les 3 plantes du guide) ; côté mairie : loi Matras, arrêtés, numéro du CSIRT, ressources humaines.
3. **Espace mairie** : les 5 guides de la commune sont **exclus de la recherche des particuliers** et activés par des mots d'élu ou d'agent (maire, PCC, nos agents, notre mairie, cellule de crise...). Une urgence vitale passe toujours devant.
4. **Clarification des demandes courtes** (8 mots au plus) : eau (72 h ou 2 semaines), sac (kit, évacuation, EDC), « plus de courant », couper, détecteur, abri, feu, eau pas potable, perdu, signaler, piraté, arnaque, assurance, rentrer chez moi, pas le moral, cyberattaque, communiquer, exercice, cellule de crise, mairie.
5. **Aiguillages** : appareil médical électrique pendant une coupure (prestataire et mairie en tête ; en détresse, 15 ou 112) ; ingestion (baies, produits, pile) : 15 ou 112 avec les boutons d'appel ; moral d'un proche, insomnie après la crise ; cyber des particuliers (faux site, rançon, compte piraté, mail de la banque, virus) ; assurance et hébergement ; retour au logement (odeur de gaz, ne rien jeter avant l'expert, animaux morts, chauffage) ; coupure d'électricité (monoxyde, batterie) ; préparation (détecteur, argent liquide, papiers, sac, kit, voiture, plan d'évacuation à pied, registre canicule, communication sans réseau, engagement, couper les réseaux) ; survie (perdu en forêt, signaux, 3 feux en période sèche, randonnée, règle des 3, bloqué dans la neige, eau de pluie, hypothermie).

### Composition des réponses (cycles 3 à 6)

- Jusqu'à 5 passages (8 quand le triage a déjà choisi le guide), 14 lignes au plus.
- **Une procédure ou une liste courte ne se montre jamais à moitié**, et garde son titre.
- **Les mises en garde du guide s'affichent toujours.**
- Les blocs les plus pertinents passent en premier.

### Étage 2 : la recherche par mots (version 0.1, enrichie)

- Mots et **expressions** synonymes (« pisse le sang », « avalé de travers », « tombé dans les pommes », « samu social », « idées noires »...), mots anglais (burn, bleeding, choking, breathe, unconscious, fire, flood).
- Chaque passage reçoit 1 point par racine trouvée, le titre et le résumé 2 points ; le meilleur guide gagne s'il atteint 3 points ; 3 passages affichés.
- Santé : jamais de reformulation ; ailleurs, reformulation par le modèle d'Apple (iPhone 15 Pro et plus récents, iOS 26), refusée si elle cite un autre guide ou dépasse 900 caractères.
- Question en anglais (3 mots anglais courants ou plus) : ligne « Emergency: call 112 » en plus de la réponse.

## Banc d'essai

| Lot | Résultat |
|---|---|
| 40 cas du cycle 1 (`cycle1/cas_de_test.json`) | 40 / 40 |
| 31 questions nouvelles, jamais vues par l'évaluateur (dans `Cycle1Tests.swift`) | 31 / 31 après correction |
| 40 cas du cycle 2 (`cycle2/cas_de_test.json`, écarts avec l'évaluateur expliqués dans le fichier) | 40 / 40 |
| 17 questions nouvelles du thème 2 (dans `Cycle2Tests.swift`) | 17 / 17 après correction |
| Consignes de risque majeur : jamais reformulées, toutes mot pour mot dans un guide | oui |
| Cycle 3, préparation et coupures (`cycle3/`) | 31 / 40, 9 échecs connus |
| Cycle 4, survie (`cycle4/`) | 29 / 40, 11 échecs connus |
| Cycle 5, après la crise, cyber, désinformation (`cycle5/`) | 36 / 40, 4 échecs connus |
| Cycle 6, Espace mairie (`cycle6/`) | 32 / 40, 8 échecs connus |
| 13 questions nouvelles des thèmes 3 à 6 (dans `Cycles3a6Tests.swift`) | 13 / 13 après correction |
| 20 questions de la version 0.1 | 20 / 20 |
| Boutons de clarification : chacun mène à une réponse définitive | oui |
| Lignes de santé affichées : toutes présentes mot pour mot dans un guide | oui |
| Nourrisson : jamais « creux de l'estomac » | oui |

**Mesure honnête de la généralisation.** Avant correction, sur des questions jamais vues : 10 / 16, puis 11 / 16, puis 9 / 15. Erreurs graves trouvées puis corrigées : « mon fils a avalé une pile » (renvoyait au guide Grand froid), « un enfant s'est noyé dans la piscine » (Étouffement), « il a pris un coup de couteau » (Risques), « crise d'asthme » (Communication de crise), « elle s'étouffe, elle peut plus parler » (consigne de toux). Conclusion : le triage par règles corrige vite les familles de cas connues, mais chaque nouvelle formulation peut tomber dans un trou.

Cycle 2 : 37 / 40 au premier passage. Questions nouvelles du thème avant correction : 13 / 20. Erreurs trouvées puis corrigées : « il pleut, ma rue est une piscine » (déclenchait la règle de noyade), « SMS de la préfecture : se confiner » (guide Cyberattaque), « les pompiers disent au haut-parleur de rester chez soi » (kit 72 h), « fin d'alerte » (guide de pilotage communal), « alerte enlèvement » (guide Alerte).

## Parcours guidé (27/11/2026)

Demande de Benjamin après des essais en famille : la plupart des questions libres tombaient à côté. L'onglet Assistant s'ouvre désormais sur « Être guidé pas à pas » : 8 grandes situations (danger maintenant, alerte en cours, événement, se préparer, après une crise, cyber, nature, Espace mairie), puis 1 ou 2 questions à choix, soit 14 questions et 67 fins de parcours (`contenus/assistant/parcours_v1.json`, script `outils/construire_parcours.py`). Chaque fin envoie au moteur une phrase sans ambiguïté ; un test vérifie que les 67 aboutissent au bon guide et au bon mode. La saisie libre reste disponible, avec un bouton pour revenir au parcours.

## Guides 1.2 (27/11/2026)

Eau sans eau de Javel ; Cueillette devenu guide de prudence (aucune identification) ; Stocks aligné sur Monoxyde ; numéros : 196 confirmé, 0 800 112 112 ajouté, numéro vert du signal d'alerte retiré ; Assurance actualisé (délais, franchise, hébergement). Interrupteur « Espace mairie » dans les réglages. Quand le triage choisit un guide sans trouver de passage, l'assistant affiche le début du guide (mises en garde comprises) au lieu d'une réponse vide.

## Faiblesses connues

- **32 échecs connus sur les cycles 3 à 6**, chacun décrit dans le fichier des cas (champ `echec_connu`). Presque tous sont des réponses incomplètes : la réponse idéale de l'évaluateur assemble plusieurs guides (« ordonnances » dans Documents, « pharmacien » dans Trousse, pour une question sur le sac d'évacuation). La recherche par mots ne sait pas faire cet assemblage ; c'est le principal argument pour la recherche par le sens.
- Mesure honnête avant correction : **14 cas sur 160** réussis au premier passage (thèmes jamais travaillés), puis 9 sur 16 questions nouvelles, dont une erreur grave (« je veux plus vivre » ne déclenchait rien).

- **Règles écrites à la main** : fragiles face à une formulation inattendue. Il faut des questions nouvelles à chaque cycle, de préférence écrites par d'autres personnes que l'évaluateur.
- **Guides manquants** : AVC, convulsions, étouffement et arrêt cardiaque du nourrisson, intoxication, réaction allergique grave, noyade, malaise cardiaque conscient. L'assistant renvoie au 15 sans gestes.
- **Pas de mémoire de la conversation** : une précision donnée après coup (« il respire encore ») n'est pas reliée à la question précédente, sauf par les boutons.
- **Fuite de gaz** : « N'allumez aucune flamme » et « Couper le gaz » (guide Réflexes). Le guide « Rentrer chez soi » dit aussi « Odeur de gaz : éloignez-vous et appelez les secours ou l'urgence gaz » : ligne affichée.
- **Contenus proposés au cycle 2, non intégrés faute de source vérifiée** : orage en voiture et foudre (Météo-France, [A VERIFIER]) ; conseil « rumeur » dans le guide Alerte (redit déjà le guide Réflexes).
- **Question en anglais hors santé** (« how do I know if there is an alert ») : mal orientée ; peu de mots anglais reconnus hors urgences.

## Prochaines étapes techniques (Claude Code)

1. Recherche par le sens (plongements de phrases d'Apple, cadre NaturalLanguage, sur l'iPhone) combinée aux mots, pour réduire les trous.
2. Mémoire courte : relier une précision à la question précédente.
3. Intégrer les guides AVC et nourrisson après relecture par un formateur PSC1.

## Questions qu'un cycle 3 doit pousser

Coupure d'électricité, d'eau, de réseau téléphonique et internet, fuite de gaz, avec des personnes sous appareil médical électrique, des congélateurs, des ascenseurs bloqués, des formulations d'enfants et de personnes âgées, et des mots trompeurs (« coupure » au doigt, « réseau » social, « courant » d'air ou de rivière).
