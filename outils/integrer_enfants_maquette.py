#!/usr/bin/env python3
"""Intègre contenus/enfants/parcours_v0.1.json dans prototype/maquette_app/index.html.

Écrans générés : présentation pour le parent, accueil de l'enfant, « J'ai besoin d'aide »,
carte « Montrer à un adulte », une liste par tranche d'âge, un écran par module avec ses
mises en situation, un écran « Demande à tes parents » (jamais d'achat dans l'espace enfants)
et un contrôle parental pour sortir. Navigation par liens internes, rejouable.

Usage : python3 outils/integrer_enfants_maquette.py
"""
import html
import json
import re
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent
CONTENU = RACINE / "contenus" / "enfants" / "parcours_v0.1.json"
MAQUETTE = RACINE / "prototype" / "maquette_app" / "index.html"

d = json.loads(CONTENU.read_text(encoding="utf-8"))
SOURCES = d["meta"]["sources"]
e = html.escape


def ic(n):
    return f'<svg aria-hidden="true"><use href="#p-{n}"/></svg>'


def pico(n, c):
    return f'<span class="pico {c}">{ic(n)}</span>'


def pill(m):
    return '<span class="pill gratuit">Gratuit</span>' if m["gratuit"] else '<span class="pill premium k-fam">Famille</span>'


def lien_module(m):
    # Module de la version famille : sans abonnement, l'enfant voit « Demande à tes parents », jamais l'écran d'achat.
    attr = '' if m["gratuit"] else ' data-famille="1" onclick="return kOuvrir(this)"'
    return (f'<a class="ligne" href="#e-k-m-{m["id"]}"{attr}>{pico(m["picto"], m["couleur"])}'
            f'<span class="t"><b>{e(m["titre"])}</b><div class="s">{e(m["resume"])}</div></span>{pill(m)}</a>')


def ecran_module(tr, m):
    lecon = "".join(f'<div class="etape"><span class="num">{i}</span><div>{e(t)}</div></div>' for i, t in enumerate(m["lecon"], 1))
    quiz = []
    for n, x in enumerate(m["quiz"], 1):
        choix = "".join(
            f'<button class="k-choix" data-juste="{1 if c["juste"] else 0}" data-pourquoi="{e(c["pourquoi"])}" onclick="kRepondre(this)">{e(c["t"])}</button>'
            for c in x["choix"])
        quiz.append(f'<div class="carte k-quiz"><span class="mini">Situation {n}</span><p class="k-sit">{e(x["situation"])}</p>{choix}<p class="k-pourquoi" hidden></p></div>')
    srcs = "".join(
        f'<li>{e(SOURCES[s]["titre"])}, {e(SOURCES[s]["editeur"])}{", " + e(SOURCES[s]["date"]) if SOURCES[s]["date"] else ""}</li>'
        for s in m["sources"]) or "<li>Conseil pratique rédigé par SIJAMAIS, sans source officielle trouvée</li>"
    verif = ('<div class="fictif">À vérifier avant diffusion : ' + " ; ".join(e(v) for v in m["a_relire"]) + "</div>") if m["a_relire"] else ""
    niveau = '<span class="pill gratuit">Consigne officielle</span>' if m["niveau"] == "officiel" else '<span class="pill bientot">Conseil pratique</span>'
    return (f'<section class="ecran k-ecran" id="e-k-m-{m["id"]}">\n'
            f'      <a class="retour" href="#e-k-{tr["id"]}">‹ {e(tr["titre"])}</a>\n'
            f'      <div class="bandeau {m["couleur"]}">{ic(m["picto"])}<div><b>{e(m["titre"])}</b><span>{e(m["resume"])}</span></div></div>'
            f'<div class="g-tete">{niveau}</div>'
            f'<h3>Ce qu\'il faut savoir</h3><div class="carte">{lecon}</div>'
            f'<h3>Et toi, que fais-tu ?</h3>{"".join(quiz)}'
            f'<button class="btn btn-vert" onclick="toast(\'Bravo, module terminé ! Ton parent le verra dans son suivi.\')">{ic("ok")}J\'ai fini</button>'
            f'<h3>Pour les parents : sources</h3><ul class="g-ul g-src">{srcs}</ul>{verif}\n'
            f'    </section>')


