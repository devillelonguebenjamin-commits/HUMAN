#!/usr/bin/env python3
"""Intègre contenus/guides/guides_v1.2.json dans la maquette prototype/maquette_app/index.html.

Génère un écran « Guides », un écran par catégorie et un écran par guide, en HTML
statique : la navigation fonctionne sans JavaScript, par liens internes.
Le script est rejouable : il remplace ce qu'il a généré la fois précédente.

Usage : python3 outils/integrer_guides_maquette.py
"""
import base64
import html
import json
import re
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
GUIDES = RACINE / "contenus" / "guides" / "guides_v1.2.json"
MAQUETTE = RACINE / "prototype" / "maquette_app" / "index.html"

d = json.loads(GUIDES.read_text(encoding="utf-8"))
SOURCES = d["meta"]["sources"]
e = html.escape

ICONE_CAT = {"urgence": ("croix", "c-r"), "preparer": ("kit", "c-f"), "survie": ("tente", "c-g"), "apres": ("abri", "c-b"), "mairie": ("mairie", "c-f")}


def ic(n):
    return f'<svg aria-hidden="true"><use href="#p-{n}"/></svg>'


def pico(n, c):
    return f'<span class="pico {c}">{ic(n)}</span>'


def badge(x):
    if x["niveau"] == "officiel":
        return '<span class="pill gratuit">Consigne officielle</span>'
    return '<span class="pill bientot">Conseil pratique</span>'


def bloc(gid, b, n):
    t = b.get("t")
    titre = f'<h3>{e(b["titre"])}</h3>' if b.get("titre") else ""
    if t == "text":
        return f'{titre}<div class="carte"><p class="g-p">{e(b["body"])}</p></div>'
    if t == "alert":
        return f'<div class="g-alert">{pico("coupure", "c-j")}<span>{e(b["body"])}</span></div>'
    if t == "tip":
        return f'<div class="carte g-tip"><b>Bon à savoir</b><p class="g-p">{e(b["body"])}</p></div>'
    if t == "steps":
        lignes = "".join(f'<div class="etape"><span class="num">{i}</span><div>{e(it)}</div></div>' for i, it in enumerate(b["items"], 1))
        return f'{titre}<div class="carte">{lignes}</div>'
    if t in ("list", "risk"):
        li = "".join(f"<li>{e(it)}</li>" for it in b["items"])
        if t == "risk":
            return f'<div class="carte"><b>{e(b["titre"])}</b><ul class="g-ul">{li}</ul></div>'
        return f'{titre}<div class="carte"><ul class="g-ul">{li}</ul></div>'
    if t == "check":
        li = "".join(f'<button class="ligne" onclick="cocher(this)"><span class="check"></span><span class="t">{e(it)}</span></button>' for it in b["items"])
        return f'{titre}<div class="liste">{li}</div>'
    if t == "kv":
        li = "".join(f'<div class="ligne"><span class="t"><b>{e(k)}</b><div class="s">{e(v)}</div></span></div>' for k, v in b["items"])
        return f'{titre}<div class="liste">{li}</div>'
    if t == "numbers":
        li = "".join(f'<div class="ligne"><span class="g-num">{e(it["n"])}</span><span class="t"><b>{e(it["label"])}</b><div class="s">{e(it["desc"])}</div></span></div>' for it in b["items"])
        return f'{titre}<div class="liste">{li}</div>'
    if t == "plant":
        li = "".join(f'<div class="ligne"><span class="t"><b>{e(k)}</b><div class="s">{e(v)}</div></span></div>' for k, v in b["items"])
        return f'<h3>{e(b["titre"])}</h3><div class="liste">{li}</div>'
    if t == "dodont":
        li = "".join(f"<li>{e(it)}</li>" for it in b.get("dont", []))
        return f'{titre}<div class="carte"><ul class="g-ul g-non">{li}</ul></div>'
    if t == "form":
        champs = "".join(f'<label class="g-label" for="f-{gid}-{n}-{i}">{e(c)}</label><input class="g-input" id="f-{gid}-{n}-{i}" type="text" autocomplete="off">' for i, c in enumerate(b["fields"]))
        return f'{titre}<div class="carte">{champs}<p class="mini" style="margin-top:8px">Enregistré seulement sur ce téléphone.</p></div>'
    if t == "calc":
        return (f'{titre}<div class="carte"><p class="g-p">{e(b["body"])}</p>'
                f'<label class="g-label" for="c-{gid}-{n}">Personnes dans le foyer</label>'
                f'<input class="g-input" id="c-{gid}-{n}" type="number" min="1" value="3" data-par="{b["parPersonne"]}" data-unite="{e(b["unite"])}" oninput="calcGuide(this)">'
                f'<p class="g-res" id="r-c-{gid}-{n}">{3 * b["parPersonne"]} {e(b["unite"])} à stocker</p></div>')
    if t == "schema":
        svg = (RACINE / "contenus" / "guides" / "schemas" / b["fichier"]).read_bytes()
        src = "data:image/svg+xml;base64," + base64.b64encode(svg).decode()
        return (f'<figure class="g-fig"><img src="{src}" alt="{e(b["alt"])}" loading="lazy">'
                f'<figcaption>{e(b["titre"])}</figcaption></figure>')
    raise ValueError(f"bloc inconnu : {t}")


