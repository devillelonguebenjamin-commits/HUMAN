# 13. Réseau d'entraide : déclarer ses compétences et ses moyens

Rédigé le 26 novembre 2026, à la demande de Benjamin. Idée : permettre aux habitants volontaires de se signaler comme aidants (médecin, secouriste, hébergement, matériel, réparation...) et de les faire apparaître sur la carte hors ligne. Marqueurs : [FAIT] vérifié ce jour, [A VERIFIER] à confirmer par l'avocat ou la CNIL, [AVIS] jugement de l'auteur. Ce document n'est pas un avis juridique.

## 1. En bref

1. **L'idée est bonne** et colle au guide officiel « Tous responsables » (partie « Tous engagés » : entraide, réserves, voisins). Elle donne aussi aux mairies une vraie raison de recommander l'application.
2. **Mais elle contredit deux promesses actuelles** : « aucune donnée collectée » et « aucun serveur ». Pour que mon voisin voie sur sa carte que je suis infirmière, mes données doivent quitter mon téléphone. SIJAMAIS deviendrait alors responsable d'un fichier de données personnelles, avec localisation, à grande échelle.
3. **Le risque principal n'est pas administratif, il est humain** : publier « médecin, a des médicaments chez lui, telle adresse » expose aux cambriolages, au harcèlement et aux arnaques. Et n'importe qui peut se déclarer médecin.
4. **Ma recommandation** : le faire en deux temps.
   - **Dans l'application, tout de suite** : un « profil d'aidant » qui reste sur le téléphone et qu'on partage soi-même, à qui on veut (famille, voisins, mairie), par QR code. Aucune donnée chez nous.
   - **Avec les communes, ensuite** : un réseau d'entraide **géré par la mairie**, dans le cadre de sa réserve communale de sécurité civile et de son plan communal de sauvegarde. La mairie vérifie, décide de ce qui est visible, et porte la responsabilité du fichier ; SIJAMAIS fournit l'outil.
5. Pour les secouristes face à un arrêt cardiaque, **ne pas réinventer** : SAUV Life et Staying Alive le font déjà avec les SAMU. Les recommander dans l'application.

## 2. Ce qui existe déjà

| Dispositif | Ce qu'il fait | Conséquence pour SIJAMAIS |
|---|---|---|
| SAUV Life | Le SAMU alerte les citoyens volontaires proches d'un arrêt cardiaque, en même temps que les secours ; déployée dans de nombreux SAMU [FAIT] | Lien et recommandation dans le guide « Arrêt cardiaque ». Ne pas faire de « carte des secouristes » concurrente |
| Staying Alive | Carte des défibrillateurs, alerte de citoyens sauveteurs par les secours [FAIT] | Idem |
| Réserve communale de sécurité civile | Bénévoles sous l'autorité du maire, en appui des secours, liée au plan communal de sauvegarde (articles L. 724-1 à L. 724-14 du code de la sécurité intérieure) [FAIT] | Le cadre naturel d'un réseau d'entraide local |
| Registres communaux d'alerte | Fichiers tenus par les communes, encadrés par la CNIL, inscription avec l'accord de la personne [FAIT] | Le modèle juridique à suivre |
| JeVeuxAider.gouv.fr | Bénévolat auprès d'associations et de collectivités [FAIT, guide SGDSN] | Lien dans le guide « Entraide et engagement » |

## 3. Le RGPD appliqué à l'idée