ecrans = []
tranches = d["tranches"]
aide = d["aide"]
carte = aide["carte_adulte"]
regles = "".join(f"<li>{e(r)}</li>" for r in d["meta"]["regles"])

# 1. Présentation pour le parent (depuis Famille)
ecrans.append(f'''<section class="ecran" id="e-enfants">
      <a class="retour" href="#e-famille">‹ Famille</a>
      <h2>Espace enfants</h2>
      <p class="g-resume">Votre enfant apprend à alerter et à se protéger, avec les mots de l'école : « Apprendre à porter secours » jusqu'à 10 ans, « Gestes qui sauvent » au collège.</p>
      <div class="liste">
        <div class="ligne">{pico("croix", "c-r")}<span class="t"><b>« J'ai besoin d'aide »</b><div class="s">Appeler un parent, le 112, ou montrer une carte à un adulte</div></span><span class="pill gratuit">Gratuit</span></div>
        <div class="ligne">{pico("livre", "c-f")}<span class="t"><b>Parcours 6-10 ans et 10-14 ans</b><div class="s">{sum(len(t["modules"]) for t in tranches)} modules, {sum(len(m["quiz"]) for t in tranches for m in t["modules"])} mises en situation</div></span><span class="pill premium">Famille</span></div>
        <div class="ligne">{pico("famille", "c-v")}<span class="t"><b>Plusieurs enfants, suivi des modules</b><div class="s">Chaque enfant a son profil sur son iPhone</div></span><span class="pill premium">Famille</span></div>
      </div>
      <h3>Nos engagements</h3>
      <div class="carte"><ul class="g-ul">{regles}</ul></div>
      <h3>Profils</h3>
      <div class="liste">
        <a class="ligne" href="#e-k-accueil"><span class="ico">L</span><span class="t"><b>Léa, 8 ans</b><div class="s">Parcours 6-10 ans · exemple fictif</div></span><span class="chev">›</span></a>
        <a class="ligne" href="#e-k-accueil"><span class="ico">T</span><span class="t"><b>Tom, 12 ans</b><div class="s">Parcours 10-14 ans · exemple fictif</div></span><span class="chev">›</span></a>
      </div>
      <p class="mini" style="margin-top:10px">L'âge vient de la tranche partagée par le Partage familial d'Apple (iOS 26), jamais de la date de naissance.</p>
      <div class="fictif">{e(d["meta"]["avertissement"])}</div>
    </section>''')

# 2. Accueil de l'enfant
liens_tr = "".join(
    f'<a class="liste" href="#e-k-{t["id"]}"><div class="ligne">{pico("livre", "c-f")}<span class="t"><b>{e(t["titre"])}</b><div class="s">{e(t["sous_titre"])} · {len(t["modules"])} modules</div></span><span class="chev">›</span></div></a>'
    for t in tranches)
ecrans.append(f'''<section class="ecran k-ecran" id="e-k-accueil">
      <div class="k-haut"><span class="k-titre">Mon espace</span><a class="k-sortir" href="#e-k-sortie">Sortir</a></div>
      <a class="k-gros c-r" href="#e-k-aide">{ic("croix")}<span>{e(aide["titre"])}</span></a>
      <h3>Apprendre</h3>
      {liens_tr}
      <p class="mini" style="margin-top:10px">Maquette : les deux tranches sont montrées. Dans l'application, l'enfant ne voit que la sienne.</p>
    </section>''')

# 3. J'ai besoin d'aide
cibles = {"parent": ("#e-k-aide", "toast('Appel de Papa (démonstration)');return false", "famille"),
          "112": ("#e-k-aide", "toast('Appel du 112 (démonstration)');return false", "croix"),
          "carte": ("#e-k-carte", "", "famille")}
boutons = "".join(
    f'<a class="k-gros {b["couleur"]}" href="{cibles[b["action"]][0]}"' + (f' onclick="{cibles[b["action"]][1]}"' if cibles[b["action"]][1] else "") + f'>{ic(cibles[b["action"]][2])}<span>{e(b["label"])}</span></a>'
    for b in aide["boutons"])