def ecran_guide(x):
    gid = x["id"]
    cat = x["cat"]
    tete = f'<div class="g-tete">{badge(x)}<span class="mini">{e(x["duree"])} de lecture</span></div>'
    urgence = ""
    if x.get("sensible"):
        urgence = ('<div class="bandeau c-r g-urg">' + ic("croix") + '<div style="flex:1"><b>Urgence vitale</b><span>114 par SMS</span></div>'
                   '<button class="g-appel" onclick="toast(\'Appel du 15 (démonstration)\')">15</button><button class="g-appel" onclick="toast(\'Appel du 112 (démonstration)\')">112</button></div>')
    corps = "".join(bloc(gid, b, n) for n, b in enumerate(x["blocs"]))
    srcs = "".join(f'<li>{e(SOURCES[s]["titre"])}, {e(SOURCES[s]["editeur"])}{", " + e(SOURCES[s]["date"]) if SOURCES[s]["date"] else ""}</li>' for s in x["sources"])
    verif = ""
    if x.get("a_verifier"):
        verif = '<div class="fictif">À vérifier avant diffusion : ' + " ; ".join(e(v) for v in x["a_verifier"]) + "</div>"
    return (f'<section class="ecran" id="e-g-{gid}">\n'
            f'      <a class="retour" href="#e-cat-{cat}">‹ {e(CATS[cat]["titre"])}</a>\n'
            f'      <h2>{e(x["titre"])}</h2>{tete}<p class="g-resume">{e(x["resume"])}</p>{urgence}{corps}'
            f'<h3>Sources</h3><ul class="g-ul g-src">{srcs}</ul>'
            f'<p class="source">Version {e(x["version"])} du {e(x["maj"])} · non relue par un professionnel</p>{verif}\n'
            f'    </section>')


CATS = {c["id"]: c for c in d["categories"]}
# Pictogramme propre à certains guides, selon le code couleur de la signalétique.
ICONE_GUIDE = {"alerte": ("sirene", "c-j"), "reflexes": ("sirene", "c-j"), "abri-evacuation": ("sortie", "c-v"), "risques": ("coupure", "c-j"),
               "monoxyde": ("coupure", "c-j"), "coupure-electricite": ("eclair", "c-j"), "canicule": ("thermo", "c-o"), "grand-froid": ("thermo", "c-b"),
               "kit72h": ("kit", "c-f"), "pfms": ("famille", "c-v"), "plan-evacuation": ("sortie", "c-v"), "communication": ("bulle", "c-b"),
               "desinformation": ("bulle", "c-b"), "engagement": ("famille", "c-v"), "incendie-domicile": ("flamme", "c-o"), "eau": ("goutte", "c-b"),
               "feu": ("flamme", "c-o"), "orientation": ("carte", "c-g"), "documents": ("doc", "c-g"), "assurance": ("doc", "c-b"), "retour": ("abri", "c-b"),
               "cyberattaque": ("cadenas", "c-b"), "cyberattaque-commune": ("cadenas", "c-f")}
