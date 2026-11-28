# Mode Voyage : contenu

Fabriqué par `outils/construire_voyage.py` (28/11/2026). Le script écrit `voyage_v1.json` et sa copie dans les ressources du cœur de l'application.

## Statut des données (à lire avant publication)

| Donnée | Statut |
|---|---|
| 112 dans les 26 pays de l'Union européenne (hors France) | Règle européenne : numéro d'urgence unique valable dans toute l'Union. Marqué vérifié |
| Numéros nationaux hors UE (40 pays) et compléments (Espagne 091, Grèce 1571) | [MEMOIRE], marqués « À confirmer » dans l'application. **À vérifier un par un** sur la fiche Conseils aux voyageurs du pays (diplomatie.gouv.fr), puis passer `verifie` à vrai dans le script |
| Traductions des 20 phrases en 10 langues | Rédigées par l'assistant, **non relues**. L'application affiche « Traduction en cours de relecture ». Faire relire chaque langue par un locuteur natif, puis passer `relu` à vrai |
| Liste de départ | Conseils généraux. Délai de la carte européenne d'assurance maladie [A VERIFIER] sur ameli.fr |

## Gratuit et premium

- **Gratuit** (protège) : numéros d'urgence du pays, 11 phrases vitales (aide, ambulance, police, incendie, perte de connaissance, blessure, médecin, hôpital, allergie grave, enfant disparu, « je ne parle pas votre langue »), Ariane, conseils aux voyageurs, proche prévenu.
- **Premium** : 9 phrases pratiques (pharmacie, diabète, grossesse, médicament, passeport perdu, vol, ambassade, perdu, adresse), liste de départ complète, dossier de voyage chiffré (Face ID) avec fiche santé traduite.

## Avocat du diable

- Un numéro d'urgence faux est pire que pas de numéro : tant qu'un pays n'est pas vérifié, l'application le dit, et le bouton « Conseils aux voyageurs » reste visible.
- Une traduction approximative dans une urgence médicale peut tromper un soignant : relecture native obligatoire avant la sortie publique.
