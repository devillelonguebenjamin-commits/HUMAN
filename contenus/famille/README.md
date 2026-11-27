# Parcours pas à pas du plan familial

Demande de Benjamin du 27/11/2026 : un système de questions interactives pour la partie Famille, sur le modèle du parcours guidé de l'assistant.

`plan_familial_v1.json` est produit par `outils/construire_famille.py` (texte en clair dans le script, à relire et corriger là). Le script copie aussi le fichier dans SijamaisCore, ce qui l'embarque dans l'application à chaque compilation.

## Les 12 étapes

1. Commune.
2. Risques de la commune : 4 au plus. Tempête et matières dangereuses sont cochées d'office, car le guide dit que tout le monde y est exposé. Chaque risque coché enregistre aussi sa consigne, recopiée mot pour mot du guide « Que faire selon le risque ».
3. Électricité : où est le tableau, avec la consigne pour couper.
4. Gaz : où est la vanne, avec la consigne pour couper.
5. Eau : où est le robinet d'arrivée, avec la consigne pour couper.
6. Lieu de mise à l'abri dans le logement.
7. Lieu d'évacuation.
8. Point familial de contact.
9. Mairie.
10. Médecin.
11. École.
12. Assurance.

## Règles

- Chaque réponse remplit **le même champ** que le guide « Mon plan familial » (clé `pfms.<formulaire>.<rang>`). On peut commencer dans le parcours et finir dans le guide, ou l'inverse.
- Choix rapides, puis un champ libre pour compléter ou corriger. On peut passer une étape et revenir en arrière.
- L'écran Famille montre l'avancement et une **carte d'urgence** construite à partir des réponses, à partager (message, impression, AirDrop).
- Tout reste sur le téléphone.
- Tests : chaque clé existe dans le guide ; chaque consigne de risque est mot pour mot dans le guide des risques.
