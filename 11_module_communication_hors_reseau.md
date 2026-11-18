# 11. Module de communication hors réseau : analyse et plan d'implémentation

Rédigé le 18 novembre 2026, **à valider par Benjamin avant toute ligne de code**. Marqueurs : [FAIT] vérifié ce jour par recherche, [A VERIFIER] trouvé mais à confirmer sur la source primaire, [EST] estimation, [MEMOIRE] connu sans vérification ce jour.

## 0. En bref

1. **Le dépôt ne contient aucun code d'application.** Il contient l'étude, le modèle financier, une maquette HTML et un prototype de recherche en Python. Le module ne peut donc pas « s'intégrer à l'existant » : il faut d'abord fixer la pile technique, puis bâtir le cœur du module, testable sans téléphone.
2. **Trois limites bloquent la demande telle qu'elle est écrite :**
   - un iPhone en arrière-plan ne relaie presque plus rien : le maillage entre téléphones ne marche bien que si l'application est ouverte ;
   - Multipeer Connectivity (iOS) et Wi-Fi Direct (Android) ne se parlent pas, et Multipeer s'arrête dès que l'application passe en arrière-plan ;
   - les définitions officielles de Meshtastic sont sous licence GPL-3.0, ce qui pose une question juridique pour une application fermée publiée sur l'App Store.
3. **Ma proposition :** Bluetooth Low Energy comme canal commun iPhone et Android, Wi-Fi Aware (présent sur iOS 26 et Android) à la place de Multipeer et de Wi-Fi Direct pour les messages vocaux, Meshtastic en Bluetooth pour la longue portée, et un cœur commun (routage, déduplication, chiffrement, sérialisation) écrit une fois et testé sur ordinateur.
4. **Le coût dépasse le budget actuel.** Le module complet représente 75 à 125 jours de développement [EST], soit 2 à 3 fois le budget de la v1 entière. Je propose de découper, et de faire du réseau de relais LoRa une offre payante pour les communes.

## 1. Ce que contient le dépôt aujourd'hui

| Élément | État | Conséquence pour le module |
|---|---|---|
| Application iPhone | **Inexistante.** Spécification `prototype/mvp_logiciel/SPECIFICATION.md` v0.2 seulement | Tout le code est à écrire |
| Pile technique décidée | Swift et SwiftUI, iOS 26, MapLibre et PMTiles pour la carte, SQLite FTS5 pour la recherche, StoreKit 2 (`09_application_iphone.md`, section 3) | Le module sera en Swift côté iPhone |
| Plateformes | **iPhone seul au lancement.** Android écarté de la v1 | Contradiction avec la demande Android (voir section 2) |
| Carte hors ligne | Maquette HTML (`prototype/maquette_app/`), pas de code MapLibre | Les relais des communes s'afficheront sur une carte qui reste à construire |
| Prototype de code | `prototype/mvp_logiciel/recherche.py` et ses tests (Python, recherche dans les fiches) | Sans lien avec le module |
| Maillage Bluetooth | **Explicitement exclu de la v1** (spécification, section 1, et `09`, section 4). La maquette l'affiche « Bientôt » (question 26 validée) | Le module change le périmètre et le budget de la v1 |
| Budget de développement | 6 000 à 8 000 € pour la v1, 8 à 10 semaines d'un développeur iOS à temps partiel [EST] | Le module seul dépasse ce budget |
| Matériel | Pas de Mac (achat prévu au Black Friday, le 27/11/2026), iPad de 2021 | Rien ne peut être compilé ni testé sur iPhone avant l'achat du Mac |

## 2. Incohérences avec l'existant