| Question | Réponse | Ce que ça impose |
|---|---|---|
| Est-ce des données personnelles ? | Oui : nom ou pseudonyme, téléphone, courriel, adresse ou position, profession, compétences | Le RGPD s'applique dès que ces données quittent le téléphone de la personne |
| Qui est responsable ? | Celui qui décide du fichier : SIJAMAIS si nous l'hébergeons, la **mairie** si elle l'organise (SIJAMAIS est alors sous-traitant, avec un contrat selon l'article 28) | Le modèle « mairie responsable » est plus simple, plus crédible et colle à la réserve communale [AVIS] |
| Sur quelle base légale ? | Le **consentement** (article 6.1.a) : libre, éclairé, **champ par champ**, retirable à tout moment aussi facilement qu'il a été donné (article 7) | Écran de consentement détaillé, bouton « me retirer » visible |
| Y a-t-il des données sensibles ? | « Médecin », « PSC1 » ou « j'ai une trousse » ne sont pas des données de santé. **Elles le deviennent** si quelqu'un écrit « je suis diabétique, j'ai de l'insuline » ou si l'on ajoute un registre des personnes **ayant besoin** d'aide (article 9) | **Pas de champ de texte libre** : une liste de compétences prédéfinie. Pas de registre des besoins dans l'application : il existe déjà en mairie (registre des personnes vulnérables) |
| Minimisation (article 5) | Ne collecter que le nécessaire | Position approximative (quartier, à 300 m près), jamais l'adresse exacte en public. Contact facultatif, choisi par la personne |
| Analyse d'impact (AIPD, article 35) | La CNIL l'impose notamment pour les **données de localisation à grande échelle**, et dès que deux critères sont réunis (localisation, personnes vulnérables, usage innovant...) [FAIT] | AIPD à faire avant le lancement du réseau communal ; modèle et outil gratuits de la CNIL |
| Information (article 13) | Qui voit quoi, pour quoi, combien de temps | Écran clair : « Votre profil sera visible par... » |
| Durée de conservation | Pas de fichier éternel | Profil à reconfirmer chaque année, supprimé sinon [AVIS] |
| Mineurs | En France, consentement seul à partir de 15 ans pour ce type de service [MEMOIRE, à vérifier] | Réserver l'inscription aux **majeurs** : plus simple et plus prudent |
| Droits des personnes | Accès, rectification, effacement, portabilité | **Difficulté propre au hors ligne** : une carte téléchargée sur des milliers de téléphones garde les données jusqu'à sa prochaine mise à jour. Le dire honnêtement au consentement, et limiter ce qui est copié sur les téléphones |
| Sécurité (article 32) | Chiffrement, hébergement en Union européenne, accès limités | Hébergement de la mairie ou d'un prestataire européen |
| Responsabilité civile | Un aidant déclaré qui cause un dommage, un faux médecin | Conditions d'utilisation, mention « déclaré, non vérifié », vérification par la mairie pour les professions de santé. Le statut de « citoyen sauveteur » (loi de 2020) protège les témoins qui portent secours [A VERIFIER, avocat] |

## 4. Les risques à ne pas sous-estimer

| Risque | Exemple | Parade |
|---|---|---|
| Cambriolage | « Infirmière, médicaments à domicile » avec une position précise | Pas de matériel médical sensible dans la couche publique ; position approximative |
| Harcèlement, démarchage | Téléphone d'un médecin visible par tous | Contact par la mairie, ou numéro visible seulement en situation de crise déclarée |
| Usurpation | Un faux médecin intervient | Badge « vérifié par la mairie » ; sinon mention « déclaré, non vérifié » |
| Fichier détourné | Liste des personnes qui accueillent chez elles | Couche publique limitée aux catégories ; détail visible par la mairie seule |
| Fausse sécurité | « Il y a un médecin à 200 m » au lieu d'appeler le 15 | Rappel systématique : en urgence vitale, le 15 ou le 112 d'abord |
| Données sensibles par erreur | Texte libre « je suis sous dialyse » | Aucun texte libre |

## 5. Le dispositif proposé

### Temps 1 : dans l'application, sans serveur (v1)

- **« Mon profil d'aidant »** dans l'espace Famille : je coche mes compétences et mes moyens, j'ajoute si je veux un contact. Le profil **reste sur mon téléphone**.
- Je le **partage moi-même**, par QR code, à ma famille, mes voisins ou ma mairie. Les profils reçus s'affichent dans ma carte, sur mon téléphone seulement.
- Liens vers SAUV Life, Staying Alive, la réserve communale et JeVeuxAider.
- Pour SIJAMAIS : **aucune donnée collectée**, la promesse est tenue.

### Temps 2 : réseau d'entraide communal (offre aux mairies)

- La mairie ouvre le réseau dans l'application, comme prolongement de sa réserve communale. **Elle est responsable du traitement**, SIJAMAIS est sous-traitant.
- Inscription volontaire, majeurs seulement, consentement champ par champ.
- Trois niveaux de visibilité, choisis par l'habitant :

| Niveau | Visible par | Ce qui est visible |
|---|---|---|
| 1, par défaut | La mairie seulement | Tout le profil : elle mobilise les aidants pendant une crise, comme le prévoit son plan de sauvegarde |
| 2 | Les habitants de la commune, dans la carte hors ligne | Catégorie et quartier (« Secouriste PSC1, quartier de la gare »), sans nom ni adresse ; contact par la mairie |
| 3 | Les habitants, en crise déclarée par la mairie | Le contact choisi par l'aidant, pendant la durée de la crise |

- Vérification par la mairie pour les professions de santé (diplôme, inscription à l'ordre) et le secourisme (attestation PSC1) : badge « vérifié ».
- Profil reconfirmé chaque année, suppression immédiate sur demande, prise en compte dans la carte à la mise à jour suivante.
- AIPD menée avec la mairie avant l'ouverture.

## 6. Catalogue des compétences et des moyens (proposition)

| Famille | Exemples à cocher |
|---|---|
| Santé | Médecin, infirmier, pharmacien, sage-femme, kinésithérapeute, aide-soignant, psychologue, vétérinaire |
| Secourisme | PSC1 ou gestes qui sauvent, PSE1 ou PSE2, sauveteur secouriste du travail, sapeur-pompier volontaire, secouriste d'une association agréée |
| Hébergement | Accueillir des personnes (nombre), accueillir des animaux, lieu chauffé sans électricité |
| Énergie et eau | Groupe électrogène, panneaux solaires, recharge de téléphones, réserve d'eau, filtre à eau, puits |
| Transport | Véhicule tout-terrain, utilitaire, minibus, bateau, tracteur, permis poids lourd |
| Bâtiment et réparation | Électricien, plombier, couvreur, charpentier, maçon, menuisier, bâchage de toiture, mécanique, tronçonneuse, pompe d'épuisement |
| Communication | Radioamateur, talkies-walkies, boîtier LoRa, informatique, réparation de téléphones |
| Langues | Langue des signes, langues étrangères (pour la traduction) |
| Aide aux personnes | Garde d'enfants, visite aux personnes isolées, courses, accompagnement |
| Logistique | Cuisine collective, distribution, stockage, porte-à-porte |

À exclure : armes, chasse et défense (charte), et tout ce qui décrit une maladie ou un traitement.

## 7. Décisions à prendre

| N° | Question | Recommandation |
|---|---|---|
| E1 | Faire le profil d'aidant local, partagé par QR code, dès la v1 ? | Oui : utile, sans risque RGPD pour nous |
| E2 | Faire du réseau d'entraide communal une offre aux mairies, la mairie étant responsable du fichier ? | Oui, à présenter à La Baule comme piste |
| E3 | Renoncer à une carte publique nationale des aidants gérée par SIJAMAIS ? | Oui : risques élevés, coût juridique, contradiction avec la promesse « aucune donnée » |
| E4 | Recommander SAUV Life et Staying Alive pour les secouristes ? | Oui |
| E5 | Faire valider le schéma par l'avocat (déjà prévu) et, plus tard, par le délégué à la protection des données de la commune pilote ? | Oui |

## Sources

| Source | Apport |
|---|---|
| CNIL, « Les registres communaux d'alerte et de protection des populations en cas de crise exceptionnelle ». https://www.cnil.fr/fr/les-registres-communaux-dalerte-et-de-protection-des-populations-en-cas-de-crise-exceptionnelle | Cadre des fichiers communaux, accord de la personne |
| CNIL, liste des traitements pour lesquels une AIPD est requise. https://www.cnil.fr/sites/default/files/atoms/files/liste-traitements-avec-aipd-requise-v2.pdf | Localisation à grande échelle |
| CNIL, « Ce qu'il faut savoir sur l'AIPD ». https://cnil.fr/fr/ce-quil-faut-savoir-sur-lanalyse-dimpact-relative-la-protection-des-donnees-aipd | Critères, deux critères sur neuf |
| DGSCGC, plaquette sur la réserve communale de sécurité civile. https://www.isere.gouv.fr/contenu/telechargement/65706/430844/file/plaquette_RCSC.pdf | Cadre légal, lien avec le plan communal de sauvegarde |
| SAUV Life, dossier de presse (CHU d'Amiens, 2021). https://www.chu-amiens.fr/wp-content/uploads/2021/10/sauv-life-dossier-presse-22-10-2021.pdf | Citoyens sauveteurs alertés par le SAMU |
| Staying Alive, App Store. https://apps.apple.com/FR/app/id403117516 | Carte des défibrillateurs, alerte des citoyens sauveteurs |
| SGDSN, guide « Tous responsables », partie « Tous engagés » (2025) | Entraide, réserves, bénévolat |
