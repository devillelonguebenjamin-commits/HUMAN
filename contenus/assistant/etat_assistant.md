# État de l'assistant SIJAMAIS

Fiche à joindre à chaque cycle d'amélioration (`prompts/claude_amelioration_assistant.md`). Mise à jour par Claude Code après chaque intégration. **Cycles 1 et 2 intégrés le 27/11/2026. Cycle en cours : 3 (coupure d'électricité, d'eau, de réseau).**

## Ce que l'assistant sait faire (version 0.3 du 27/11/2026)

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
| 20 questions de la version 0.1 | 20 / 20 |
| Boutons de clarification : chacun mène à une réponse définitive | oui |
| Lignes de santé affichées : toutes présentes mot pour mot dans un guide | oui |
| Nourrisson : jamais « creux de l'estomac » | oui |

**Mesure honnête de la généralisation.** Avant correction, sur des questions jamais vues : 10 / 16, puis 11 / 16, puis 9 / 15. Erreurs graves trouvées puis corrigées : « mon fils a avalé une pile » (renvoyait au guide Grand froid), « un enfant s'est noyé dans la piscine » (Étouffement), « il a pris un coup de couteau » (Risques), « crise d'asthme » (Communication de crise), « elle s'étouffe, elle peut plus parler » (consigne de toux). Conclusion : le triage par règles corrige vite les familles de cas connues, mais chaque nouvelle formulation peut tomber dans un trou.

Cycle 2 : 37 / 40 au premier passage. Questions nouvelles du thème avant correction : 13 / 20. Erreurs trouvées puis corrigées : « il pleut, ma rue est une piscine » (déclenchait la règle de noyade), « SMS de la préfecture : se confiner » (guide Cyberattaque), « les pompiers disent au haut-parleur de rester chez soi » (kit 72 h), « fin d'alerte » (guide de pilotage communal), « alerte enlèvement » (guide Alerte).

## Faiblesses connues

- **Règles écrites à la main** : fragiles face à une formulation inattendue. Il faut des questions nouvelles à chaque cycle, de préférence écrites par d'autres personnes que l'évaluateur.
- **Guides manquants** : AVC, convulsions, étouffement et arrêt cardiaque du nourrisson, intoxication, réaction allergique grave, noyade, malaise cardiaque conscient. L'assistant renvoie au 15 sans gestes.
- **Pas de mémoire de la conversation** : une précision donnée après coup (« il respire encore ») n'est pas reliée à la question précédente, sauf par les boutons.
- **Fuite de gaz** : « N'allumez aucune flamme » et « Couper le gaz » (guide Réflexes). Aucun guide ne dit encore « sortez et appelez l'urgence gaz » : passage à ajouter, avec sa source, au cycle 3.
- **Contenus proposés au cycle 2, non intégrés faute de source vérifiée** : orage en voiture et foudre (Météo-France, [A VERIFIER]) ; conseil « rumeur » dans le guide Alerte (redit déjà le guide Réflexes).
- **Question en anglais hors santé** (« how do I know if there is an alert ») : mal orientée ; peu de mots anglais reconnus hors urgences.
- **196** : ajouté au guide des numéros, à vérifier sur service-public.gouv.fr (inaccessible depuis l'environnement de Claude).

## Prochaines étapes techniques (Claude Code)

1. Recherche par le sens (plongements de phrases d'Apple, cadre NaturalLanguage, sur l'iPhone) combinée aux mots, pour réduire les trous.
2. Mémoire courte : relier une précision à la question précédente.
3. Intégrer les guides AVC et nourrisson après relecture par un formateur PSC1.

## Questions qu'un cycle 3 doit pousser

Coupure d'électricité, d'eau, de réseau téléphonique et internet, fuite de gaz, avec des personnes sous appareil médical électrique, des congélateurs, des ascenseurs bloqués, des formulations d'enfants et de personnes âgées, et des mots trompeurs (« coupure » au doigt, « réseau » social, « courant » d'air ou de rivière).