| N° | Demande | Existant | Ma recommandation |
|---|---|---|---|
| I1 | Wi-Fi Direct sur Android | iPhone seul au lancement | Garder l'iPhone d'abord. Concevoir le format des messages pour Android dès maintenant, coder Android ensuite |
| I2 | Multipeer Connectivity sur iOS | Multipeer est limité à Apple, ne fonctionne pas en arrière-plan, et serait déprécié dans Xcode 27 [A VERIFIER] | Ne pas l'utiliser. Prendre Network framework et Wi-Fi Aware, interopérables avec Android |
| I3 | Basculer sur internet « s'il revient » | Contrainte « aucune dépendance à un serveur » | Les deux sont incompatibles : internet suppose un serveur, le nôtre ou celui d'un tiers. Je propose de reporter ce canal après la v1 et d'en décider plus tard |
| I4 | Relais affichés sur « la carte hors ligne existante » | La carte n'existe qu'en maquette | Construire d'abord la carte (déjà dans la v1), puis la couche des relais |
| I5 | Module dans la v1 | Maillage exclu de la v1, budget de 6 000 à 8 000 € | Décision à prendre : retarder la v1, ou sortir la v1 sans le module et l'ajouter en v1.1 |
| I6 | Alerte SOS prioritaire | Règle déjà écrite : l'application ne remplace jamais le 112 | Le SOS du maillage complète le 112, ne le remplace pas. Le 112 passe par le réseau de n'importe quel opérateur, même sans carte SIM [MEMOIRE] |
| I7 | Canal d'alertes de la mairie | FR-Alert est le canal officiel de l'État ; la mairie a déjà ses outils (IntraMuros, Illiwap) | Présenter le canal comme un complément local hors réseau, jamais comme FR-Alert |
| I8 | Messagerie entre habitants | Promesse « aucune donnée collectée » | Compatible si tout reste sur les téléphones. Mais diffuser sa position à des inconnus est une donnée personnelle : partage de position désactivé par défaut |

## 3. Limites techniques bloquantes

### 3.1 iPhone en arrière-plan (la plus importante)

| Technique | Application ouverte | Application en arrière-plan ou écran verrouillé |
|---|---|---|
| Multipeer Connectivity | Fonctionne | **Ne fonctionne pas** : la session est coupée, c'est voulu par Apple [FAIT, forums développeurs Apple] |
| Bluetooth Low Energy, recherche d'appareils | Rapide | Possible avec le mode d'arrière-plan `bluetooth-central`, mais plus lente et limitée aux services déclarés [MEMOIRE] |
| Bluetooth Low Energy, annonce de présence | Normale | Très réduite : l'identifiant du service passe dans une « zone de débordement » que seul un autre iPhone, qui le cherche explicitement, peut voir [MEMOIRE] |
| Connexion à un boîtier Meshtastic déjà appairé | Fonctionne | **Fonctionne bien** : une notification du boîtier réveille l'application [MEMOIRE] |

**Conséquence :** deux iPhones verrouillés dans une poche se découvrent mal, et le relais multi-sauts entre iPhones fermés est peu fiable. Le maillage entre téléphones fonctionne surtout quand les gens ont l'application ouverte, ce qui est le cas en situation de crise. **Le boîtier LoRa est la seule voie fiable en arrière-plan sur iPhone.** Sur Android, un service de premier plan (avec notification permanente) permet de relayer en continu.

C'est aussi un argument pour les communes : les relais LoRa fixes portent le réseau, les téléphones le complètent.

### 3.2 Pas de voix sur le maillage Bluetooth multi-sauts

Le Bluetooth Low Energy transporte quelques kilo-octets par seconde en pratique [EST]. Un message vocal de 15 secondes compressé pèse 20 à 30 ko [EST]. C'est envisageable d'un téléphone à l'autre, coûteux sur plusieurs sauts. Je propose : message vocal par Wi-Fi Aware quand il est disponible, par Bluetooth sur 2 sauts au plus, jamais par LoRa.

### 3.3 Licence de Meshtastic

Les définitions de messages de Meshtastic (fichiers protobuf), le logiciel des boîtiers et l'application iPhone officielle sont sous **GPL-3.0** [FAIT, paquet officiel et dépôt Meshtastic-Apple]. Utiliser ces définitions dans SIJAMAIS pourrait obliger à publier toute l'application sous GPL. C'est le même problème que celui de libkiwix, déjà écarté pour cette raison. Trois options :

