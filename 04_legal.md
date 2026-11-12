# 04. Cadre légal et réglementaire (France et Union européenne)

Document de la phase 1 du projet HUMAN, rédigé le 12 novembre 2026. Les identifiants S renvoient à `sources.md`. Marqueurs : [FAIT], [EST], [HYP].

Avertissement : je ne suis pas avocat et ce document n'est pas un avis juridique. Les points marqués [FAIT] sont sourcés. Les références d'articles de code sont données de mémoire, sans revérification en ligne pendant cette session, et sont marquées [A CONFIRMER]. La section 10 liste ce qu'un professionnel doit valider, avec les coûts.

## 1. Conclusion

1. Le statut juridique que nous choisissons vis-à-vis du téléphone détermine tout. Fabricant ou importateur : obligations lourdes, hors de portée du budget. Distributeur d'un téléphone déjà mis sur le marché européen par sa marque : obligations gérables. Editeur de logiciel et vendeur de cartes mémoire : obligations légères.
2. Le point le plus sensible n'est pas la radio. C'est la santé. Une IA qui répond à "que faire pour cette blessure" peut être qualifiée de dispositif médical si nous revendiquons une aide au diagnostic ou au traitement [S60]. Le positionnement doit rester celui de l'information générale et de l'éducation.
3. A partir du 9 décembre 2026, la responsabilité sans faute du fait des produits défectueux s'étend aux logiciels et à l'IA [FAIT, S61]. Une clause de non-responsabilité ne protège pas contre un consommateur. La parade est la qualité vérifiable du contenu et une assurance.
4. La publicité sur Meta interdit d'exploiter une crise pour vendre [FAIT, S62]. Le positionnement "efficacité, jamais la peur" n'est pas seulement un choix de marque : c'est une condition d'accès aux canaux.
5. Forme recommandée : aucune structure pendant les 30 jours de test (pas d'encaissement), puis une SASU dès la décision de lancer.

## 2. Les quatre statuts possibles

| Statut | Situation | Obligations principales | Coût de mise en conformité | Verdict |
|---|---|---|---|---|
| A. Editeur de logiciel et vendeur de supports | Application, téléchargement, carte mémoire préchargée | Droit de la consommation, garantie légale sur le contenu numérique, responsabilité produit, licences des contenus, filière de recyclage si la carte est vendue sous notre marque | Faible : 1 500 à 3 000 € de conseil | Retenu comme coeur |
| B. Distributeur | Revente d'un téléphone de marque existante, acheté à un opérateur établi dans l'Union, non modifié | Vérifier marquage CE, notice en français, étiquette énergie, affichage du DAS, garantie légale de 2 ans due par le vendeur, information précontractuelle | Faible à moyen | Retenu pour le téléphone |
| C. Importateur | Achat direct en Chine d'un téléphone de marque existante | Tout B, plus : responsabilité de la conformité (écoconception, radio, cybersécurité), nom et adresse sur le produit, conservation des déclarations 10 ans, redevance pour copie privée, filières de recyclage (équipements, piles, emballages), exposition directe aux contrôles de l'ANFR | Moyen : environ 6 000 € de coûts fixes [EST] et 16 € par appareil | Possible en année 2, pas avant |
| D. Fabricant | Téléphone sous notre marque, ou téléphone dont nous modifions le système | Tout C, plus : dossier technique, essais radio, DAS, sécurité électrique, cybersécurité (EN 18031), 5 ans de mises à jour, 7 ans de pièces détachées, étiquette énergie et enregistrement européen, certification Google | Elevé : plusieurs dizaines de milliers d'euros [EST], et une charge permanente | Exclu |

Le piège : apposer notre marque sur le téléphone, ou modifier son système, nous fait basculer de B à D [FAIT, S55]. Conséquences pratiques pour le statut B :

- le téléphone garde sa marque et son emballage d'origine ;
- nous ne modifions jamais le système (pas d'image personnalisée, pas de déverrouillage) ;
- la forme la plus sûre est le lot : téléphone scellé, carte mémoire et guide. Le client insère la carte et lance l'installation. Nous ne touchons pas à l'appareil ;
- la préinstallation de l'application par nos soins avant expédition est probablement admissible (c'est un service de configuration, comme en font les revendeurs professionnels), mais ce point doit être confirmé par l'avocat (question 1 de la section 10).

## 3. Mise sur le marché d'un téléphone : ce qu'il faut savoir même comme distributeur

| Règle | Contenu | Qui la porte | Source |
|---|---|---|---|
| Directive sur les équipements radioélectriques (2014/53/UE) | Marquage CE, sécurité, compatibilité, usage du spectre | Fabricant. Le distributeur vérifie le marquage et les documents | S57 |
| Cybersécurité des équipements radio connectés | Applicable depuis le 01/08/2025, normes EN 18031. Remplacée par le règlement sur la cyberrésilience le 11/12/2027 | Fabricant | S55 |
| Débit d'absorption spécifique (DAS) | Limites tête, tronc, membres (4 W/kg). Affichage obligatoire sur le lieu de vente et dans la publicité [A CONFIRMER pour le détail] | Fabricant pour la conformité, vendeur pour l'affichage | S57, S58 |
| Ecoconception des smartphones, règlement (UE) 2023/1670 | Depuis le 20/06/2025 : résistance, batterie, 5 ans de mises à jour du système, 7 ans de pièces détachées | Fabricant et importateur | S54 |
| Etiquette énergie, règlement (UE) 2023/1669 | Etiquette et fiche produit à afficher, y compris en vente à distance | Fabricant pour la fourniture, vendeur pour l'affichage | S54 |
| Chargeur universel | Port USB-C obligatoire depuis le 28/12/2024 | Fabricant | S57 |
| Batteries, règlement (UE) 2023/1542 | Batteries remplaçables par l'utilisateur le 18/02/2027. Pour les smartphones, les règles d'écoconception priment | Fabricant | S59 |
| Redevance pour copie privée | 14 € HT par smartphone de plus de 64 Go. Hausse demandée en 2026 (21,60 à 28,80 € TTC), non confirmée | Importateur ou fabricant. Déjà payée si l'on achète à un grossiste établi en France, à vérifier s'il est établi ailleurs dans l'Union | S56 |
| Filières de recyclage (équipements électriques, piles, emballages) | Adhésion à un éco-organisme, identifiant unique à faire figurer dans les conditions de vente | Le premier metteur sur le marché français. Concerne aussi nos cartes mémoire et nos emballages | S57 |

Le risque n'est pas théorique. En février 2025, l'ANFR a ordonné le retrait du marché de l'Ulefone Note 16 Pro et de l'Oukitel WP28 pour dépassement du DAS. Ulefone a corrigé par une mise à jour et l'interdiction a été levée. Oukitel n'a pas corrigé [FAIT, S58]. Enseignements :

1. choisir une marque qui corrige (Ulefone l'a fait) et qui publie ses fiches dans la base européenne des étiquettes énergie ;
2. en statut B, un retrait nous coûte un stock et des retours. En statut C, il nous coûte aussi la responsabilité du rappel ;
3. ne jamais détenir plus de six semaines de stock d'un même modèle.

## 4. Radio : ce qui est permis

| Usage | Régime en France | Décision produit |
|---|---|---|
| Réception FM, DAB+, ondes courtes | Libre | Oui. Privilégier une radio à manivelle en accessoire |
| Ecoute de communications privées, des forces de l'ordre | Interdite (atteinte au secret des correspondances, code pénal) [A CONFIRMER pour l'article] | Aucun contenu ni réglage facilitant cette écoute |
| PMR446 (446 MHz, 500 mW, antenne fixe) | Libre, sans licence [S67] | Accessoire possible : talkies-walkies du commerce conformes |
| LoRa 868 MHz (Meshtastic) | Libre sous conditions de puissance et de temps d'émission | Accessoire possible : noeuds conformes vendus en Europe [S40] |
| CB 27 MHz | Libre | Hors sujet |
| Emetteurs UHF et VHF de forte puissance intégrés à certains téléphones durcis | Licence requise hors PMR446. Statut d'homologation français de ces téléphones non établi [S67] | Exclure ces modèles du catalogue |
| Radioamateur | Certificat d'opérateur obligatoire | Information seulement |
| Téléphonie par satellite | Libre avec abonnement | Hors périmètre |

Règle simple pour les contenus : nous expliquons ce qui est autorisé et à quelles conditions. Nous ne publions pas de tutoriel pour débrider un émetteur.

## 5. Responsabilité sur les conseils de survie et de santé

### 5.1 Trois risques distincts

| Risque | Mécanisme | Parade |
|---|---|---|
| Qualification en dispositif médical | Un logiciel dont la finalité revendiquée est d'aider au diagnostic ou au traitement est un dispositif médical, soumis à certification. La qualification dépend de ce que nous revendiquons [S60] | Ne jamais revendiquer diagnostic, traitement ou triage. Finalité écrite : information générale et formation. Pas de fonction "décrivez vos symptômes". L'assistant ne génère rien sur la santé (niveau 3 de `03_produit_technique.md`) |
| Responsabilité du fait des produits | Directive (UE) 2024/2853 : logiciel et IA sont des produits, responsabilité sans faute, applicable aux produits mis sur le marché après le 09/12/2026. Transposition française pas encore publiée à l'été 2026 [S61] | Fiches relues et signées par des professionnels, journal des versions, jeu de tests rejoué à chaque mise à jour, assurance responsabilité civile produits |
| Pratique commerciale trompeuse | Promettre une autonomie, une fiabilité ou une "survie" non démontrées | Toute promesse chiffrée appuyée sur un protocole de test publié |

### 5.2 Mentions et conception

- Dans l'application et sur l'emballage : "Information générale à visée éducative. Ne remplace ni les secours ni un professionnel de santé. En cas d'urgence, appelez le 15 ou le 112 dès que c'est possible."
- Chaque fiche santé porte sa date, sa source et le nom du relecteur.
- L'assistant affiche toujours qu'il est une IA, cite ses sources et dit quand il ne sait pas. Les obligations de transparence du règlement européen sur l'IA vont dans ce sens ; leur calendrier exact a été modifié en 2026 et doit être confirmé [A CONFIRMER].
- Les conditions générales peuvent limiter notre responsabilité envers un professionnel. Elles ne peuvent pas l'exclure envers un consommateur pour un produit défectueux.

## 6. Droit de la consommation et vente à distance

| Sujet | Règle | Application |
|---|---|---|
| Information précontractuelle | Caractéristiques, prix TTC, délai de livraison, identité du vendeur, garanties | Fiches produit complètes, mentions légales, conditions générales |
| Délai de livraison | A indiquer. A défaut, 30 jours [FAIT, S63] | En précommande : annoncer une date ferme et rembourser si elle n'est pas tenue |
| Rétractation | 14 jours, remboursement sous 14 jours [FAIT, S63] | Téléphones : retour possible, appareil ouvert difficile à revendre (provision de 6 % au modèle) |
| Exceptions à la rétractation | Contenu numérique fourni sans support après accord exprès du client. Logiciel sur support descellé par le client [A CONFIRMER, code de la consommation] | Pack numérique : case à cocher de renonciation. Pack carte : vendu sous scellé |
| Garantie légale de conformité | 2 ans, due par le vendeur. Pour un contenu numérique, obligation de fournir les mises à jour nécessaires [A CONFIRMER] | Téléphone : nous sommes le premier interlocuteur du client, puis recours contre le fournisseur. Application : mises à jour à assurer pendant 2 ans au moins |
| Précommandes | Vente ferme avec paiement anticipé : mêmes droits pour le client. Le financement participatif obéit aux règles de la plateforme | Limiter le délai annoncé à 6 semaines. Séparer la trésorerie des précommandes |
| Avis clients, promotions | Encadrés (avis vérifiés, prix de référence) | Pas de faux avis, pas de fausse urgence |

## 7. Données personnelles

Le produit lui-même est favorable : il fonctionne hors ligne et ne collecte rien. C'est un argument commercial à écrire noir sur blanc. Les obligations portent sur le site et le marketing :

- liste d'attente et lettre d'information : consentement explicite, finalité indiquée, désinscription en un clic, registre des traitements simplifié ;
- traceurs publicitaires (Meta, TikTok) : bandeau de consentement conforme aux lignes directrices de la CNIL. Privilégier une mesure d'audience sans traceur pendant le test ;
- sous-traitants (boutique en ligne, emailing, paiement) : hébergement dans l'Union de préférence, contrats de sous-traitance standards ;
- aucune remontée de données d'usage depuis l'application sans consentement. Recommandation : aucune remontée du tout en v1.

## 8. Publicité, plateformes et paiement

| Sujet | Contrainte | Conséquence |
|---|---|---|
| Meta (Facebook, Instagram) | Interdiction d'exploiter une crise ou un événement controversé à des fins commerciales, y compris en vendant des produits liés à la crise [FAIT, S62]. Interdiction de viser des attributs personnels sensibles | Aucune référence à une guerre, une panne ou une catastrophe en cours dans les annonces. Angle : randonnée, autonomie, éducation, test produit |
| Toutes plateformes | Refus possibles sans explication, réexamen à tout moment | Ne pas dépendre d'un seul canal. Constituer une liste d'adresses électroniques dès le premier jour |
| Publicité pour un téléphone | Mention du DAS dans la publicité [A CONFIRMER] | Gabarit d'annonce avec la mention |
| Allégations | Pas d'allégation de santé, pas de promesse de sécurité absolue. Recommandations de l'autorité de régulation professionnelle de la publicité | Charte éditoriale (voir `06_acquisition_marque.md`) |
| Prestataires de paiement | Activités restreintes : armes, certains couteaux. Les précommandes à long délai peuvent entraîner une retenue de fonds | Catalogue sans arme ni couteau. Délais de précommande courts. Prévenir le prestataire avant une campagne |
| Places de marché (Amazon) | Exigences documentaires de conformité pour l'électronique | Pas avant l'année 2 |

## 9. Structure juridique

| Option | Avantages | Inconvénients | Avis |
|---|---|---|---|
| Aucune structure pendant le test | Zéro coût, zéro formalité | Interdit d'encaisser | Jours 1 à 30 : liste d'attente sans paiement |
| Micro-entreprise | Création en un jour, comptabilité minimale. Plafond de 203 100 € pour la vente de marchandises, franchise de TVA jusqu'à 85 000 € [FAIT, S64] | Cotisations calculées sur le chiffre d'affaires et non sur la marge : intenable pour de la revente à 20 % de marge. Pas de récupération de TVA sur les achats en franchise. Pas d'associé possible. Crédibilité faible face aux fournisseurs et aux banques | Déconseillée, sauf pour vendre uniquement le pack numérique |
| SASU, puis SAS | Responsabilité limitée aux apports. Charges réelles déductibles, TVA récupérable. Entrée d'associés et d'investisseurs simple. Président sans cotisations tant qu'il n'est pas rémunéré | 600 à 1 000 € de création, 1 500 à 2 500 € par an de comptabilité [EST] | Recommandée dès la décision de lancer |
| EURL | Responsabilité limitée, cotisations plus faibles sur la rémunération | Moins souple pour une levée de fonds | Possible si aucun investisseur n'est envisagé |

Deux points à examiner avec un expert-comptable avant de créer la société :

1. si Benjamin a des droits au chômage, le maintien des allocations ou leur versement partiel en capital change complètement le plan de financement (question ouverte n° 2) ;
2. un capital de 5 000 à 10 000 € et le reste en compte courant d'associé préservent la souplesse. Un prêt d'honneur est accordé à la personne, qui l'apporte ensuite à la société [FAIT, S65].

Pour lever plus tard : la SAS permet l'entrée d'investisseurs et les bons de souscription pour d'éventuels associés. Rien à prévoir de particulier dans les statuts de départ, hormis des statuts types propres.

## 10. Points à faire valider par un professionnel

| N° | Question | Professionnel | Coût estimé HT | Quand |
|---|---|---|---|---|
| 1 | Préinstaller notre application sur un téléphone de marque tierce avant revente nous laisse-t-il distributeur ? Le lot "téléphone scellé et carte" est-il plus sûr ? | Avocat en droit des produits et de la consommation | 800 à 1 500 € | Avant toute vente de téléphone |
| 2 | Rédaction de la finalité du produit et des mentions santé pour rester hors du champ du dispositif médical | Même avocat, ou conseil en affaires réglementaires | 500 à 1 000 € | Avant la v1 |
| 3 | Conditions générales de vente, politique de retour, régime des précommandes, exceptions à la rétractation | Même avocat | 600 à 1 200 € | Avant le premier encaissement |
| 4 | Recherche d'antériorité et dépôt de marque (France, puis Union européenne) | Conseil en propriété industrielle | 400 à 900 € d'honoraires, plus 190 € de taxe INPI pour une classe et 40 € par classe supplémentaire [A CONFIRMER] | Avant d'acheter le nom de domaine définitif |
| 5 | Licences des contenus (obligations de partage à l'identique, licence de la brique de lecture, usage des marques Wikipédia) | Avocat en propriété intellectuelle | 500 à 1 000 € | Avant la v1 |
| 6 | Choix de la forme sociale, articulation avec les droits au chômage, prêt d'honneur | Expert-comptable | Souvent offert au premier rendez-vous, puis 1 500 à 2 500 € par an | Semaine 3 |
| 7 | Assurance responsabilité civile professionnelle et produits, incluant le logiciel | Courtier | 600 à 1 500 € par an [EST] | Avant la première vente |
| 8 | En cas de passage à l'import : vérification du DAS en laboratoire, enregistrements aux filières, déclaration de copie privée | Laboratoire d'essais, éco-organismes | 4 000 à 8 000 € [EST] | Année 2 |

Budget juridique de démarrage : 2 400 à 4 700 € pour les lignes 1 à 5. Le modèle financier en retient 2 100 € au premier mois (1 500 € d'avocat et 600 € de marque) et le solde dans les investissements de lancement.

## 11. Avocat du diable

- "Nous ne sommes que distributeurs, donc tranquilles." La garantie légale de deux ans pèse sur nous, pas sur la marque chinoise. Si elle cesse de répondre, nous remboursons.
- "Un avertissement suffit pour la santé." Non. La qualification en dispositif médical dépend de l'ensemble de notre communication, vidéos comprises. Une seule vidéo "l'IA qui vous soigne quand il n'y a plus de médecin" suffit à fragiliser la position.
- "La réglementation protège du faire soi-même." Au contraire : elle pèse sur le vendeur, pas sur le particulier qui installe ses applications. Elle renforce le substitut gratuit.
