# Revue des guides SIJAMAIS, version 1.0

Revue du 25 novembre 2026 de `guides_v1.0.json` (35 guides, 5 catégories, 14 sources), fourni par Benjamin. Marqueurs : [FAIT] vérifié ce jour, [A VERIFIER] à confirmer sur la source officielle, [AVIS] jugement de l'auteur de la revue.

## 1. Verdict

**Une très bonne base, à corriger avant toute diffusion.** La partie « Urgence » reprend fidèlement le guide « Tous responsables » (SGDSN, 2025) : les 7 réflexes, le signal d'alerte, les numéros (dont le 196), les consignes par risque, les 4 temps face à une attaque. Le plan familial de mise en sûreté avec ses formulaires est la meilleure idée du lot : c'est exactement ce qu'une mairie veut voir dans les mains de ses habitants. Le format JSON par blocs typés (étapes, listes à cocher, formulaires, calcul d'eau) se transpose directement en écrans SwiftUI.

Trois réserves :

1. **Une dizaine d'erreurs ou d'informations datées**, dont certaines peuvent nuire (section 2).
2. **La moitié des sources sont des documents privés**, protégés par le droit d'auteur (section 3).
3. **Les gestes de premiers secours manquent** : les guides décrivent le matériel des trousses, pas les gestes (section 4).

## 2. Corrections à faire avant diffusion

