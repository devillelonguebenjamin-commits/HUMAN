# Spécification technique du MVP logiciel

Version 0.1 du 12 novembre 2026. Nom de travail du produit : MECUM. Ce document sert de base aux demandes de devis des développeurs. Il est accompagné d'une maquette fonctionnelle du coeur de recherche (`recherche.py`, `tests_recherche.py`, dossier `fiches/`). Le raisonnement et les sources sont dans `03_produit_technique.md`.

## 1. Objet et périmètre

Une application Android qui donne accès, sans aucun réseau, à un corpus de savoirs utiles en français : fiches réflexes validées, encyclopédie, cartes, outils. Elle fonctionne sur le téléphone du client ou sur un téléphone durci vendu avec le pack.

Hors périmètre de la v1 : iOS, synchronisation en ligne, comptes utilisateurs, communication radio ou maillée, assistant génératif.

Finalité déclarée (à reprendre telle quelle dans les mentions) : information générale et éducation. L'application n'est pas un dispositif médical, ne pose pas de diagnostic et ne remplace ni les secours ni un professionnel de santé.

## 2. Utilisateurs et situations d'usage

| Utilisateur | Situation | Besoin |
|---|---|---|
| Parent non technicien | Coupure de courant de plusieurs heures | Savoir quoi faire dans l'ordre, sans lire dix pages |
| Randonneur, navigateur | Zone sans réseau | Carte, position, conduite à tenir en cas d'imprévu |
| Enfant ou adolescent | Soirée sans connexion | Encyclopédie adaptée, lecture |
| Membre d'une association ou d'une réserve communale | Exercice ou crise | Listes de contrôle, numéros, fiches partagées |

Contrainte d'ergonomie commune : stress, faible luminosité, mains froides ou mouillées. Gros caractères, contraste élevé, quatre actions au plus par écran, aucune fenêtre surgissante.

## 3. Fonctions

### 3.1 Version 1 (première vente)

| N° | Fonction | Description | Critère d'acceptation |
|---|---|---|---|
| F1 | Ecran d'accueil | Quatre entrées : Urgence, Chercher, Cartes, Bibliothèque. Peut remplacer l'écran d'accueil du téléphone (application de type lanceur), sans modifier le système | Lisible à un mètre. Tout est accessible en deux touches |
| F2 | Urgence | Numéros (112, 15, 18, 17, 114), position GPS en clair, lampe, signal lumineux SOS, six fiches vitales épinglées | Fonctionne en mode avion. Appel possible d'une touche si un réseau existe |
| F3 | Fiches réflexes | 60 à 100 fiches au format commun : l'essentiel, pas à pas, à ne pas faire, quand alerter, sources, relecteur, date | Chaque fiche s'affiche en moins d'une seconde |
| F4 | Recherche unifiée (niveau 1) | Question en langage courant. Retourne les fiches pertinentes, puis les articles d'encyclopédie. Aucune génération | Les 100 questions de contrôle remontent la bonne fiche en premier dans 95 % des cas |
| F5 | Sujets sensibles (niveau 3) | Santé, médicaments, plantes et champignons, électricité : bandeau de rappel d'urgence, fiche validée seulement | Aucune réponse générée sur ces sujets, dans aucune version |
| F6 | Bibliothèque | Ouverture des fichiers ZIM (Wikipédia, WikiMed, Vikidia, Wikilivres) par l'application Kiwix installée à côté, via un lien direct. Rayon "enfants" | Ouverture d'un article en moins de trois secondes |
| F7 | Cartes | Ouverture d'Organic Maps avec la carte de France préchargée, via un lien direct | Position affichée sans réseau |
| F8 | Listes de contrôle | Kit de 72 heures, plan familial, vérification semestrielle avec rappel | Etat conservé hors ligne |
| F9 | Installation depuis la carte | Un assistant copie ou référence les contenus de la carte mémoire et installe les applications compagnes | Installation réussie sans aide par 9 personnes non techniciennes sur 10, en moins de 10 minutes |
| F10 | Economie d'énergie | Thème sombre, aucune tâche de fond, rappel du mode avion | Consommation en veille non mesurable par rapport au téléphone seul |

### 3.2 Version 2 (trois à quatre mois après)

| N° | Fonction | Description |
|---|---|---|
| F11 | Assistant à réponses citées (niveau 2) | Modèle de langage local (Gemma 4 E2B, 2,58 Go). Réponse de cinq phrases au plus, construite sur les seuls passages retrouvés, avec numéros de sources. Proposé seulement si le téléphone a 8 Go de mémoire. Coupé sous 15 % de batterie ou en cas de surchauffe |
| F12 | Recherche sémantique | Petit modèle d'embeddings multilingue pour retrouver une fiche même sans mot commun avec la question |
| F13 | Lecteur intégré | Lecture des fichiers ZIM et des cartes dans l'application, sans applications compagnes |
| F14 | Mises à jour du corpus | Par téléchargement volontaire ou par remplacement de la carte. Jamais automatique |

## 4. Architecture

```
Application Android (Kotlin, interface Compose)
|
+-- Module Fiches        fichiers Markdown et images, index SQLite FTS5
+-- Module Recherche     analyse de la question, synonymes, classement BM25,
|                        détection des sujets sensibles
+-- Module Urgence       appels, position (GPS matériel), lampe, signal SOS
+-- Module Listes        stockage local chiffrable, rappels
+-- Module Passerelles   liens directs vers Kiwix (fichiers ZIM) et Organic Maps
+-- Module Assistant     (v2) moteur LiteRT-LM ou llama.cpp, modèle sur la carte
|
Stockage : mémoire interne pour l'application et l'index (moins de 200 Mo),
           carte mémoire pour les encyclopédies, les cartes et le modèle
```

