// Bulletins avalanche de Météo-France, déposés chaque soir sur notre hébergement R2 (28/11/2026).
// Cloudflare Worker déclenché par horaire (voir wrangler.toml). La clé de Météo-France reste ici,
// dans un secret du Worker : elle n'est jamais dans l'application.
//
// Pour chaque massif : GET {API}/massif/BRA?id-massif=<id>&format=xml avec l'en-tête « apikey »,
// puis dépôt dans R2 sous bulletins/BRA-<id>.xml, et un index bulletins/index.json.
// Adresse de l'API : chemin /public/DPBRA/v1 vérifié le 28/11/2026 (le serveur répond « 401, apikey manquante »,
// et 404 pour un chemin inventé) ; le nom exact de la ressource « massif/BRA » est [A VERIFIER] avec la clé.

const API = "https://public-api.meteofrance.fr/public/DPBRA/v1";
const MASSIFS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
  40, 41, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74];
const PAUSE_MS = 1500; // au plus 40 requêtes par minute, sous la limite annoncée du portail [A VERIFIER]

const attendre = (ms) => new Promise((r) => setTimeout(r, ms));

async function recuperer(env) {
  const index = { date: new Date().toISOString(), source: "Météo-France, bulletin d'estimation du risque d'avalanche", massifs: {} };
  for (const id of MASSIFS) {
    try {
      const r = await fetch(`${API}/massif/BRA?id-massif=${id}&format=xml`, { headers: { apikey: env.METEO_FRANCE_CLE } });
      const xml = await r.text();
      // On ne remplace un bulletin que par un vrai bulletin : en cas d'erreur, l'ancien reste en ligne.
      if (r.ok && xml.includes("<BULLETINS_NEIGE_AVALANCHE")) {
        await env.CARTES.put(`bulletins/BRA-${id}.xml`, xml, {
          httpMetadata: { contentType: "application/xml; charset=utf-8", cacheControl: "public, max-age=1800" },
        });
        const validite = (xml.match(/DATEVALIDITE="([^"]+)"/) || [])[1] || "";
        index.massifs[id] = { fichier: `BRA-${id}.xml`, validite };
      } else {
        index.massifs[id] = { erreur: r.status };
      }
    } catch (e) {
      index.massifs[id] = { erreur: String(e).slice(0, 120) };
    }
    await attendre(PAUSE_MS);
  }
  await env.CARTES.put("bulletins/index.json", JSON.stringify(index), {
    httpMetadata: { contentType: "application/json", cacheControl: "public, max-age=1800" },
  });
  return index;
}

export default {
  async scheduled(evenement, env, ctx) {
    // Hors saison (juin à octobre), Météo-France ne publie pas : rien à faire.
    const mois = new Date().getUTCMonth() + 1;
    if (mois >= 6 && mois <= 10) return;
    ctx.waitUntil(recuperer(env));
  },
  // Lancement à la main, pour essayer : https://<worker>/lancer?jeton=<JETON_LANCEMENT>
  async fetch(requete, env) {
    const u = new URL(requete.url);
    if (u.pathname !== "/lancer" || !env.JETON_LANCEMENT || u.searchParams.get("jeton") !== env.JETON_LANCEMENT) {
      return new Response("Rien ici.", { status: 404 });
    }
    const index = await recuperer(env);
    return new Response(JSON.stringify(index, null, 1), { headers: { "content-type": "application/json; charset=utf-8" } });
  },
};
