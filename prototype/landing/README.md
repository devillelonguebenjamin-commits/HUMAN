# Page d'atterrissage de test

Page unique, sans dépendance externe, prête à publier sur n'importe quel hébergement de fichiers statiques. Elle sert à mesurer la demande avant tout investissement (voir `plan_30_jours.md`). Elle ne vend rien et le dit.

## Avant de publier

| Etape | Où | Détail |
|---|---|---|
| 1. Nom de marque | Bloc `CONFIG` en bas de `index.html`, champ `marque` | Nom de travail actuel : MECUM |
| 2. Collecte des inscriptions | Champ `adresseDeCollecte` | Adresse d'un service qui accepte un envoi JSON : outil d'emailing, service de formulaires, ou petite fonction maison. Tant que le champ est vide, la page est en mode démonstration et n'envoie rien |
| 3. Mentions légales | Pied de page | Remplacer les quatre mentions entre crochets : éditeur, adresse, contact, hébergeur |
| 4. Mesure d'audience | Balise `<head>` | Ajouter le script d'un outil sans traceur ni cookie. Aucun bandeau de consentement n'est alors nécessaire. Si tu ajoutes un pixel publicitaire, un bandeau de consentement devient obligatoire |
| 5. Référencement | Balise `<meta name="robots">` | Laisser `noindex` pendant le test. La retirer au lancement |

## Variantes de test

| Paramètre d'adresse | Valeurs | Effet |
|---|---|---|
| `m` | `famille` (par défaut), `pleinair`, `education` | Change le titre et le texte d'accroche. Utiliser une valeur par annonce |
| `p` | `bas`, `haut` | Impose le niveau de prix affiché. Sans ce paramètre, il est tiré au sort et mémorisé pour le visiteur |
| `utm_source` | Libre | Enregistré avec l'inscription pour distinguer les canaux |

Exemple : `https://exemple.fr/?m=pleinair&utm_source=meta_v1`

Niveaux de prix testés (modifiables dans `CONFIG.prix`) : pack carte à 79 ou 99 €, pack numérique à 39 ou 49 €, téléphone à partir de 299 ou 329 €.

## Données enregistrées par inscription

Adresse électronique, produits qui intéressent le visiteur (dont l'option "boîtier familial", qui mesure la variante classée deuxième), avis sur le prix affiché, usage envisagé, message vu, niveau de prix vu, canal d'origine, date. Rien d'autre.

## Ce qu'il faut regarder

| Indicateur | Calcul | Seuil d'arrêt | Seuil de poursuite |
|---|---|---|---|
| Taux d'inscription | Inscrits divisés par visiteurs uniques | Moins de 3 % | 8 % ou plus |
| Coût par inscrit | Dépense publicitaire divisée par inscrits venus des annonces | Plus de 8 € | Moins de 4 € |
| Acceptation du prix | Part des réponses "Je l'achète", par niveau de prix | Moins de 25 % | 40 % ou plus |
| Mix souhaité | Répartition des cases cochées | Information | Information |

## Vérifications faites

Rendu contrôlé le 12/11/2026 dans un navigateur, en largeur d'ordinateur (1 280 px) et de téléphone (390 px) : pas de défilement horizontal, variantes de message et de prix fonctionnelles, validation du formulaire fonctionnelle, aucune erreur de script. Thème sombre automatique selon le réglage de l'appareil.

## Règles de conduite du test

- Ne pas promettre de date de livraison ferme tant que la décision n'est pas prise.
- Ne pas faire référence à une crise en cours dans les annonces : c'est contraire aux règles publicitaires de Meta et à la charte éditoriale (`06_acquisition_marque.md`).
- Ecrire à tous les inscrits à la fin du test, quelle que soit la décision.
