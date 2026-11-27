# État de l'assistant SIJAMAIS

Fiche à joindre à chaque cycle d'amélioration (`prompts/claude_amelioration_assistant.md`). Mise à jour par Claude Code après chaque intégration. **Cycle 1 intégré le 27/11/2026. Cycle en cours : 2 (alerte, sirène, mise à l'abri, évacuation).**

## Ce que l'assistant sait faire (version 0.2 du 27/11/2026)

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
| 20 questions de la version 0.1 | 20 / 20 |
| Boutons de clarification : chacun mène à une réponse définitive | oui |
| Lignes de santé affichées : toutes présentes mot pour mot dans un guide | oui |
| Nourrisson : jamais « creux de l'estomac » | oui |

**Mesure honnête de la généralisation.** Avant correction, sur des questions jamais vues : 10 / 16, puis 11 / 16, puis 9 / 15. Erreurs graves trouvées puis corrigées : « mon fils a avalé une pile » (renvoyait au guide Grand froid), « un enfant s'est noyé dans la piscine » (Étouffement), « il a pris un coup de couteau » (Risques), « crise d'asthme » (Communication de crise), « elle s'étouffe, elle peut plus parler » (consigne de toux). Conclusion : le triage par règles corrige vite les familles de cas connues, mais chaque nouvelle formulation peut tomber dans un trou.

## Faiblesses connues

- **Règles écrites à la main** : fragiles face à une formulation inattendue. Il faut des questions nouvelles à chaque cycle, de préférence écrites par d'autres personnes que l'évaluateur.
- **Guides manquants** : AVC, convulsions, étouffement et arrêt cardiaque du nourrisson, intoxication, réaction allergique grave, noyade, malaise cardiaque conscient. L'assistant renvoie au 15 sans gestes.
- **Pas de mémoire de la conversation** : une précision donnée après coup (« il respire encore ») n'est pas reliée à la question précédente, sauf par les boutons.
- **Fuite de gaz** : renvoie au guide Monoxyde de carbone, à revoir au cycle 3 (réseaux).
- **196** : ajouté au guide des numéros, à vérifier sur service-public.gouv.fr (inaccessible depuis l'environnement de Claude).

## Prochaines étapes techniques (Claude Code)

1. Recherche par le sens (plongements de phrases d'Apple, cadre NaturalLanguage, sur l'iPhone) combinée aux mots, pour réduire les trous.
2. Mémoire courte : relier une précision à la question précédente.
3. Intégrer les guides AVC et nourrisson après relecture par un formateur PSC1.

## Questions qu'un cycle 2 doit pousser

Sirène, FR-Alert, mise à l'abri, évacuation, confinement, avec des formulations d'enfants, de personnes âgées, de touristes, des questions mêlant deux sujets (« la sirène sonne et mon fils est dehors »), et des mots trompeurs (« alerte » d'une application bancaire, « évacuer » une baignoire).