PILL = {"officiel": '<span class="pill gratuit">Officiel</span>', "pratique": '<span class="pill bientot">Pratique</span>'}
par_cat = {c: [x for x in d["guides"] if x["cat"] == c] for c in CATS}

ecrans = []
# Catalogue
tuiles = "".join(f'<a class="sg {ICONE_CAT[c][1]}" href="#e-cat-{c}">{ic(ICONE_CAT[c][0])}<div><b>{e(CATS[c]["titre"])}</b><span>{len(par_cat[c])} guides</span></div></a>' for c in CATS if c != "mairie")
ecrans.append(f'''<section class="ecran" id="e-guides">
      <a class="retour" href="#e-savoir">‹ Savoir</a>
      <h2>Guides</h2>
      <p class="mini" style="margin-bottom:12px">{e(d["meta"]["avertissement"])} Tous les guides sont gratuits.</p>
      <div class="grille g2">{tuiles}</div>
      <a class="liste" href="#e-cat-mairie"><div class="ligne">{pico("mairie", "c-f")}<span class="t"><b>Espace mairie</b><div class="s">Pour les élus et agents : poste de commandement, communication de crise</div></span><span class="chev">›</span></div></a>
    </section>''')
for c, liste in par_cat.items():
    n, coul = ICONE_CAT[c]
    lignes = "".join(
        f'<a class="ligne" href="#e-g-{x["id"]}">{pico("croix", "c-r") if x.get("sensible") or x["id"] in ("numeros", "trousses") else pico(*ICONE_GUIDE.get(x["id"], (n, coul)))}<span class="t">{e(x["titre"])}<div class="s">{e(x["resume"])}</div></span>{PILL[x["niveau"]]}</a>'
        for x in liste)
    ecrans.append(f'''<section class="ecran" id="e-cat-{c}">
      <a class="retour" href="#e-guides">‹ Guides</a>
      <h2>{e(CATS[c]["titre"])}</h2>
      <p class="mini" style="margin-bottom:12px">{e(CATS[c]["desc"])}</p>
      <div class="liste">{lignes}</div>
    </section>''')
for x in d["guides"]:
    ecrans.append(ecran_guide(x))

bloc_html = "<!-- GUIDES:DEBUT (généré par outils/integrer_guides_maquette.py) -->\n    " + "\n    ".join(ecrans) + "\n    <!-- GUIDES:FIN -->\n    "
css = """/* GUIDES:CSS:DEBUT */
.g-tete{display:flex;gap:8px;align-items:center;margin:-6px 0 8px}
.g-resume{color:var(--texte2);margin-bottom:12px}
.g-p{font-size:14.5px}
.g-ul{padding-left:18px;display:flex;flex-direction:column;gap:6px;font-size:14.5px}
.g-non li::marker{content:"✕  ";color:#C8102E}
.g-src{font-size:12px;color:var(--texte2);margin-bottom:6px}
.g-alert{border:1.5px solid #C8102E;border-radius:14px;padding:12px;font-weight:600;font-size:14.5px;margin-bottom:10px;display:flex;gap:10px;align-items:flex-start}
.g-tip{border-left:4px solid #00843D}
.g-fig{background:#FFFFFF;border-radius:16px;padding:8px;margin:0 0 12px}
.g-fig img{display:block;width:100%;height:auto}
.g-fig figcaption{font-size:12px;color:#4E5E54;text-align:center;padding:4px 0 2px}
.g-urg{align-items:center}
.g-appel{background:#fff;color:#C8102E;font-weight:800;font-size:18px;border-radius:12px;padding:8px 12px;min-width:56px;text-align:center}
.g-num{font-size:22px;font-weight:800;color:#C8102E;min-width:64px}
:root:not([data-theme="light"]) .g-num{color:#FF5A6E}
.g-label{display:block;font-size:12.5px;color:var(--texte2);margin:8px 0 4px}
.g-input{width:100%;background:var(--bg);border:1px solid var(--ligne);border-radius:10px;padding:9px 10px;color:var(--texte);font:inherit}
.g-res{font-weight:700;margin-top:8px}
/* GUIDES:CSS:FIN */
"""
js = """/* GUIDES:JS:DEBUT */
function calcGuide(i){ const n=Math.max(1,parseInt(i.value||'1',10)); document.getElementById('r-'+i.id).textContent=(n*Number(i.dataset.par))+' '+i.dataset.unite+' à stocker'; }
/* GUIDES:JS:FIN */
"""

