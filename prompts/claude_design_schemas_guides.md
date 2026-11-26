# Prompt Claude Design : schémas et mise en page des guides SIJAMAIS

Rédigé le 26 novembre 2026. À copier dans Claude Design, avec trois pièces jointes :

1. `contenus/guides/guides_v1.1.json` (le contenu des 46 guides) ;
2. une capture de la maquette 0.2 : un écran de guide, par exemple « Arrêt cardiaque », et l'onglet Urgence ;
3. le logo SIJAMAIS (proposition « Le repère »).

Ce qui suit la ligne est le prompt.

---

Tu es directeur artistique et illustrateur pédagogique. Tu travailles pour SIJAMAIS, une application iPhone française, gratuite pour tout ce qui touche à la sécurité, qui fonctionne sans réseau et qui sera recommandée par des mairies à leurs habitants. Les guides joints (fichier JSON) expliquent quoi faire en cas d'alerte, de catastrophe, de coupure de courant, d'accident ou de cyberattaque, et comment se préparer.

## Ce que je veux

Des **schémas pédagogiques** qui rendent les guides compréhensibles en un coup d'œil, et une **mise en page des écrans de guide** qui les intègre. Une personne stressée, qui lit mal le français, ou un enfant, doit comprendre le geste en regardant l'image.

## Style, à respecter strictement

- **Direction « signalétique de sécurité »**, déjà validée : aplats francs, traits épais et réguliers, aucun dégradé, aucune ombre portée, aucun effet 3D, aucun rendu photo.
- **Code couleur** : rouge `#C8102E` avec croix blanche pour les secours ; jaune `#F6C700` (texte `#17241C`) pour le danger et l'alerte ; orange `#E0662A` pour le feu et la chaleur ; bleu `#005EB8` pour l'eau et l'information ; vert `#00843D` pour la sécurité, l'évacuation et le défibrillateur ; vert forêt `#1F3B2D` pour la préparation ; gris `#4A5A51` pour le reste. Fond : lichen `#F3F4EF` en thème clair, nuit `#17241C` en thème sombre.
- **Personnages** : silhouettes simples et neutres, sans visage détaillé, sans âge, genre ni origine marqués, dans l'esprit des pictogrammes de sécurité. Ne copie aucun pictogramme normalisé existant : redessine.
- **Texte dans les schémas** : le moins possible, en français, en gros caractères, police système. Les chiffres clés en grand (« 100 à 120 par minute », « 20 minutes », « 6 litres par personne »).
- **Rien qui fasse « généré par IA »** : pas de rendu lisse et brillant, pas de dégradé violet ou bleu, pas d'illustration décorative sans fonction. Chaque élément sert à comprendre un geste ou une information.
- **Pas de scène de catastrophe ni de blessure réaliste.** Pas de sang : une plaie est un simple repère rouge.

## Format de livraison

- Un fichier **SVG** par schéma, cadre 4:3 (`viewBox="0 0 800 600"`), fond transparent, lisible en thème clair et en thème sombre (contours ou pastilles de fond si nécessaire).
- Nom : `schema-<identifiant du guide>-<numéro>.svg`, par exemple `schema-arret-cardiaque-1.svg`.
- Pour chaque schéma : un **texte alternatif** d'une phrase pour les lecteurs d'écran, dans un tableau récapitulatif.
- Une **maquette d'écran iPhone** (390 × 844) de trois guides, montrant où vont les schémas : « Arrêt cardiaque », « Le kit d'urgence 72 h », « Reconnaître une alerte ». Un schéma en tête de guide, puis une petite vignette à côté de chaque étape quand elle aide.

## Les schémas à produire, par ordre de priorité