Choix structurants :

1. aucune autorisation réseau demandée par l'application en v1. C'est vérifiable par le client et c'est un argument de confiance ;
2. aucune modification du système du téléphone. Tout passe par des applications ordinaires ;
3. le corpus est séparé du code. Une fiche se corrige sans republier l'application ;
4. le code est publié sous licence libre si la brique de lecture ZIM est intégrée (v2). En v1, les passerelles évitent cette contrainte ;
5. distribution double : fichier d'installation sur la carte et fiche sur Google Play.

## 5. Format des contenus

Une fiche est un fichier texte avec un en-tête et quatre rubriques. Exemple réel dans `fiches/eau-potable.md`.

| Champ | Rôle |
|---|---|
| `id`, `titre`, `categorie` | Identification et classement |
| `sensible` | `oui` déclenche le niveau 3 |
| `mots_cles` | Vocabulaire du client, y compris les formulations maladroites |
| `sources` | Références publiques de la fiche |
| `relecture` | Nom et qualité du relecteur, date. Vide tant que la fiche n'est pas validée : elle n'est alors pas livrée |
| `maj` | Date de dernière mise à jour |

Processus éditorial : rédaction, relecture par un formateur de secourisme et un médecin pour les fiches sensibles, test de lecture par deux personnes non spécialistes, publication, journal des corrections.

## 6. La maquette fournie

| Fichier | Contenu |
|---|---|
| `recherche.py` | Index plein texte en mémoire (SQLite FTS5), analyse de la question, synonymes, classement, détection des sujets sensibles, construction de l'invite du niveau 2 |
| `tests_recherche.py` | 20 questions de contrôle en langage courant, avec la fiche attendue et le caractère sensible |
| `fiches/` | 12 fiches de démonstration, non relues, à ne pas diffuser |

Essayer :

```
python3 recherche.py "il saigne beaucoup du bras"
python3 recherche.py --invite "que faire en cas de coupure de courant"
python3 recherche.py --interactif
python3 tests_recherche.py
```

Résultat au 12/11/2026 : 20 questions sur 20 remontent la bonne fiche. Ce score n'a pas de valeur statistique sur 12 fiches. La maquette a montré deux limites de la recherche par mots, à traiter dans l'application :

- une question sur le temps d'ébullition de l'eau remontait la fiche "Brûlure" à cause de l'expression "eau bouillante". Corrigé par un synonyme. Avec 100 fiches, ces collisions seront nombreuses : d'où la recherche sémantique en v2 et le jeu de 100 questions ;
- le mot "coupure" rapprochait la panne de courant et la plaie. Corrigé par un seuil de pertinence sur les fiches secondaires.

## 7. Exigences non fonctionnelles

| Exigence | Cible |
|---|---|
| Fonctionnement | 100 % hors ligne après installation |
| Compatibilité | Android 12 et suivants, 4 Go de mémoire pour la v1 |
| Démarrage | Moins de 2 secondes |
| Recherche | Moins de 0,5 seconde pour le niveau 1 |
| Assistant (v2) | Première phrase en moins de 10 secondes, 5 jetons par seconde au minimum |
| Accessibilité | Taille de police réglable, contraste élevé, lecture d'écran |
| Vie privée | Aucune collecte, aucune autorisation réseau en v1 |
| Garantie | Mises à jour correctives pendant 2 ans au moins |

## 8. Plan de test

1. Jeu de 100 questions en langage courant, dont 30 sur des sujets sensibles et 10 pièges (questions dangereuses, hors sujet, ambiguës). Rejoué à chaque version. Seuil : 95 % de bonnes fiches en premier, 100 % de détection des sujets sensibles.
2. Test d'installation par 10 personnes non techniciennes, chronométré.
3. Test d'autonomie de 30 jours sur les deux téléphones de référence, protocole publié.
4. Pour la v2 : 200 réponses de l'assistant relues à la main. Seuil : aucune réponse contraire à une fiche, 95 % de réponses avec source correcte.

## 9. Lots et estimation

| Lot | Contenu | Charge estimée | Coût externe estimé |
|---|---|---|---|
| 0 | "MVP zéro" : assemblage manuel d'applications existantes sur trois téléphones | 3 jours du fondateur | 0 € |
| 1 | Application v1 : F1 à F10 | 4 à 6 semaines du fondateur avec assistance IA, 5 à 6 jours de développeur Android pour la revue, les tests sur appareils et la publication | 3 000 € |
| 2 | Corpus : 60 fiches, relecture professionnelle | 4 semaines du fondateur | 1 200 € |
| 3 | Application v2 : F11 à F14 | 6 à 8 semaines | 5 000 € |

Ces estimations sont à confirmer par deux devis (hypothèse H17 du registre).

## 10. Questions à poser aux développeurs consultés

1. Avez-vous déjà publié une application Android fonctionnant entièrement hors ligne ? Laquelle ?
2. Comment gérez-vous la lecture de fichiers de plusieurs dizaines de gigaoctets sur carte mémoire, avec les restrictions d'accès au stockage des versions récentes d'Android ?
3. Avez-vous déjà intégré un modèle de langage local (LiteRT ou llama.cpp) ? Sur quels téléphones ?
4. Acceptez-vous que le code soit publié sous licence libre ?
5. Quel forfait proposez-vous pour la maintenance mensuelle ?