| Guide | Ce qui est écrit | Problème | Correction proposée |
|---|---|---|---|
| assurance | 10 jours pour déclarer après l'arrêté, versement sous 3 mois | **Daté (source de 2010).** Depuis le 1er janvier 2023, le délai est de **30 jours** après la publication de l'arrêté au Journal officiel [FAIT, service-public.gouv.fr] | « 30 jours après la publication de l'arrêté ». Délais de versement à reprendre de la fiche service-public F3078 [A VERIFIER] |
| risques, accident nucléaire | « Retirez vos comprimés d'iode (gratuits) en pharmacie » | Faux pour la plupart des Français : la distribution concerne les habitants des zones des plans particuliers d'intervention (jusqu'à 20 km d'une centrale), parfois sur bon de retrait [FAIT, Ordre des pharmaciens] | « Si vous habitez à moins de 20 km d'une centrale, retirez vos comprimés en pharmacie (renseignez-vous en mairie). Ne les prenez que sur instruction du préfet. » |
| incendie-domicile | Détecteur « devant la cuisine » | Contraire à la consigne officielle : le détecteur se place dans le couloir qui dessert les chambres, **loin de la cuisine** et de la salle de bain. Un détecteur est obligatoire par logement [FAIT, service-public.gouv.fr] | « Un détecteur obligatoire, dans le couloir des chambres ; un par étage conseillé ; jamais dans la cuisine. » Ajouter la conduite à tenir en cas d'incendie (fermer la porte, appeler le 18, ne pas prendre l'ascenseur, rester chez soi si l'escalier est enfumé) [A VERIFIER] |
| cueillette | Tussilage : à manger, « contre la toux » | Le tussilage contient des alcaloïdes pyrrolizidiniques, toxiques pour le foie ; les autorités sanitaires recommandent d'éviter ces substances [FAIT, OSAV, EFSA] | **Retirer le tussilage.** Retirer aussi toutes les lignes « Soigner » : une promesse de soin par une plante est une allégation de santé |
| cueillette | Massette : jeunes pousses crues | Risque de confusion avec l'iris jaune, toxique, au stade jeune pousse [AVIS, à faire valider] | Ajouter la mise en garde ou retirer la massette |
| orientation | « Le soleil passe au sud à midi » ; méthode de la montre avec « midi » | **Faux en France** : à cause de l'heure légale, le soleil passe au sud vers 13 h en hiver et vers 14 h en été | « Vers 13 h en hiver, 14 h en été. » Méthode de la montre : prendre le repère de 13 h (hiver) ou 14 h (été) |
| orientation | « Comme la lune » ; branches plus horizontales côté sud | La lune ne suit pas l'horaire du soleil ; l'indice des branches n'est pas fiable | Retirer les deux |
| priorites | Règle des 3 : « 3 mois sans hygiène » | Ne figure pas dans la règle habituelle, qui commence par « 3 minutes sans respirer » | « 3 minutes sans respirer, 3 heures sans abri par grand froid, 3 jours sans boire, 3 semaines sans manger. » |
| alerte | « France Bleu » | Ces radios s'appellent **ici** depuis le 6 janvier 2025 [FAIT] | « ici (ex-France Bleu), France Info, France Inter » |
| alerte | Corne de brume testée les premiers mercredis de mars, juin, septembre et décembre à 12 h 15 | Source de 2010 | [A VERIFIER] auprès de la préfecture ou du DDRM |
| numeros | 0 800 50 73 05 pour reconnaître le signal | Numéro non vérifié | [A VERIFIER] avant publication |
| eau | Javel : les sources ne concordent pas | L'alerte est honnête, mais le dosage dépend de la concentration et d'une éventuelle dilution préalable. L'ARS Guadeloupe recommande une solution mère (250 ml de javel à 2,6 % dans 1 L d'eau), puis 6 gouttes par litre et 30 minutes d'attente [FAIT] | Retenir une seule méthode officielle française, citée avec sa source, ou renvoyer à la notice des pastilles |
| nourriture | Escargots, vers de terre | Parasites | Ajouter « toujours cuits » pour les invertébrés |
| feu | « Respectez les interdictions locales » | En France, allumer un feu dans ou près d'une forêt est en général interdit [A VERIFIER, code forestier] | Préciser : « seulement en situation de survie réelle, jamais en forêt en période sèche » |
| stocks | Stock de 2 adultes pour 3 à 6 mois : 270 L d'eau, 10 kg de sel, 5 kg de miel | Chiffres incohérents : 2 adultes à 3 L par jour pendant 90 jours, c'est 540 L. Supermarché « vidé en 36 heures » : non sourcé et anxiogène | Retirer l'exemple chiffré ou le refaire. Ancrer sur le kit officiel de 72 heures, avec un palier facultatif de deux semaines |
| vehicule | Contrôles « chaque semaine » | Excessif pour un particulier | « Chaque mois, et avant un départ » |
| edc | « Outil multifonction ou couteau » à porter sur soi | Le port d'un couteau sans motif légitime est encadré par la loi [A VERIFIER, avocat]. Pour une application relayée par des mairies, c'est sensible | « Petit outil multifonction (la loi encadre le port d'un couteau) » |
| trousses | IFAK et trauma kit : canule de Guedel, pansements thoraciques, adrénaline auto-injectable, antibiotiques, « antalgiques de plusieurs niveaux » | Matériel médical ou tactique, réservé à des personnes formées ou délivré sur ordonnance. Le terme IFAK est militaire, ce qui va contre la charte | **Garder la trousse familiale** (gratuite). Retirer l'IFAK et le trauma kit, ou les réserver à une fiche « pour personnes formées » validée par une association de secourisme |
| attaque terroriste | « S'échapper, se cacher, alerter, résister » | **Correct**, conforme au guide officiel | À garder. Cela corrige ma proposition n° 14 de la maquette (« rien sur fuir ou se cacher ») : le guide officiel le dit, nous le disons |

## 3. Droits sur les sources

| Sources | Nature | Ce qu'on peut faire |
|---|---|---|
| S2 (SGDSN), S3 (PIMS, DGSCGC), S4 (PFMS, 2010), S13 (DRSD), S14 (ANSSI) | Publications de l'État | Réutilisables en citant la source et la date (article L321-1 du CRPA) [FAIT, voir `10_veille_officielle.md`]. S4 date de 2010 : vérifier chaque consigne sur une version récente |
| S1 (affiche du kit 72 h) | Texte public, **illustration protégée** (© Antoine Dagan, CitizenPress) | Le texte, oui. **L'illustration, jamais** |
| S5 à S8 (checklists EDC, IFAK, évacuation, trauma kit) | Créations d'auteurs privés (Canva, blog) | Les idées et les faits ne sont pas protégés, la mise en forme et la sélection peuvent l'être. Réécrire avec nos mots et notre ordre, sans copier |
| S9 (La Libellule, Genève), S10 (APARS56), S11 (Atelier ILYS), S12 (Résilience urbaine) | Documents d'associations et d'auteurs privés | Même règle. Mieux : leur écrire pour demander l'autorisation ou proposer un partenariat avec citation. Vérifier la licence de chacun (certains manuels sont peut-être sous licence Creative Commons) |

Deux règles pour l'application :

- **distinguer visuellement** « Consigne officielle » (sources de l'État) et « Conseil pratique » (autres sources) : c'est ce qui rendra l'application recommandable par une préfecture ;
- tout ce qui touche à la santé passe par la relecture d'un professionnel avant publication (règle déjà inscrite dans la spécification).

## 4. Ce qui manque

| Sujet | Pourquoi | Source |
|---|---|---|
| **Gestes de premiers secours** : arrêt cardiaque et défibrillateur, saignement abondant et garrot, personne inconsciente qui respire, étouffement, brûlure | Le cœur du gratuit, et le premier réflexe des gens. Le guide officiel renvoie à la formation, l'application doit au moins rappeler les gestes | Recommandations PSC1 et « gestes qui sauvent » (ministère de l'Intérieur, décembre 2023). Les fiches de démonstration du prototype existent déjà |
| Monoxyde de carbone | Premier danger réel d'une coupure de courant (groupe électrogène, chauffage d'appoint) | Santé publique France [A VERIFIER] |
| Canicule et grand froid | Risques les plus fréquents en France, registre des personnes vulnérables tenu par les mairies | Santé publique France, ministère de la Santé |
| Coupure d'électricité prolongée | Scénario le plus probable, avec le dispositif EcoWatt | RTE, guide SGDSN |
| Personnes vulnérables, handicap | Les mairies tiennent un registre ; l'application peut inviter à s'y inscrire | Code de l'action sociale [A VERIFIER] |
| Soutien psychologique | Le 3114 (prévention du suicide) et les cellules d'urgence médico-psychologique | Ministère de la Santé |

