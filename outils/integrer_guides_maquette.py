#!/usr/bin/env python3
"""Intègre contenus/guides/guides_v1.1.json dans la maquette prototype/maquette_app/index.html.

Génère un écran « Guides », un écran par catégorie et un écran par guide, en HTML
statique : la navigation fonctionne sans JavaScript, par liens internes.
Le script est rejouable : il remplace ce qu'il a généré la fois précédente.

Usage : python3 outils/integrer_guides_maquette.py
"""
import html
import json
import re
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
GUIDES = RACINE / "contenus" / "guides" / "guides_v1.1.json"
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
    raise ValueError(f"bloc inconnu : {t}")


def ecran_guide(x):
    gid = x["id"]
    cat = x["cat"]
    tete = f'<div class="g-tete">{badge(x)}<span class="mini">{e(x["duree"])} de lecture</span></div>'
    urgence = ""
    if x.get("sensible"):
        urgence = '<div class="bandeau c-r">' + ic("croix") + '<div><b>Urgence vitale</b><span>Appelez le 15 ou le 112, 114 par SMS</span></div></div>'
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
               "feu": ("flamme", "c-o"), "orientation": ("carte", "c-g"), "documents": ("doc", "c-g"), "assurance": ("doc", "c-b"), "retour": ("abri", "c-b")}
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
s = s.replace("</script>", js + "</script>", 1)

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

MAQUETTE.write_text(s, encoding="utf-8")
print(f"{len(ecrans)} écrans de guides intégrés dans {MAQUETTE.relative_to(RACINE)}")