ecrans.append(f'''<section class="ecran k-ecran" id="e-k-aide">
      <a class="retour" href="#e-k-accueil">‹ Mon espace</a>
      <h2>{e(aide["titre"])}</h2>
      {boutons}
      <p class="mini" style="margin-top:10px">Gratuit pour toujours. Fonctionne téléphone verrouillé avec le bouton « Urgence » de l'iPhone.</p>
    </section>''')

# 4. Carte « Montrer à un adulte » (exemple fictif)
valeurs = ["Léa", "06 00 00 00 01", "06 00 00 00 02", "Allergie aux arachides"]
lignes = "".join(f'<div class="ligne"><span class="t"><div class="s">{e(c)}</div><b>{e(v)}</b></span></div>' for c, v in zip(carte["champs"], valeurs))
ecrans.append(f'''<section class="ecran k-ecran" id="e-k-carte">
      <a class="retour" href="#e-k-aide">‹ J'ai besoin d'aide</a>
      <h2>{e(carte["titre"])}</h2>
      <div class="carte k-carte"><p class="k-phrase">{e(carte["phrase"].format(prenom="Léa"))}</p></div>
      <div class="liste">{lignes}</div>
      <p class="mini" style="margin-top:8px">{e(carte["stockage"])} Rempli par le parent.</p>
      <div class="fictif">Exemple fictif : nom et numéros inventés.</div>
    </section>''')

# 5. Listes par tranche, puis modules
for t in tranches:
    ecrans.append(f'''<section class="ecran k-ecran" id="e-k-{t["id"]}">
      <a class="retour" href="#e-k-accueil">‹ Mon espace</a>
      <h2>{e(t["titre"])}</h2>
      <p class="g-resume">{e(t["sous_titre"])}</p>
      <div class="liste">{"".join(lien_module(m) for m in t["modules"])}</div>
    </section>''')
    for m in t["modules"]:
        ecrans.append(ecran_module(t, m))

# 6. Module de la version famille sans abonnement : pas d'achat dans l'espace enfants
ecrans.append(f'''<section class="ecran k-ecran" id="e-k-verrou">
      <a class="retour" href="#e-k-accueil">‹ Mon espace</a>
      <div class="bandeau c-g">{ic("cadenas")}<div><b>Demande à tes parents</b><span>Ce module fait partie de la version famille</span></div></div>
      <p class="g-p">Tes parents peuvent l'activer depuis leur propre téléphone. Les modules « Appeler les secours », « Alerter les secours » et « Besoin d'en parler » sont toujours ouverts.</p>
      <p class="mini" style="margin-top:10px">Aucun bouton d'achat ici : l'abonnement se prend seulement depuis l'espace des parents.</p>
    </section>''')

# 7. Contrôle parental pour sortir
ecrans.append(f'''<section class="ecran k-ecran" id="e-k-sortie">
      <a class="retour" href="#e-k-accueil">‹ Mon espace</a>
      <h2>Réservé aux parents</h2>
      <p class="g-p">Pour quitter l'espace enfants, touchez le nombre <b>quarante-sept</b>.</p>
      <div class="k-gate">
        <button class="btn btn-s" onclick="toast('Ce n\\'est pas le bon nombre.')">74</button>
        <a class="btn btn-s" href="#e-famille">47</a>
        <button class="btn btn-s" onclick="toast('Ce n\\'est pas le bon nombre.')">407</button>
      </div>
      <p class="mini" style="margin-top:10px">Dans l'application : Face ID ou code du parent, en plus de ce contrôle.</p>
    </section>''')