s = MAQUETTE.read_text(encoding="utf-8")
s = re.sub(r"<!-- GUIDES:DEBUT.*?<!-- GUIDES:FIN -->\n    ", "", s, flags=re.S)
s = re.sub(r"/\* GUIDES:CSS:DEBUT \*/.*?/\* GUIDES:CSS:FIN \*/\n", "", s, flags=re.S)
s = re.sub(r"/\* GUIDES:JS:DEBUT \*/.*?/\* GUIDES:JS:FIN \*/\n", "", s, flags=re.S)
s = s.replace('<div class="toast" id="toast"></div>', bloc_html + '<div class="toast" id="toast"></div>', 1)
s = s.replace("@media (max-width:860px){", css + "@media (max-width:860px){", 1)
i_fin = s.rindex("</script>")
s = s[:i_fin] + js + s[i_fin:]

# Entrée « Guides » dans l'écran Savoir, juste avant les sources officielles.
entree = '<a class="bandeau c-f" href="#e-guides" id="lien-guides">' + ic("livre") + '<div><b>Guides de survie</b><span>' + str(len(d["guides"])) + ' guides gratuits, consultables sans réseau</span></div></a>\n      '
s = re.sub(r'<a class="bandeau c-f" href="#e-guides" id="lien-guides">.*?</a>\n      ', "", s, flags=re.S)
s = s.replace("<h3>Sources officielles</h3>", entree + "<h3>Sources officielles</h3>", 1)

# Écran Urgence : les premiers secours et les scénarios mènent aux guides.
# Remplacements limités à l'écran Urgence, avec un motif exact (aucun saut de ligne à ligne).
a = s.index('<section class="ecran" id="e-urgence">')
b = s.index("</section>", a)
urg = s[a:b]
PICO_CROIX = '<span class="pico c-r"><svg aria-hidden="true"><use href="#p-croix"/></svg></span><span class="t">'
for ancien, cible in [("Arrêt cardiaque<div", "arret-cardiaque"), ("Saignement abondant", "saignement"), ("Personne inconsciente qui respire", "inconscient-respire"), ("Brûlure", "brulure")]:
    urg, nb = re.subn(r'<a class="ligne" href="#e-[a-z-]+">' + re.escape(PICO_CROIX + ancien), f'<a class="ligne" href="#e-g-{cible}">' + PICO_CROIX + ancien, urg)
    assert nb == 1, (ancien, nb)
s = s[:a] + urg + s[b:]
s = re.sub(r'<a class="sg c-j" href="#e-(?:scenario|g-[a-z-]+)">(<svg aria-hidden="true"><use href="#p-coupure"/></svg><div><b>Coupure d)',
           r'<a class="sg c-j" href="#e-g-coupure-electricite">\1', s, count=1)
s = re.sub(r'<a class="sg (c-[a-z]) href="#e-scenario">', r'<a class="sg \1" href="#e-g-risques">', s)
s = s.replace('<a class="sg c-j" href="#e-scenario">', '<a class="sg c-j" href="#e-g-risques">')
s = s.replace('<a class="sg c-b" href="#e-scenario">', '<a class="sg c-b" href="#e-g-risques">')
s = s.replace('<a class="sg c-o" href="#e-scenario">', '<a class="sg c-o" href="#e-g-risques">')
s = s.replace('<a class="sg c-n" href="#e-scenario">', '<a class="sg c-n" href="#e-g-risques">')
s = s.replace('<a class="sg c-v" href="#e-scenario">', '<a class="sg c-v" href="#e-g-abri-evacuation">')
# Les réflexes : le guide officiel de 2025 en compte 7.
s = s.replace('<a class="bandeau c-j" href="#e-reflexes">', '<a class="bandeau c-j" href="#e-g-reflexes">')
s = s.replace("<span>Les 6 réflexes officiels</span>", "<span>Les 7 réflexes du guide officiel</span>")
s = s.replace('<a class="sg c-j" href="#e-reflexes"><svg aria-hidden="true"><use href="#p-sirene"/></svg><div><b>Alerte et 6 réflexes</b>', '<a class="sg c-j" href="#e-g-reflexes"><svg aria-hidden="true"><use href="#p-sirene"/></svg><div><b>Alerte et 7 réflexes</b>')

