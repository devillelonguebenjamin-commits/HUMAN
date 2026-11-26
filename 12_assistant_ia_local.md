# 12. L'assistant IA local de SIJAMAIS

Rédigé le 26 novembre 2026. Complète `09_application_iphone.md` (section 3) et `prototype/mvp_logiciel/SPECIFICATION.md` (assistant, niveaux 1 à 3). Marqueurs : [FAIT] vérifié ce jour, [A VERIFIER] à confirmer sur la documentation Apple, [EST] estimation, [MEMOIRE] connu sans vérification ce jour.

## 1. Ce qu'on veut

Un assistant qui répond en français à une question posée avec ses mots (« mon voisin ne respire plus », « plus de courant depuis hier »), **sans réseau**, **sans envoyer aucune donnée**, et **uniquement à partir des guides relus** de l'application, en citant le guide utilisé. Ce n'est pas un agent conversationnel généraliste : c'est un moteur de recherche qui sait reformuler.

## 2. Le choix recommandé : le modèle d'Apple intégré à l'iPhone

| Point | Ce qu'on sait | Conséquence |
|---|---|---|
| Accès | Cadre Foundation Models : une API Swift qui donne accès au modèle d'Apple Intelligence, sur l'appareil, gratuit, hors ligne [FAIT, Apple] | Aucun coût par question, aucune donnée transmise : argument décisif face aux mairies |
| Taille de la conversation | 4 096 jetons par session, consignes, question, passages et réponse compris [FAIT, note technique TN3193]. Des outils de comptage existent depuis iOS 26.4 [FAIT] | Trois passages courts par question au maximum. Les guides doivent rester découpés en blocs brefs, ce qui est déjà le cas |
| Réponse structurée | Génération guidée (`@Generable`) : la réponse respecte un format défini dans le code [FAIT] | L'assistant renvoie un texte et la liste des guides cités ; l'application vérifie que chaque guide cité faisait bien partie des passages fournis |
| Outils | Le modèle peut appeler du code de l'application, idéalement 3 à 5 outils [FAIT] | Pas nécessaire en v1 : la recherche se fait avant, dans le code, de façon déterministe |
| Garde-fous | Apple filtre certaines questions et réponses (violence, automutilation) et le modèle peut refuser des sujets sensibles, avec ou sans erreur [FAIT, documentation Apple] | Risque réel : refus sur « attaque terroriste » ou des questions de secours. Prévu : en cas de refus, l'application affiche les passages du guide sans reformulation (section 3) |
| Français | Le modèle gère plusieurs langues ; la liste exacte n'a pas été retrouvée ce jour [A VERIFIER] | À vérifier avant tout développement, et à mesurer sur 30 questions (plan de 30 jours, jour 7) |
| iPhones compatibles | Ceux qui ont Apple Intelligence : iPhone 15 Pro et suivants [MEMOIRE], avec la fonction activée dans les réglages | Une part importante des iPhones en circulation ne l'a pas : il faut une version sans IA (section 3) |
| Nouveautés iOS 27 | Entrée d'images sur l'appareil, et accès gratuit à un modèle plus puissant dans le nuage d'Apple (Private Cloud Compute) pour les petits développeurs [A VERIFIER, sources secondaires] | Le modèle dans le nuage **demande du réseau** : hors sujet pour l'usage de crise. Option à étudier seulement pour le premium, désactivée par défaut. Images : pas de reconnaissance de plantes ni de blessures (décision 30 de la maquette) |

### Alternative écartée pour la v1 : embarquer notre propre modèle

Un petit modèle ouvert (1 à 3 milliards de paramètres) tournerait sur tous les iPhones récents, mais : 1 à 2 Go de téléchargement en plus, une consommation de batterie élevée, un français moins sûr à cette taille, des licences à vérifier une par une, et un travail d'intégration bien plus lourd [EST]. À reconsidérer seulement si la part d'iPhones compatibles se révèle trop faible.

## 3. Fonctionnement : trois niveaux, une seule règle

**Règle : l'assistant ne dit rien qui ne soit pas dans un guide.**

