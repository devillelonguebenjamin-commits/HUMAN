# Écran « S'équiper » et liens affiliés

Décision de Benjamin du 27/11/2026 : un écran qui dit où trouver chaque article des listes des guides, dans les commerces ordinaires d'abord, avec en option un lien affilié Amazon pour ceux qui n'ont pas de commerce à proximité. Objectif : une deuxième source de revenus, à côté de l'abonnement premium.

## Les règles retenues

1. **Le conseil neutre d'abord.** Chaque article indique les commerces où le trouver (pharmacie, quincaillerie, supermarché, magasin de sport...). Le lien Amazon vient en dessous, signalé « lien affilié ».
2. **Rien n'est ajouté aux listes officielles.** Chaque article est une ligne exacte d'un guide (vérifié par `outils/construire_catalogue.py` et par un test).
3. **Aucune marque.** Le lien ouvre une recherche Amazon (« lampe frontale »), pas un produit : pas de recommandation de marque, pas de lien mort quand un produit disparaît, et cohérence avec l'assistant, qui refuse toute recommandation de marque.
4. **Pas de lien** pour les médicaments, le lait infantile, l'eau, les conserves, la nourriture animale, le thermomètre, les pansements et les masques : pharmacie et commerce de proximité.
5. **Jamais de commerce dans l'urgence** : rien dans l'écran Urgence, rien dans les réponses de l'assistant, rien dans les guides de secours. L'écran s'ouvre depuis l'accueil (tuile « S'équiper ») et en bas des guides Kit 72 h, Sac d'évacuation, Trousse, Stocks et Véhicule.
6. **Mises en garde conservées** : le réchaud porte « À utiliser dehors uniquement : risque mortel de monoxyde de carbone » ; le couteau, « La loi encadre le port d'un couteau ».
7. **Aucune donnée collectée par SIJAMAIS** : le lien s'ouvre dans Safari ; c'est Amazon qui suit l'achat.

## Activer les liens (à faire par Benjamin)

Tant que l'identifiant est vide, **l'écran n'affiche aucun lien** : il reste purement informatif.

1. S'inscrire au programme Amazon Partenaires sur partenaires.amazon.fr. Amazon demande d'indiquer le site ou l'application qui portera les liens : l'adresse de l'application sur l'App Store, ou un site de présentation.
2. Récupérer l'identifiant de suivi (de la forme `nom-21`).
3. Le copier dans `outils/construire_catalogue.py` (champ `"tag"`), puis lancer :
   ```
   python3 outils/construire_catalogue.py
   python3 outils/preparer_ressources_app.py
   ```

## À vérifier avant d'activer

Points que je n'ai pas pu vérifier, le site d'Amazon n'étant pas accessible depuis mon environnement :
- le barème des commissions par catégorie et la durée de suivi après un clic ;
- les conditions pour rester dans le programme : Amazon exige un nombre minimal de ventes dans les premiers mois, sinon le compte est fermé ;
- l'usage des liens dans une application mobile, autorisé sous conditions ;
- la mention exacte imposée par Amazon. Celle de l'écran reprend la formule habituelle : « En tant que Partenaire Amazon, SIJAMAIS réalise un bénéfice sur les achats remplissant les conditions requises » ;
- côté App Store : un lien vers l'achat d'un bien physique sur un site extérieur est en principe permis sans passer par l'achat intégré d'Apple ; à confirmer dans les règles de l'App Store au moment de la soumission.

## Pistes suivantes

- **Commerces de la commune** : avec l'espace commune, une mairie pourrait ajouter ses commerces locaux en tête de chaque article. C'est un argument pour les élus.
- **Partie premium loisir** (randonnée, camping) : liens vers du matériel spécialisé, avec les mêmes règles.