# Deux tuiles de plus dans « Que se passe-t-il ? » : cyberattaque et monoxyde de carbone.
TUILE_EVAC = '<a class="sg c-v" href="#e-g-abri-evacuation"><svg aria-hidden="true"><use href="#p-sortie"/></svg><div><b>Évacuation</b><span>partir vite et bien</span></div></a>'
NOUVELLES = ('<a class="sg c-b" href="#e-g-cyberattaque"><svg aria-hidden="true"><use href="#p-cadenas"/></svg><div><b>Cyberattaque</b><span>rançon, piratage, arnaque</span></div></a>'
             '<a class="sg c-j" href="#e-g-monoxyde"><svg aria-hidden="true"><use href="#p-coupure"/></svg><div><b>Monoxyde de carbone</b><span>gaz invisible, mortel</span></div></a>')
s = s.replace(NOUVELLES, "")
assert TUILE_EVAC in s
s = s.replace(TUILE_EVAC, TUILE_EVAC + NOUVELLES, 1)

# ---------- Assistant : simulation du niveau 1 (recherche dans les guides) ----------
def textes(b):
    out = []
    for k in ("body",):
        if b.get(k):
            out.append(b[k])
    for it in b.get("items", []):
        if isinstance(it, str):
            out.append(it)
        elif isinstance(it, list):
            out.append(" : ".join(it))
        elif isinstance(it, dict):
            out.append(f'{it.get("n", "")} {it.get("label", "")} : {it.get("desc", "")}')
    for it in b.get("dont", []):
        out.append(it)
    return out

index = []
for x in d["guides"]:
    morceaux = []
    for b in x["blocs"]:
        for t in textes(b):
            morceaux.append({"bloc": b.get("titre", ""), "t": t})
    etapes = next((b["items"] for b in x["blocs"] if b.get("t") == "steps"), [])
    index.append({"id": x["id"], "titre": x["titre"], "resume": x["resume"], "niveau": x["niveau"], "sensible": bool(x.get("sensible")), "etapes": etapes, "m": morceaux})
index_json = json.dumps(index, ensure_ascii=False).replace("</", "<\\/")

GROUPES = [
    ("Urgence", "c-r", ["Mon voisin ne respire plus", "Il s'étouffe avec un bonbon", "La sirène sonne, que faire ?"]),
    ("Coupures et crises", "c-j", ["Plus de courant depuis hier", "Mon ordinateur demande une rançon", "Il fait 40 degrés chez moi"]),
    ("Se préparer", "c-f", ["Que mettre dans le kit ?", "Comment couper le gaz ?", "Combien d'eau stocker ?"]),
    ("Dehors, sans réseau", "c-g", ["Comment rendre l'eau potable ?", "Trouver le nord sans boussole"]),
    ("Après la crise", "c-b", ["Délai pour déclarer à l'assurance"]),
]
groupes = "".join(
    f'<div class="ia-groupe"><span class="ia-lab {c}">{e(t)}</span><div class="puces">'
    + "".join(f'<button class="puce" onclick="demander(this.textContent)">{e(q)}</button>' for q in qs)
    + "</div></div>" for t, c, qs in GROUPES)
