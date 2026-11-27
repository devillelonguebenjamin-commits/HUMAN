# Arbitrages après les cycles 1 à 6 de l'assistant

Rédigé le 27/11/2026 par Claude Code, à partir du point final du Claude évaluateur (fin du cycle 6). **Validé par Benjamin le 27/11/2026 : « OK sur tout ».** La section « Mise en œuvre » en fin de document dit ce qui a été fait.

## Bloc 1 : contenus des guides (version 1.2)

| N° | Question | Évaluateur | Ma position | État |
|---|---|---|---|---|
| 1 | Guides AVC, convulsions, hypothermie, étouffement du nourrisson | Rédiger AVC et nourrisson en 1.2, marqués « à relire » | D'accord pour des brouillons marqués « à relire », **affichés dans l'onglet Savoir seulement après relecture PSC1** ; d'ici là l'assistant renvoie au 15 avec les boutons d'appel | Rien de publié |
| 2 | Réchaud et poêle à pétrole : guide Stocks contre guide Monoxyde | Durcir Stocks (interdiction en intérieur) | **D'accord** : zéro ambiguïté en situation de stress | Côté assistant : seule l'interdiction du guide Monoxyde est affichée. Texte de Stocks à modifier après ton accord |
| 3 | Guide Cueillette (3 plantes, confusion massette et iris jaune) | Guide de prudence pure pour la version mairie | **D'accord** : c'est le seul guide qui invite à manger quelque chose de non vérifié | Côté assistant : aucune identification de plante ou de champignon, mise en garde toujours affichée, guide jamais reformulé |
| 4 | Eau de Javel (fiche ARS Guadeloupe 2017, dilution en deux temps) | Garder seulement ébullition et pastilles | **D'accord** : risque réel de confusion avec le berlingot à 9,6 % | Côté assistant : guide Eau jamais reformulé. Texte à modifier après ton accord |
| 5 | Sources de la rubrique Survie, guides Retour (2010) et Assurance | Retour et Assurance dès la 1.2 | D'accord ; c'est du travail de recherche documentaire que je peux faire si le réseau donne accès à service-public.gouv.fr (bloqué aujourd'hui depuis mon environnement) | À faire |
| 6 | Numéro vert du signal d'alerte (0 800 50 73 05), non vérifié | Ne pas le montrer | **D'accord** | En attente de ton accord (le numéro est encore affiché) |

## Bloc 2 : moteur et règles de l'assistant

| N° | Question | Évaluateur | Ma position | État |
|---|---|---|---|---|
| 7 | Découper le guide « risques » | 13 sous-entrées | Fait autrement : chaque risque est repéré et seule sa section s'affiche ; le fichier des guides n'a pas changé | **Fait (cycle 2)** |
| 8 | Étendre le « sans reformulation » | Oui pour les consignes irréversibles | D'accord | **Fait** : santé, risques, eau, cueillette, retour, assurance, cyberattaque (particuliers et commune), monoxyde |
| 9 | Détresse suicidaire | Détection prioritaire, 3114, 15, 112, 114 | D'accord, c'est la règle la plus importante des 6 cycles | **Fait**, avec bouton « Appeler le 3114 ». Une formule (« je veux plus vivre ») a d'abord été manquée : liste élargie et testée |
| 10 | Questions en langue étrangère | Bandeau bilingue | D'accord | **Fait (cycle 1)** : ligne « Emergency: call 112 » |

## Bloc 3 : interface et Espace mairie

| N° | Question | Évaluateur | Ma position | État |
|---|---|---|---|---|
| 11 | Boutons de clarification et liens vers les outils (calculateur d'eau, formulaires) | Oui | D'accord | Boutons de clarification **faits**. Liens vers les outils : à faire (petit chantier d'interface) |
| 12 | Cloisonner les 5 guides de l'Espace mairie | Interrupteur « Mode mairie » | Les deux : guides mairie **exclus par défaut** de la recherche des particuliers, activés par des mots d'élu ou d'agent (maire, PCC, nos agents...) ; un interrupteur dans les réglages viendra avec l'espace commune | Détection automatique **faite** ; interrupteur à faire |
| 13 | Numéros Enedis et GRDF, fiches locales (CSIRT, préfecture, salle de crise) | Les ajouter | D'accord, **après vérification des numéros** sur les sites officiels ; les fiches locales vont avec l'espace commune | À faire |

## Mise en œuvre (27/11/2026)

| N° | Fait |
|---|---|
| 1 | Brouillons AVC, étouffement du nourrisson, hypothermie dans `contenus/guides/brouillons/secours_a_relire.json`, **hors application** ; convulsions : aucune proposition, à rédiger avec le formateur |
| 2 | Guide Stocks 1.2 : « Jamais de réchaud, de barbecue, de groupe électrogène, de poêle à pétrole ni de chauffage d'appoint à combustion dans un local fermé » ; réchaud « à utiliser dehors uniquement » |
| 3 | Guide « Cueillette : prudence » ; fiches plantain, ortie, massette mises de côté dans `contenus/guides/retires_v1.2.json` ; l'assistant refuse toute identification |
| 4 | Guide Eau sans eau de Javel (mise en garde expliquant pourquoi) ; schéma de l'eau corrigé (« pastille, selon notice » au lieu de « attendre 30 min ») |
| 5 | Guide Assurance actualisé sur service-public.gouv.fr (page vérifiée le 10/04/2026) : délais de versement (provision sous 2 mois, indemnisation sous 3 mois), franchise de 380 €, hébergement temporaire. Garantie tempête : pas de page officielle trouvée, non ajoutée. Guide Retour : pas de source récente trouvée, inchangé |
| 6 | Numéro vert 0 800 50 73 05 retiré (introuvable sur les pages officielles). **196 confirmé** (service-public.gouv.fr, page vérifiée le 25/08/2026) ; **0 800 112 112** ajouté (numéro de rappel des secours, même page) |
| 7 à 10 | Déjà faits avant l'arbitrage |
| 11 | Le lien sous chaque réponse mène à l'outil du guide : « Calculer : ... », « Remplir dans ... », « Cocher ma liste dans ... » |
| 12 | Interrupteur « Espace mairie » dans les réglages, en plus de la détection automatique |
| 13 | Numéros GRDF et Enedis **non vérifiés** (GRDF refuse l'accès automatique, le numéro d'Enedis est chargé par script) : non ajoutés, à vérifier à la main. Fiches locales : avec l'espace commune |

L'environnement cloud « HUMAN » autorise désormais grdf.fr, enedis.fr, service-public.gouv.fr, gouvernement.fr, info.gouv.fr, interieur.gouv.fr et mer.gouv.fr (validé dans l'invite d'autorisation).