## 5. Espace mairie

Le contenu est utile, mais il vient d'un guide écrit pour les entreprises (DRSD). Une mairie parle le langage du **plan communal de sauvegarde** : poste de commandement communal, maire directeur des opérations de secours, réserve communale de sécurité civile. Il faut reprendre ce vocabulaire, sinon le contenu sonnera « consultant » aux oreilles d'un élu. Retirer aussi la phrase « Le pire est toujours possible ».

## 6. Format JSON : ajouts proposés pour la version 1.1

| Champ | Rôle |
|---|---|
| `niveau` : `officiel` ou `pratique` | Badge à l'écran (section 3) |
| `sensible` : vrai ou faux | Les sujets de santé déclenchent le rappel du 15 et du 112 et ne passent jamais par l'assistant |
| `maj` et `relecture` (nom, qualité, date) | Exigé par la veille (`10_veille_officielle.md`, section 7) |
| Sources détaillées : titre, date, adresse, licence | Traçabilité devant une préfecture |
| `version` par guide | Journal public des mises à jour |

## 7. Gratuit ou premium

Tout le contenu de ces guides est gratuit, conformément à la règle « tout ce qui protège est gratuit ». La catégorie « Survie et autonomie » (eau, feu, abri, orientation) recoupe les loisirs : je propose de la laisser gratuite. Le premium reste porté par les cartes de France et topographiques, les itinéraires, les modes randonnée, mer, voyage et camping, et l'encyclopédie.

## 8. Note sur la page HTML

La page charge ses polices depuis Google Fonts : elle ne s'affiche pas correctement hors ligne. L'application embarquera ses polices. Le couple Space Grotesk et Inter est aussi celui qu'on retrouve dans beaucoup de pages générées par IA, ce que tu voulais éviter.

## Sources de la revue

| Source | Apport |
|---|---|
| Service-public, « Catastrophe naturelle ou technologique : indemnisation par l'assurance ». https://www.service-public.gouv.fr/particuliers/vosdroits/F3078 | Délai de 30 jours depuis le 01/01/2023 |
| Service-public, « Détecteur de fumée ». https://www.service-public.gouv.fr/particuliers/vosdroits/F19950 | Emplacement, loin de la cuisine |
| Ordre des pharmaciens, campagnes de distribution d'iode. https://www.ordre.pharmacien.fr/les-communications/focus-sur/les-actualites/campagne-de-distribution-de-comprimes-d-iode-stable-dans-les-officines-situees-dans-un-rayon-de-10-a-20-km-des-centrales-nucleaires-de-production-d | Distribution réservée aux zones des plans particuliers d'intervention |
| OSAV (Suisse), alcaloïdes pyrrolizidiniques. https://www.blv.admin.ch/fr/alcaloides-pyrrolizidiniques | Toxicité, consommation à éviter |
| EFSA, alcaloïdes pyrrolizidiniques. https://www.efsa.europa.eu/es/node/969838 | Préoccupation à long terme |
| ARS Guadeloupe, désinfection de l'eau hors réseau. https://www.guadeloupe.ars.sante.fr/system/files/2017-09/proc%C3%A9dure%20d%C3%A9sinfection%20eau%20hors%20reseau.pdf | Dosage de la javel |
| CB News, « France Bleu deviendra ICI le 6 janvier 2025 ». https://www.cbnews.fr/cb/image-france-bleu-deviendra-6-janvier-2025-88910 | Nouveau nom des radios locales |