BUL = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"><path d="M4 5h16v11H10l-5 4v-4H4z"/><circle cx="9" cy="10.5" r=".9" fill="currentColor"/><circle cx="12" cy="10.5" r=".9" fill="currentColor"/><circle cx="15" cy="10.5" r=".9" fill="currentColor"/></svg>'
MICRO = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>'
assistant = f"""<section class="ecran" id="e-assistant">
      <div class="ia-tete"><span class="ia-logo">{BUL}</span><div><h2 style="margin:0">Assistant</h2><div class="ia-etat" id="ia-etat"><span class="ia-point"></span><span id="ia-etat-txt">Modèle d'Apple, sur cet iPhone · hors ligne</span></div></div></div>
      <div id="ia-fil"><div class="bulle ia">Bonjour. Posez votre question avec vos mots : je cherche dans les {len(d["guides"])} guides de l'application et je cite toujours ma source. Pour une urgence vitale, appelez d'abord le 15 ou le 112.</div></div>
      <form class="saisie ia-saisie" onsubmit="event.preventDefault();demander(document.getElementById('ia-q').value)">
        <input id="ia-q" class="g-input" type="text" placeholder="Que voulez-vous savoir ?" autocomplete="off" aria-label="Votre question">
        <button type="button" class="ia-micro" aria-label="Dicter" onclick="toast('Dictée de l\\'iPhone : fonctionne sans réseau sur les modèles récents.')">{MICRO}</button>
        <button class="btn btn-p ia-envoi" type="submit">Envoyer</button>
      </form>
      <h3>Questions fréquentes</h3>
      {groupes}
      <h3>Comment je fonctionne</h3>
      <div class="liste">
        <div class="ligne"><span class="pico c-f"><svg aria-hidden="true"><use href="#p-livre"/></svg></span><span class="t">Je cherche dans les guides<div class="s">Uniquement dans les {len(d["guides"])} guides relus de l'application</div></span></div>
        <div class="ligne"><span class="pico c-b"><svg aria-hidden="true"><use href="#p-bulle"/></svg></span><span class="t">Je reformule sur votre iPhone<div class="s">Avec le modèle d'Apple, sans internet. Sur les iPhone plus anciens : les passages du guide</div></span></div>
        <div class="ligne"><span class="pico c-g"><svg aria-hidden="true"><use href="#p-cadenas"/></svg></span><span class="t">Rien ne quitte votre téléphone<div class="s">Aucune question n'est envoyée ni conservée ailleurs</div></span></div>
        <div class="ligne"><span class="pico c-r"><svg aria-hidden="true"><use href="#p-croix"/></svg></span><span class="t">Santé : jamais d'improvisation<div class="s">Je vous renvoie au 15 ou au 112 et j'affiche les gestes du guide, mot pour mot</div></span></div>
      </div>
      <p class="mini" style="margin-top:10px">Maquette : la recherche dans les guides est réelle ; la reformulation par le modèle d'Apple sera ajoutée dans l'application.</p>
      <script type="application/json" id="guides-index">{index_json}</script>
    </section>"""
s = re.sub(r'<section class="ecran" id="e-assistant">.*?</section>', lambda m: assistant, s, count=1, flags=re.S)

css_ia = """/* IA:CSS:DEBUT */
.ia-etat{display:inline-flex;align-items:center;gap:8px;font-size:12.5px;padding:6px 10px;border-radius:20px;background:var(--surface)}
.ia-point{width:8px;height:8px;border-radius:50%;background:var(--ok)}
.ia-etat.off .ia-point{background:var(--alerte)}
.puces{display:flex;flex-wrap:wrap;gap:6px;margin:8px 0}
.puce{font-size:12.5px;border:1px solid var(--ligne);border-radius:16px;padding:6px 10px;background:var(--surface)}
.bulle .ia-src{display:flex;gap:6px;align-items:center;flex-wrap:wrap;margin-top:8px;font-size:12px}
.bulle .ia-src a{color:var(--accent);font-weight:600}
.bulle ul,.bulle ol{padding-left:18px;margin-top:6px;display:flex;flex-direction:column;gap:4px}
.ia-tete{display:flex;gap:12px;align-items:center;margin:8px 0 14px}
.ia-logo{width:52px;height:52px;border-radius:16px;background:var(--accent);color:var(--accent-texte);display:flex;align-items:center;justify-content:center;flex:none}
.ia-logo svg{width:30px;height:30px}
.ia-tete .ia-etat{margin-top:4px}
.ia-saisie{align-items:center;background:var(--surface);border:1.5px solid var(--accent);border-radius:18px;padding:6px;margin:10px 0 6px}
.ia-saisie .g-input{border:0;background:transparent}
.ia-micro{width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;color:var(--texte2);flex:none}
.ia-micro svg{width:22px;height:22px}
.ia-envoi{width:auto!important;padding:10px 14px!important;border-radius:14px!important}
.ia-groupe{margin-bottom:8px}
.ia-lab{display:inline-block;font-size:11px;font-weight:700;padding:3px 8px;border-radius:8px;margin-bottom:2px}
.bulle .ia-urg{background:#C8102E;color:#fff;border-radius:10px;padding:8px 10px;font-weight:700;margin-bottom:8px}
/* IA:CSS:FIN */
"""
s = re.sub(r"/\* IA:CSS:DEBUT \*/.*?/\* IA:CSS:FIN \*/\n", "", s, flags=re.S)
s = s.replace("@media (max-width:860px){", css_ia + "@media (max-width:860px){", 1)