| Niveau | Quand | Ce qui se passe |
|---|---|---|
| 1. Recherche dans les guides | Toujours, sur **tous** les iPhones | La question est comparée aux guides (recherche plein texte SQLite, synonymes du langage courant). Les 3 meilleurs passages sont retenus |
| 2. Reformulation par le modèle d'Apple | iPhone compatible, sujet non sensible | Le modèle reçoit les consignes et les 3 passages, et rédige une réponse courte avec la liste des guides cités. L'application vérifie les citations ; en cas de doute, de refus ou d'erreur, elle affiche le niveau 1 |
| 3. Sujet de santé ou d'urgence vitale | Mots du type « respire », « saigne », « inconscient », « brûlure » | **Pas de génération.** Bandeau « Appelez le 15 ou le 112 », puis les étapes exactes du guide relu |

Sans passage pertinent : « Je n'ai pas trouvé de guide sur ce sujet », avec des suggestions. Jamais d'invention.

Consignes données au modèle (projet) : « Tu réponds en français, en 5 phrases au plus, uniquement à partir des passages fournis. Si les passages ne répondent pas à la question, dis-le. Tu cites l'identifiant de chaque guide utilisé. Tu ne donnes aucun conseil médical au-delà des passages. »

## 4. Gratuit ou premium

Conformément à la décision 29 de la maquette : l'assistant est **gratuit pour toutes les questions de sécurité**, puisqu'il ne coûte rien par question. Le premium porte sur les questions liées aux contenus de loisir (randonnée, mer, voyage), quand ces contenus existeront.

## 5. Mesure avant développement

| Test | Seuil | Quand |
|---|---|---|
| 30 questions courantes sur un iPhone compatible, avec les passages fournis | 27 réponses correctes et sourcées | Jour 7 du plan de 30 jours (`plan_30_jours.md`) |
| 20 questions de santé | 20 sur 20 traitées en niveau 3, sans génération | Avec la maquette de recherche |
| Refus du modèle | Taux mesuré ; chaque refus doit tomber proprement en niveau 1 | Même séance |
| Questions hors sujet ou pièges (« quel champignon puis-je manger ? ») | Aucune invention | Même séance |

Ces tests exigent un iPhone 15 Pro ou plus récent (achat prévu, 550 € d'occasion).

## 6. Dans la maquette

L'écran Assistant de la maquette est désormais interactif : il cherche dans les 46 guides et affiche les passages retrouvés, le guide cité et le bandeau d'urgence pour les questions de santé. **C'est une simulation du niveau 1** : dans l'application, sur un iPhone compatible, le modèle d'Apple reformulera ces passages (niveau 2). Le panneau de gauche permet de simuler un iPhone non compatible.

## 7. Décisions à prendre

| N° | Question | Recommandation |
|---|---|---|
| IA1 | Modèle d'Apple seul en v1, sans modèle embarqué ? | Oui |
| IA2 | Règle « rien qui ne soit pas dans un guide » ? | Oui, non négociable pour être recommandé par une mairie |
| IA3 | Modèle d'Apple dans le nuage pour le premium, quand il y a du réseau ? | Non en v1. À rediscuter |
| IA4 | Acheter l'iPhone de test pour mesurer avant de développer ? | Oui, avant le devis du développeur |

## Sources

| Source | Apport |
|---|---|
| Apple, documentation Foundation Models. https://developer.apple.com/documentation/foundationmodels | API, génération guidée, outils |
| Apple, TN3193 « Managing the on-device foundation model's context window ». https://developer.apple.com/tutorials/data/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window.md | 4 096 jetons, 3 à 5 outils |
| Apple, « Improving the safety of generative model output ». https://developer.apple.com/tutorials/data/documentation/foundationmodels/improving-the-safety-of-generative-model-output.md | Garde-fous, refus possibles |
| Apple, WWDC26, session 241. https://developer.apple.com/videos/play/wwdc2026/241/ | Modèle dans le nuage, 32 000 jetons, comptage depuis iOS 26.4 |
| MacRumors, « Apple Outlines Major AI and Developer Tool Updates at 2026 Platforms State of the Union ». https://macrumors.com/2026/06/09/apple-outlines-major-ai-and-developer-tool-updates | Accès gratuit au nuage pour les petits développeurs (source secondaire) |
| Forum développeurs Apple, « Model w/ Guardrails Disabled Still Frequently Refuses to Summarize Text ». https://developer.apple.com/forums/thread/797955 | Refus fréquents signalés |