| N° | Guide (identifiant) | Schéma |
|---|---|---|
| 1 | `arret-cardiaque` | Position du sauveteur à genoux, mains l'une sur l'autre au centre de la poitrine, bras tendus ; le rythme « 100 à 120 par minute » |
| 2 | `arret-cardiaque` | Emplacement des deux électrodes du défibrillateur sur le torse, et le pictogramme du défibrillateur (cœur vert et éclair) |
| 3 | `inconscient-respire` | La position latérale de sécurité en 3 vignettes |
| 4 | `etouffement` | Deux vignettes : claques dans le dos, personne penchée en avant ; compressions au creux de l'estomac, sauveteur derrière |
| 5 | `saignement` | Main protégée (gant ou sac plastique) qui appuie fort sur la plaie, victime allongée |
| 6 | `brulure` | Zone brûlée sous l'eau tempérée, avec un minuteur « 20 minutes » |
| 7 | `alerte` | Frise du signal national d'alerte : 3 séquences de 1 min 41 s séparées de 5 s ; fin d'alerte : son continu de 30 s ; signal « corne de brume » des barrages : 2 s de son, 3 s de pause, pendant 2 minutes |
| 8 | `reflexes` | Les 7 réflexes en 7 pictogrammes : rejoindre un bâtiment, s'éloigner des fenêtres, aucune flamme, rester à l'abri, ne pas téléphoner, écouter la radio, ne pas aller chercher les enfants à l'école |
| 9 | `abri-evacuation` | Plan simple d'une pièce de mise à l'abri : portes et fenêtres fermées, aérations et bas de porte bouchés |
| 10 | `pfms` | Couper les réseaux : disjoncteur général, robinet d'arrivée d'eau, vanne de gaz (3 vignettes) |
| 11 | `kit72h` | Le kit vu de dessus, objets posés à plat et nommés. **Ne reprends pas** l'illustration de l'affiche officielle, qui est protégée : compose ta propre disposition |
| 12 | `kit72h` | « 6 litres par personne » : rangées de bouteilles par membre du foyer |
| 13 | `risques` | Inondation : une voiture emportée par quelques dizaines de centimètres d'eau ; ne pas descendre au sous-sol |
| 14 | `risques` | Séisme : s'abriter près d'un mur porteur ou sous un meuble solide, loin des fenêtres |
| 15 | `incendie-domicile` | Plan d'un logement : détecteur de fumée dans le couloir des chambres, croix sur la cuisine et la salle de bain |
| 16 | `monoxyde` | Groupe électrogène, barbecue et chauffage d'appoint interdits à l'intérieur ; fenêtre ouverte pour aérer |
| 17 | `eau` | Les 3 étapes pour rendre l'eau buvable : filtrer, faire bouillir, désinfecter |
| 18 | `feu` | Le triangle du feu (combustible, oxygène, chaleur) et un petit feu en tipi entouré de pierres |
| 19 | `orientation` | Trouver le sud avec une montre à aiguilles, en France : repère du 1 en hiver, du 2 en été |
| 20 | `signaux` | Trois feux en triangle ; les deux bras levés en Y, qui signifient « besoin d'aide » |
| 21 | `abri` | Abri de fortune avec une bâche, sol isolé par des feuilles et des branches |
| 22 | `cyberattaque` | Appareil bloqué par une rançon : couper le Wi-Fi, débrancher le câble, ne pas éteindre, ne pas payer |
| 23 | `canicule` | Volets fermés le jour, fenêtres ouvertes la nuit |
| 24 | `coupure-electricite` | Réfrigérateur et congélateur fermés ; une lampe laissée allumée pour voir le retour du courant |

Les schémas 1 à 6 décrivent des gestes de secours : respecte exactement le texte des guides. Ils seront relus par un formateur agréé aux premiers secours avant publication.

## Photos

Ne génère **aucune photo**, et n'utilise aucune image produite par une IA. Là où une photo apporterait quelque chose (guides de loisir et de survie en nature, page d'accueil des catégories), place un **cadre vide** légendé avec la description de la photo attendue. Je fournirai moi-même des photos libres de droits ou achetées.

## Ce que j'attends en retour

1. Les 24 schémas en SVG, ou au moins les 12 premiers si tu dois prioriser.
2. Le tableau des textes alternatifs.
3. Les trois maquettes d'écran de guide.
4. Une page « charte des schémas » : épaisseur de trait, palette, construction des silhouettes, pour qu'un illustrateur puisse continuer la série.

---

## Après Claude Design (pour Benjamin)

1. Dépose les SVG dans `contenus/guides/schemas/` (ou envoie-les dans la conversation) : je les intègre dans les guides et dans la maquette, avec un nouveau type de bloc « schéma ».
2. Les schémas 1 à 6 doivent être relus par un formateur agréé avant toute diffusion.
3. Pour les photos, garde pour chacune : la source, l'auteur, la licence et la date, dans `contenus/images/CREDITS.csv`. Règles :

| Source | Utilisation commerciale | Ce qu'il faut faire |
|---|---|---|
| Tes propres photos | Oui | Accord écrit de toute personne reconnaissable |
| Unsplash, Pexels | Oui, selon leur licence [A VERIFIER au moment du téléchargement] | Garder la page d'origine ; créditer par courtoisie |
| Wikimedia Commons | Selon la licence de chaque image | CC BY : créditer l'auteur. CC BY-SA : créditer et republier les modifications sous la même licence. Éviter les images sans licence claire |
| Banque payante (Adobe Stock, iStock) | Oui, avec la licence achetée | Garder la facture et la licence |
| Images générées par IA | **Non** | Exclu par la charte |
| Illustration de l'affiche officielle du kit 72 h | **Non** | Protégée (Antoine Dagan, CitizenPress) |