js_ia = r"""/* IA:JS:DEBUT */
let iaCompatible=true, iaIndex=null;
const IA_VIDES=new Set('a au aux avec ce ces cet cette comment dans de des du elle en est et il ils j je l la le les leur lui ma mais me mes moi mon ne nos notre nous on ou par pas pour qu que quel quelle quels quelles qui quoi sa se ses si son sur ta te tes toi ton tu un une vos votre vous y d c s n m t faire fait faut dois doit peut peux suis sont etre avoir ai a ont quand plus tout tous toute depuis hier aujourd hui chez quoi faire'.split(' '));
const IA_SYN={courant:['electricite','coupure'],lumiere:['electricite','coupure'],panne:['coupure','electricite'],respire:['respirer','arret','cardiaque','massage'],respirer:['arret','cardiaque'],saigne:['saignement','plaie'],sang:['saignement'],evanoui:['inconsciente'],repond:['inconsciente'],sirene:['alerte','signal','sirene'],sonne:['sirene','alerte'],rancon:['rancon','bloque'],ordinateur:['appareil','rancon'],pirate:['piratage','compte'],arnaque:['arnaques','suspect'],potable:['purifier','eau','bouillir'],boire:['eau'],kit:['kit','urgence'],sac:['kit','sac'],chaud:['canicule','chaleur'],chaleur:['canicule'],degres:['canicule','chaleur'],froid:['grand','froid'],nord:['orientation','nord'],perdu:['orientation'],inondation:['inondation'],monte:['inondation','crue','hauteur'],gaz:['reseaux','arrivees','couper'],couper:['reseaux','arrivees'],crue:['inondation'],deborde:['inondation','crue'],eau:['eau'],feu:['feu'],brule:['brulure'],etouffe:['etouffement'],avale:['etouffement'],assurance:['assurance','catastrophe'],iode:['iode','nucleaire'],seisme:['seisme'],tempete:['tempete']};
const IA_SENS=['respire','respirer','saigne','saignement','sang','inconscient','inconsciente','evanoui','evanouie','brule','brulure','etouffe','etouffement','malaise','douleur','poitrine','fracture','avale','poison','convulse','convulsion'];
function iaNorm(t){return t.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g,'').replace(/[^a-z0-9 ]/g,' ');}
function iaMots(t){return iaNorm(t).split(/\s+/).filter(w=>w.length>1&&!IA_VIDES.has(w));}
function iaRacine(w){return w.length>5?w.slice(0,w.length-1).replace(/(e|s|x)$/,''):w;}
function iaChercher(q){
  if(!iaIndex) iaIndex=JSON.parse(document.getElementById('guides-index').textContent).map(g=>({...g,_t:iaNorm(g.titre+' '+g.resume),_m:g.m.map(m=>({...m,_n:iaNorm(m.bloc+' '+m.t)}))}));
  let mots=iaMots(q); const ext=[...mots]; mots.forEach(w=>(IA_SYN[w]||[]).forEach(x=>ext.push(x)));
  const racines=[...new Set(ext.map(iaRacine))];
  let meilleur=null;
  for(const g of iaIndex){
    const sc=g._m.map((m,i)=>({m:g.m[i],s:racines.reduce((a,r)=>a+(m._n.includes(r)?1:0),0)})).sort((a,b)=>b.s-a.s);
    const titre=racines.reduce((a,r)=>a+(g._t.includes(r)?2:0),0);
    const total=titre+sc.slice(0,3).reduce((a,x)=>a+x.s,0);
    if(!meilleur||total>meilleur.total) meilleur={g,total,top:sc.filter(x=>x.s>0).slice(0,3).map(x=>x.m).sort((a,b)=>g.m.indexOf(a)-g.m.indexOf(b))};
  }
  const sensible=mots.some(w=>IA_SENS.some(s=>w.startsWith(s)));
  return {meilleur:(meilleur&&meilleur.total>=3)?meilleur:null,sensible};
}
function iaEsc(t){const d=document.createElement('div');d.textContent=t;return d.innerHTML;}
function demander(q){
  q=(q||'').trim(); if(!q) return;
  const fil=document.getElementById('ia-fil'); const champ=document.getElementById('ia-q'); champ.value='';
  fil.insertAdjacentHTML('beforeend','<div class="bulle moi">'+iaEsc(q)+'</div>');
  const r=iaChercher(q); let h='';
  if(r.sensible) h+='<div class="ia-urg">Urgence vitale : appelez le 15 ou le 112 (114 par SMS)</div>';
  if(!r.meilleur){ h+="Je n'ai pas trouvé de guide sur ce sujet. Je ne réponds qu'à partir des guides de l'application. Essayez avec d'autres mots, ou ouvrez la liste des guides."+'<div class="ia-src"><a href="#e-guides">Voir les guides</a></div>'; }
  else{
    const g=r.meilleur.g;
    const mode=r.sensible?"Étapes du guide relu, sans reformulation :":(iaCompatible?"D'après le guide, voici l'essentiel (dans l'application, le modèle d'Apple rédigera cette réponse) :":"Passages du guide trouvés pour vous :");
    const lignes=(r.sensible&&g.etapes.length)?g.etapes:r.meilleur.top.map(m=>m.t);
    h+=iaEsc(mode)+(r.sensible&&g.etapes.length?'<ol>':'<ul>')+lignes.map(t=>'<li>'+iaEsc(t)+'</li>').join('')+(r.sensible&&g.etapes.length?'</ol>':'</ul>');
    h+='<div class="ia-src"><span class="pill '+(g.niveau==='officiel'?'gratuit">Consigne officielle':'bientot">Conseil pratique')+'</span><a href="#e-g-'+g.id+'">Ouvrir le guide « '+iaEsc(g.titre)+' »</a></div>';
  }
  fil.insertAdjacentHTML('beforeend','<div class="bulle ia">'+h+'</div>');
  fil.lastElementChild.scrollIntoView({block:'nearest'});
}
function basculerIA(){
  iaCompatible=!iaCompatible;
  const e=document.getElementById('ia-etat'); e.classList.toggle('off',!iaCompatible);
  document.getElementById('ia-etat-txt').textContent=iaCompatible?"Modèle d'Apple, sur cet iPhone · hors ligne":"iPhone non compatible · recherche dans les guides, sans IA";
  const b=document.getElementById('bt-ia'); if(b) b.textContent=iaCompatible?'Simuler un iPhone non compatible avec l\'IA':'Simuler un iPhone compatible avec l\'IA';
  toast(iaCompatible?'iPhone compatible simulé':'iPhone non compatible simulé');
}
/* IA:JS:FIN */
"""
s = re.sub(r"/\* IA:JS:DEBUT \*/.*?/\* IA:JS:FIN \*/\n", "", s, flags=re.S)
i_fin = s.rindex("</script>")
s = s[:i_fin] + js_ia + s[i_fin:]
BT = """<button onclick="basculerIA()" id="bt-ia">Simuler un iPhone non compatible avec l'IA</button>"""
if 'id="bt-ia"' not in s:
    s = s.replace('<button onclick="basculerPremium()" id="bt-prem">', BT + '\n      <button onclick="basculerPremium()" id="bt-prem">', 1)

MAQUETTE.write_text(s, encoding="utf-8")
print(f"{len(ecrans)} écrans de guides intégrés dans {MAQUETTE.relative_to(RACINE)}")
