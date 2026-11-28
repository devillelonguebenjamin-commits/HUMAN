# Bulletins avalanche : service du soir

Chaque soir, de novembre à mai, ce petit service récupère les 36 bulletins d'estimation du risque d'avalanche de Météo-France. Il les dépose dans le bucket R2 `sijamais-cartes`, dossier `bulletins/`. L'application les télécharge à partir de là, puis les lit sans réseau. **La clé de Météo-France n'est jamais dans l'application.**

## 1. Obtenir la clé (Benjamin, une fois)

1. Créer un compte sur le portail des API de Météo-France (portail-api.meteofrance.fr). D'après un fil de data.gouv.fr, la connexion se fait avec le nom d'utilisateur, pas avec l'adresse électronique [A VERIFIER].
2. Dans le catalogue, s'abonner à l'API **« Données Publiques Bulletin Risque Avalanche »** (DonneesPubliquesBRA).
3. Générer une **clé d'API** (« API Key »), avec la durée de validité la plus longue proposée. La noter dans un gestionnaire de mots de passe. **Ne jamais me l'envoyer.**

## 2. Tester la clé sur le Mac

```
cd ~/Documents/GitHub/HUMAN
read -s METEO_FRANCE_CLE && export METEO_FRANCE_CLE   # coller la clé, puis Entrée (rien ne s'affiche)
python3 outils/tester_bulletin_avalanche.py 8          # 8 = Belledonne
```

Le script affiche le risque du jour et dit si l'adresse de l'API est la bonne.

## 3. Installer le service (Cloudflare)

```
npm install -g wrangler
cd ~/Documents/GitHub/HUMAN/serveur/bulletins-avalanche
wrangler login
wrangler secret put METEO_FRANCE_CLE       # coller la clé
wrangler secret put JETON_LANCEMENT        # inventer un mot de passe long, pour le lancement à la main
wrangler deploy
```

Essai immédiat : ouvrir `https://sijamais-bulletins-avalanche.<ton-sous-domaine>.workers.dev/lancer?jeton=<JETON_LANCEMENT>`. Au bout d'une minute environ, la page affiche la liste des massifs. Ensuite, le fichier https://pub-a009b59436594f6aa3b8935a74545011.r2.dev/bulletins/index.json doit exister.

## Coûts et limites

- Workers, offre gratuite : 100 000 requêtes par jour et des déclencheurs horaires [MEMOIRE, à vérifier sur la page des tarifs de Cloudflare]. Ici, 3 passages par jour.
- R2 : 36 petits fichiers (quelques dizaines de Ko chacun), environ 110 écritures par jour, sous l'offre gratuite.
- Météo-France : 36 requêtes par passage, espacées de 1,5 seconde.

## Règles

- Mention « Source : Météo-France » sur chaque bulletin affiché, avec la date de rédaction et de validité.
- Un bulletin périmé est affiché comme tel, jamais comme celui du jour.