1. Demander à Meshtastic une autorisation écrite pour un usage dans une application fermée.
2. Publier SIJAMAIS en logiciel libre sous GPL-3.0. Compatibilité avec les conditions de l'App Store à faire vérifier par l'avocat.
3. Ne pas intégrer Meshtastic et renvoyer vers l'application Meshtastic officielle (gratuite) pour la longue portée.

**Je ne commence pas l'étape Meshtastic sans l'avis de l'avocat.** Le nom « Meshtastic » est aussi une marque : vérifier ses règles d'usage avant d'écrire « compatible Meshtastic ».

### 3.4 Bande 868 MHz en Europe

- Meshtastic en région EU_868 émet autour de 869,525 MHz, dans la sous-bande 869,4 à 869,65 MHz limitée à **10 % du temps** et 500 mW [FAIT, documentation Meshtastic et The Things Network]. Soit 360 secondes d'émission par heure au maximum.
- Je n'ai pas pu confirmer que le logiciel des boîtiers applique lui-même cette limite [A VERIFIER]. **SIJAMAIS doit donc la faire respecter de son côté** : calcul du temps d'émission de chaque message et file d'attente avec un budget.
- Je propose de ne consommer que la moitié de la limite légale (180 secondes par heure et par boîtier), pour laisser de la place aux autres utilisateurs de la bande.
- Textes de référence à faire lire : ETSI EN 300 220 et recommandation ERC 70-03.

### 3.5 Authenticité des alertes de la mairie

Sans serveur, n'importe qui pourrait diffuser une fausse « alerte de la mairie ». C'est le risque le plus grave du module : une fausse consigne d'évacuation. Les alertes officielles seront donc **signées** par la clé de la commune et affichées comme officielles seulement si la signature est valide (section 5.4).

## 4. Choix techniques recommandés