bloc_html = "<!-- ENFANTS:DEBUT (généré par outils/integrer_enfants_maquette.py) -->\n    " + "\n    ".join(ecrans) + "\n    <!-- ENFANTS:FIN -->\n    "
css = """/* ENFANTS:CSS:DEBUT */
.k-haut{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.k-titre{font-size:24px;font-weight:800}
.k-sortir{font-size:13px;color:var(--texte2);border:1px solid var(--ligne);border-radius:20px;padding:5px 12px}
.k-gros{display:flex;align-items:center;gap:14px;border-radius:22px;padding:20px 18px;margin-bottom:12px;font-size:20px;font-weight:800}
.k-gros svg{width:52px;height:52px;flex:none}
.k-quiz{margin-bottom:12px}
.k-sit{font-weight:700;font-size:16px;margin:4px 0 10px}
.k-choix{display:block;width:100%;text-align:left;background:var(--surface2);border:2px solid transparent;border-radius:14px;padding:12px;margin-bottom:8px;font:inherit;font-size:15px;color:var(--texte)}
.k-choix.juste{border-color:#00843D;background:rgba(0,132,61,.14)}
.k-choix.faux{border-color:#C8102E;background:rgba(200,16,46,.10)}
.k-pourquoi{font-size:14.5px;font-weight:600;margin-top:4px}
.k-carte{border:2px solid #005EB8}
.k-phrase{font-size:19px;font-weight:700;line-height:1.35}
.k-gate{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:12px}
/* Dans l'espace enfants : ni barre d'onglets ni assistant flottant, la seule sortie passe par le contrôle parental */
.phone:has(.k-ecran:target) .tabbar,.phone:has(.k-ecran:target) .ia-flottant{display:none!important}
.k-ecran{padding-bottom:24px}
/* ENFANTS:CSS:FIN */
"""
js = """/* ENFANTS:JS:DEBUT */
function kOuvrir(a){ if(a.dataset.famille && !premium){ location.hash='#e-k-verrou'; return false; } return true; }
function kRepondre(b){
  const q=b.closest('.k-quiz'), p=q.querySelector('.k-pourquoi');
  q.querySelectorAll('.k-choix').forEach(c=>c.classList.remove('juste','faux'));
  b.classList.add(b.dataset.juste==='1'?'juste':'faux');
  p.textContent=b.dataset.pourquoi; p.hidden=false;
}
/* ENFANTS:JS:FIN */
"""

s = MAQUETTE.read_text(encoding="utf-8")
s = re.sub(r"<!-- ENFANTS:DEBUT.*?<!-- ENFANTS:FIN -->\n    ", "", s, flags=re.S)
s = re.sub(r"/\* ENFANTS:CSS:DEBUT \*/.*?/\* ENFANTS:CSS:FIN \*/\n", "", s, flags=re.S)
s = re.sub(r"/\* ENFANTS:JS:DEBUT \*/.*?/\* ENFANTS:JS:FIN \*/\n", "", s, flags=re.S)
assert s.count('<div class="toast" id="toast"></div>') == 1
s = s.replace('<div class="toast" id="toast"></div>', bloc_html + '<div class="toast" id="toast"></div>', 1)
s = s.replace("@media (max-width:860px){", css + "@media (max-width:860px){", 1)
i_fin = s.rindex("</script>")
s = s[:i_fin] + js + s[i_fin:]

# Entrée dans l'écran Famille, juste après « Mon profil d'aidant »
entree = (f'<a class="liste" href="#e-enfants" id="lien-enfants"><div class="ligne">{pico("famille", "c-b")}'
          f'<span class="t"><b>Espace enfants</b><div class="s">Apprendre à alerter et à se protéger, sur l\'iPhone de votre enfant</div></span><span class="chev">›</span></div></a>\n      ')
s = re.sub(r'<a class="liste" href="#e-enfants" id="lien-enfants">.*?</a>\n      ', "", s, flags=re.S)
ancre = '<h3>Plan du foyer</h3>'
a = s.index('<section class="ecran" id="e-famille">')
i = s.index(ancre, a)
s = s[:i] + entree + s[i:]
# La ligne « Enfant » des membres mène à l'espace enfants
s = s.replace('<div class="ligne"><span class="ico">E</span><span class="t">Enfant</span></div>',
              '<a class="ligne" href="#e-enfants"><span class="ico">E</span><span class="t">Enfant<div class="s">Espace enfants</div></span><span class="chev">›</span></a>', 1)

MAQUETTE.write_text(s, encoding="utf-8")
print(f"{len(ecrans)} écrans enfants intégrés dans {MAQUETTE.relative_to(RACINE)}")
