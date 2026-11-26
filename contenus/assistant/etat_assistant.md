# État de l'assistant SIJAMAIS

Fiche à joindre à chaque cycle d'amélioration (`prompts/claude_amelioration_assistant.md`). Mise à jour par Claude Code après chaque intégration. **Cycle en cours : 1.**

## Ce que l'assistant sait faire aujourd'hui (version 0.1 du 26/11/2026)

1. **Recherche par mots** dans les 46 guides (`contenus/guides/guides_v1.1.json`) :
   - la question est mise en minuscules, sans accents ; les mots courts et les mots vides (« le », « comment », « je »...) sont retirés ;
   - chaque mot est complété par une petite liste de synonymes (exemple : « courant » ajoute « électricité » et « coupure ») ;
   - chaque mot est réduit à une racine grossière (« inondation » devient « inondatio ») ;
   - chaque passage de guide reçoit 1 point par racine qu'il contient ; le titre et le résumé du guide valent 2 points ;
   - le guide qui a le meilleur total gagne, s'il atteint 3 points ; on affiche ses 3 meilleurs passages.
2. **Règles de sécurité** :
   - question de santé (mots « respire », « saigne », « inconscient », « brûlure », « étouffe », « malaise », « douleur », « poitrine »...) : bandeau « Urgence vitale, 15, 112 » et étapes exactes du guide, **jamais de reformulation** ;
   - si la personne parle d'elle-même (« je », « j' », « moi ») avec un mot de santé : « Appelez le 15 ou le 112 maintenant, 114 par SMS si vous ne pouvez pas parler » ;
   - aucun guide trouvé : « Je n'ai pas trouvé de guide sur ce sujet », sans rien inventer.
3. **Reformulation** (iPhone 15 Pro et plus récents, iOS 26) : le modèle d'Apple, sur l'iPhone, sans réseau, reçoit la question et les 3 passages, et rédige 5 phrases au plus en citant le guide. Réponse refusée si elle cite un autre guide ou dépasse 900 caractères. Fenêtre du modèle : 4 096 jetons en tout.

## Faiblesses constatées (retour de Benjamin, 26/11/2026)

- Les réponses dépendent trop des mots exacts : un mot absent des synonymes fait échouer la recherche, et un mot fréquent peut tirer vers un mauvais guide.
- Certaines réponses sont « hors sol » : le meilleur passage par mots n'est pas toujours celui qui répond.
- Pas de compréhension de l'intention (s'informer, agir tout de suite, se préparer), ni de question de clarification (« pour vous ou pour un proche ? »).
- Peu de questions de test : 20 aujourd'hui.

## Pistes techniques prévues de mon côté (Claude Code)

- **Recherche par le sens** avec les plongements de phrases d'Apple (cadre NaturalLanguage, français, sur l'iPhone, sans réseau), combinée à la recherche par mots.
- **Classement des intentions** : urgence vitale pour soi, urgence pour un proche, consigne pendant un événement, préparation, après la crise, hors sujet, loisir.
- **Questions de clarification** quand la demande est ambiguë.
- **Banc d'essai automatique** : chaque cas de test produit par les cycles devient un test rejoué à chaque version.

## Cas de test actuels

| Question | Guide attendu | Santé |
|---|---|---|
| Mon voisin ne respire plus | arret-cardiaque | oui |
| il saigne beaucoup du bras | saignement | oui |
| Plus de courant depuis hier | coupure-electricite | non |
| Que mettre dans le kit ? | kit72h | non |
| La sirène sonne, que faire ? | alerte | non |
| Mon ordinateur demande une rançon | cyberattaque | non |
| Comment rendre l'eau potable ? | eau | non |
| il fait 40 degrés chez moi | canicule | non |
| trouver le nord sans boussole | orientation | non |
| délai pour déclarer à l'assurance après une inondation | assurance | non |
| mon fils s'étouffe avec un bonbon | etouffement | oui |
| quand prendre les comprimés d'iode | risques | non |
| l'eau monte dans la rue | risques | non |
| SMS bizarre de ma banque | cyberattaque | non |
| quel champignon puis-je manger | cueillette | non |
| Combien d'eau stocker ? | stocks | non |
| Délai pour déclarer à l'assurance | assurance | non |
| Donne moi le rythme à avoir pour le massage cardiaque | arret-cardiaque | non |
| J'ai peur | moral | non |
| je panique | moral | non |
| Je n'arrive plus à respirer (urgence personnelle) | appeler le 15 | oui |