| Besoin | Recommandation | Bibliothèque | Licence | Limites |
|---|---|---|---|---|
| Maillage proche, iPhone et Android | Bluetooth Low Energy, protocole SIJAMAIS | CoreBluetooth (iOS), API Bluetooth d'Android | Système | Arrière-plan iOS (3.1), débit faible |
| Gros messages (voix) | Wi-Fi Aware | Network framework et Wi-Fi Aware (iOS 26), `WifiAwareManager` (Android 8 et plus) | Système | iPhones compatibles à vérifier [A VERIFIER]. Pas en arrière-plan sur iOS [MEMOIRE] |
| Référence de conception | bitchat, maillage Bluetooth iOS et Android | Code et protocole publics | Domaine public [FAIT, README du projet] | Pas d'audit de sécurité externe selon ses auteurs : s'en inspirer, ne pas le copier sans relecture |
| Chiffrement | Clés Curve25519 (X25519 pour l'échange, Ed25519 pour la signature), ChaCha20-Poly1305 | CryptoKit (iOS), swift-crypto pour les tests sur ordinateur, Tink ou libsodium (Android) | Système, Apache 2.0, ISC | Pas de confidentialité persistante pour les messages stockés puis relayés |
| Sérialisation | Format binaire compact, spécifié et versionné, avec vecteurs de test | Code maison, sans dépendance | | Exige une spécification écrite pour qu'Android soit compatible |
| Stockage local | SQLite (déjà prévu) | GRDB.swift | MIT | |
| Longue portée | Boîtier Meshtastic en Bluetooth, API client officielle | Protobufs Meshtastic, SwiftProtobuf | GPL-3.0 et Apache 2.0 | Licence (3.3), environ 200 octets par message [A VERIFIER] |
| Voix | AAC-ELD ou Opus, mono, 12 à 16 kbit/s, 15 secondes au plus | AVFoundation | Système | Opus en enregistrement sur iOS [A VERIFIER] |
| Carte | MapLibre (déjà prévu), couche « relais » | MapLibre Native | BSD | |

**Écartés :** Multipeer Connectivity (Apple seul, pas d'arrière-plan, dépréciation annoncée [A VERIFIER]), Wi-Fi Direct (Android seul), Google Nearby Connections (Android seul), Bridgefy (kit payant et fermé).

## 5. Architecture

### 5.1 Couches

```
Interface SwiftUI (Messages, SOS, Carte, Alertes de la mairie)
        │  ne connaît ni Bluetooth, ni LoRa
MessagingService : envoyer, recevoir, fil des conversations, statut « relayé »
        │
Router : déduplication, durée de vie, priorités, stocker et renvoyer
        │
Crypto : identité, signature, chiffrement de bout en bout
        │
Codec : format binaire, découpage en fragments, compression
        │
TransportManager : choisit le canal selon la taille, la priorité, les pairs présents
   ├── BLEMeshTransport      (iPhone et Android)
   ├── WiFiAwareTransport    (voix, gros messages)
   ├── MeshtasticTransport   (boîtier LoRa en Bluetooth)
   └── InternetTransport     (reporté, voir I3)
```

Le cœur (MessagingService, Router, Crypto, Codec, choix du canal) est **du Swift pur, sans dépendance à l'iPhone**. Il se teste sur ordinateur, y compris sur Linux. C'est la partie que je peux écrire et tester dès maintenant, sans Mac.

### 5.2 Format d'un message (enveloppe)

| Champ | Taille | Rôle |
|---|---|---|
| Version | 1 octet | Évolution du format |
| Type | 1 octet | Texte, position, SOS, vocal, alerte officielle, accusé de réception, résumé pour la synchronisation |
| Identifiant | 16 octets aléatoires | Déduplication |
| Émetteur | 8 octets (empreinte de la clé publique) | Pas de nom, pas de numéro de téléphone |
| Destinataire | 0 ou 8 octets | Absent pour une diffusion |
| Sauts restants | 1 octet | 7 au départ en Bluetooth, 3 sur LoRa |
| Expiration | 4 octets (heure absolue) | SOS 24 h, texte 12 h, position 2 h, alerte officielle fixée par la mairie [EST, à valider] |
| Priorité et canal | 1 octet | SOS, officiel, normal ; habitants, mairie, famille, direct |
| Contenu | variable | Chiffré pour un message direct ou familial |
| Signature | 64 octets | Ed25519, obligatoire pour l'officiel et le SOS |

Les sauts restants sont exclus de la signature, puisque chaque relais les décrémente.

### 5.3 Routage

- **Diffusion contrôlée :** chaque téléphone retransmet une seule fois chaque message, avec un délai aléatoire de 50 à 500 ms. Il renonce s'il a déjà entendu deux voisins relayer le même message, pour éviter les tempêtes.
- **Déduplication :** mémoire des identifiants déjà vus, conservée sur le disque jusqu'à leur expiration.
- **Priorités :** file d'envoi SOS, puis alertes officielles, puis messages directs, puis diffusion, puis vocal.
- **Stocker et renvoyer :** à l'arrivée d'un nouveau voisin, les deux téléphones échangent un résumé compact des messages qu'ils détiennent, puis seulement ceux qui manquent. Quotas : 2 000 messages et 20 Mo [EST].
- **Accusé de réception** pour les messages directs et les SOS, renvoyé par le même chemin.

### 5.4 Chiffrement et confiance

| Canal | Confidentialité | Authenticité |
|---|---|---|
| Message direct | Chiffré pour le seul destinataire (clé éphémère X25519 et ChaCha20-Poly1305) | Signé |
| Famille | Chiffré avec une clé de groupe partagée par QR code | Signé |
| Habitants (public) | **Aucune**, et l'interface le dit : « Visible par tous à proximité » | Signé |
| SOS | Public par nature, pour être relayé et lu par tous | Signé |
| Alerte de la mairie | Publique | **Signée par la clé de la commune**, elle-même certifiée par la clé de SIJAMAIS |

Distribution hors ligne des clés de commune : un « pack commune » signé, téléchargé à l'installation avec la carte, ou importé par QR code affiché en mairie. Il contient la clé de la commune, ses relais LoRa et ses points de rassemblement. Une clé compromise se révoque par un nouveau pack.

### 5.5 Meshtastic

- Connexion Bluetooth au service officiel du boîtier (`6ba1b218-15a8-461f-9fa8-5dcae273eafd`). Écriture dans ToRadio, lecture de FromRadio jusqu'au paquet vide, notification par FromNum. Poignée de main `want_config_id`, puis `config_complete_id` [FAIT, documentation de l'API client]. Correspondance exacte entre identifiants et caractéristiques à vérifier dans le code source, car les sources divergent [A VERIFIER].
- Texte et position sur les ports standard (TEXT_MESSAGE_APP, POSITION_APP), pour rester lisibles depuis l'application Meshtastic officielle. SOS et alertes signées en format SIJAMAIS compact sur un port privé : la procédure d'attribution des ports tiers 64 à 127 passe par une demande au projet [FAIT, documentation des protobufs].
- Compression : position sur 2 fois 3 octets (précision d'environ 1 m dans la zone), heure relative, texte court avec le format compressé de Meshtastic s'il est disponible [A VERIFIER]. Un SOS complet tient en moins de 100 octets, signature comprise [EST].
- Garde-fou réglementaire (3.4) : calcul du temps d'émission par message selon les réglages radio du boîtier, budget glissant d'une heure, SOS en tête de file mais soumis au même budget.
- Canal SIJAMAIS dédié avec clé de canal propre (la clé par défaut de Meshtastic est publique), et nombre de sauts limité à 3.

### 5.6 Choix automatique du canal

| Situation | Canal choisi |
|---|---|
| Destinataire ou voisins à portée Bluetooth | Bluetooth |
| Message vocal et pair Wi-Fi Aware disponible | Wi-Fi Aware |
| SOS ou alerte officielle | **Tous les canaux disponibles en même temps** |
| Aucun voisin, boîtier LoRa connecté | LoRa, si le message est éligible (pas de voix) et si le budget d'émission le permet |
| Rien de disponible | Stockage local, envoi dès qu'un canal apparaît |

L'interface affiche seulement un état : « Envoyé », « Relayé par 3 téléphones », « Reçu ». Le canal reste visible dans un détail technique, pas dans le flux.

## 6. Usage collectivités

1. **Relais fixes.** La mairie installe des boîtiers Meshtastic en rôle de routeur sur ses bâtiments (mairie, école, église, château d'eau), alimentés sur secteur avec batterie ou panneau solaire. Ils sont déclarés dans le pack commune (identifiant, position, bâtiment, autonomie) et affichés sur la carte, couche « Relais de la commune ».
2. **Canal d'alertes officielles.** Rédaction réservée à la mairie depuis un téléphone ou une tablette qui détient sa clé de signature, et que l'application protège (Face ID). Les messages des habitants arrivent dans un autre onglet. Les alertes officielles ne se mélangent jamais avec eux.
3. **Une piste de revenu.** Un pack « réseau de secours communal » (étude de couverture, 3 à 10 relais, installation, formation, pack commune) est un vrai produit pour les collectivités, au-delà de la licence de 600 à 1 200 € par an déjà prévue. À chiffrer avec un installateur. Matériel indicatif : 30 à 150 € par relais selon le boîtier et le boîtier étanche [EST, à vérifier].
4. **Gratuité.** Pour l'habitant, toute la messagerie de crise est gratuite, conformément à la règle « tout ce qui protège est gratuit ».

## 7. Batterie

| Mode | Déclenchement | Bluetooth | LoRa |
|---|---|---|---|
| Crise | Choisi par l'utilisateur, ou réception d'un SOS ou d'une alerte officielle | Recherche continue, application à garder ouverte | Connecté en permanence |
| Normal | Application ouverte | Recherche 10 s toutes les 30 s [EST] | Connecté si appairé |
| Veille | Arrière-plan | Ce que le système permet (3.1) | Connecté, réveil par le boîtier |
| Économie | Batterie sous 20 % | Recherche 5 s toutes les 2 min [EST] | Positions désactivées, textes et SOS seulement |

Mesures sur vrais téléphones à l'étape 1, avec un objectif de moins de 5 % de batterie par heure en mode normal [EST, à mesurer].

## 8. Permissions et textes pour l'utilisateur

| Plateforme | Permission | Texte proposé |
|---|---|---|
| iOS | `NSBluetoothAlwaysUsageDescription` | « SIJAMAIS utilise le Bluetooth pour échanger des messages avec les téléphones proches quand il n'y a plus de réseau. » |
| iOS | `NSLocalNetworkUsageDescription` (Wi-Fi Aware) | « Pour envoyer des messages vocaux aux téléphones proches, sans internet. » |
| iOS | `NSLocationWhenInUseUsageDescription` | « Pour joindre votre position à un SOS, seulement quand vous le décidez. » Pas de localisation permanente |
| iOS | `NSMicrophoneUsageDescription` | « Pour enregistrer un message vocal court. » |
| iOS | Modes d'arrière-plan `bluetooth-central` et `bluetooth-peripheral` | À justifier auprès d'Apple lors de la revue |
| Android | `BLUETOOTH_SCAN` (sans localisation), `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT`, `NEARBY_WIFI_DEVICES`, `RECORD_AUDIO`, `POST_NOTIFICATIONS`, service de premier plan « appareil connecté » | Mêmes textes, plus une notification permanente « SIJAMAIS relaie les messages de secours » |

Chaque permission est demandée au moment où elle sert, jamais toutes au démarrage, avec un écran d'explication avant la fenêtre du système.

## 9. Tests

| Niveau | Contenu | Où |
|---|---|---|
| Unitaires | Sérialisation (aller-retour et vecteurs de test), découpage et réassemblage, déduplication, durée de vie et expiration, file de priorités, synchronisation par résumé, signature et vérification, refus d'une fausse alerte officielle, calcul du temps d'émission LoRa | Ordinateur, Linux compris |
| Simulation | 50 à 200 téléphones virtuels sur une topologie aléatoire, pertes de paquets, arrivées et départs : taux de livraison, nombre de relais, délai | Ordinateur |
| Sur appareils | 2 iPhones à 10 m, puis 3 en chaîne hors de portée directe ; 1 iPhone et 2 boîtiers à 1 km ; arrière-plan et écran verrouillé ; batterie sur 3 heures | Mac et appareils réels |

Le README du module (procédure de test avec deux téléphones et un boîtier) sera écrit avec le code de l'étape 1 et complété à l'étape 3.

## 10. Étapes proposées

| Étape | Contenu | Prérequis | Charge [EST] | Critère de fin |
|---|---|---|---|---|
| 0 | Cœur en Swift pur : modèle, format binaire et sa spécification, routage, déduplication, stockage, chiffrement, calcul du temps d'émission LoRa, simulateur, tests | Aucun : **je peux la faire ici, maintenant** | 10 à 15 j | Tous les tests passent ; simulation de 100 téléphones avec plus de 95 % de messages livrés |
| 1 | Bluetooth sur iPhone, interface texte et SOS, permissions, batterie | Mac, 2 iPhones, développeur iOS | 15 à 25 j | Démonstration à 3 iPhones en chaîne, application ouverte |
| 2 | Messages vocaux (Wi-Fi Aware, repli Bluetooth) | Étape 1, iOS 26 | 8 à 12 j | Message de 15 s livré en moins de 10 s entre 2 iPhones |
| 3 | Meshtastic : texte, position, SOS, budget d'émission | Avis de l'avocat (3.3), 2 boîtiers 868 MHz | 12 à 18 j | Échange à 1 km entre 2 iPhones par LoRa, budget respecté |
| 4 | Collectivités : pack commune signé, relais sur la carte, canal officiel | Carte MapLibre de la v1, étape 3 | 10 à 15 j | Une alerte signée de la commune fictive affichée ; une fausse rejetée |
| 5 | Android : cœur porté en Kotlin selon la spécification, Bluetooth, Wi-Fi Aware, service de premier plan | Décision Android | 20 à 40 j | Échange iPhone et Android par Bluetooth |

Total : 75 à 125 jours [EST], soit environ 30 000 à 60 000 € avec un développeur indépendant entre 400 et 500 € par jour [EST, à confirmer par devis]. **C'est hors du budget actuel** (v1 à 6 000 à 8 000 €, 35 000 € de fonds propres consommés dans le scénario central).

Je recommande :
- l'étape 0 tout de suite : sans coût, elle sert de base aux devis et réduit le risque technique ;
- les étapes 1 et 3 comme cœur de la proposition aux communes ;
- les étapes 2, 4 et 5 financées par les premières communes, ou par une aide à l'innovation (Bpifrance, région) à étudier.

Matériel de test : un deuxième iPhone (le premier, à 550 €, est déjà prévu), deux boîtiers 868 MHz, par exemple Heltec V3, RAK WisBlock 4631 ou LilyGO T-Echo, entre 25 et 80 € chacun [EST, à vérifier].

## 11. Décisions à prendre par Benjamin

| N° | Question | Ma recommandation |
|---|---|---|
| R1 | Le module entre-t-il dans la v1, ou dans une v1.1 ? | v1.1. La v1 sort avec l'écran « Bientôt » déjà prévu, et l'étape 0 avance en parallèle |
| R2 | Accepter Wi-Fi Aware à la place de Multipeer et de Wi-Fi Direct ? | Oui (I2) |
| R3 | Accepter que le relais iPhone soit fiable surtout application ouverte, et que LoRa porte l'arrière-plan ? | Oui, c'est une limite d'Apple, pas un choix |
| R4 | Abandonner le canal internet pour l'instant ? | Oui (I3) |
| R5 | Meshtastic : demande d'autorisation, passage en logiciel libre, ou renvoi vers l'application officielle ? | Question à l'avocat et demande écrite à Meshtastic, en parallèle |
| R6 | Lancer l'étape 0 maintenant ? | Oui |
| R7 | Faire du réseau de relais une offre payante pour les communes ? | Oui, à chiffrer avec un installateur |

## Sources

| Source | Apport |
|---|---|
| Forums développeurs Apple, « MultipeerConnectivity background operation for mesh relay ». https://developer.apple.com/forums/thread/836124 | Multipeer ne fonctionne pas en arrière-plan ; dépréciation annoncée dans Xcode 27 (non confirmée) |
| Forums développeurs Apple, « Multipeer Connectivity support ». https://www.developer.apple.com/forums/thread/11964 | Coupure des sessions en arrière-plan, voulue par Apple |
| Heise, « Peer-to-peer WLAN by order of the EU: Apple integrates Wi-Fi Aware ». https://heise.de/-10446649 | Wi-Fi Aware dans iOS 26, exigence européenne |
| MacRumors, « iOS 26 Adding Two New Wi-Fi Features ». https://www.macrumors.com/2025/06/21/ios-26-adding-two-new-wi-fi-features/ | Wi-Fi Aware ouvert aux applications tierces |
| Ditto, « Cross-platform P2P Wi-Fi: how the EU killed AWDL ». https://www.ditto.com/blog/cross-platform-p2p-wi-fi-how-the-eu-killed-awdl | Interopérabilité iPhone et Android à construire par les développeurs |
| Projet bitchat (miroir du README). https://github.com/4uffin/bitchat | Maillage Bluetooth, 7 sauts, stocker et renvoyer, protocole Noise, domaine public. Dépôt officiel à consulter : permissionlesstech/bitchat |
| Meshtastic, documentation de l'API client. https://meshtastic.org/docs/development/device/client-api/ | UUID du service, ToRadio, FromRadio, FromNum, `want_config_id` |
| Meshtastic, protobufs sur JSR. https://jsr.io/@meshtastic/protobufs@2.7.26 | Licence GPL-3.0, ports tiers 64 à 127 |
| Meshtastic-Apple. https://github.com/meshtastic/Meshtastic-Apple | Application iPhone officielle sous GPL v3 |
| Meshtastic, réglages radio. https://meshtastic.org/docs/overview/radio-settings | Région EU_868, 869,525 MHz |
| The Things Network, limites régionales. https://www.thethingsnetwork.org/docs/lorawan/regional-limitations-of-rf-use/ | Sous-bande 869,4 à 869,65 MHz : 10 %, 500 mW |
| Forum Meshtastic, « Duty cycle limits ». https://meshtastic.discourse.group/t/duty-cycle-limits/2567 | Application de la limite par le logiciel des boîtiers non confirmée |
