#!/usr/bin/env python3
"""Génère modele_financier.xlsx, version 2 : application iPhone gratuite avec version complète.

Le classeur ne contient que des hypothèses saisies (en bleu) et des formules.
Trois scénarios (Prudent, Central, Ambitieux) sont calculés côte à côte sur 36 mois.

Usage :
    python3 outils/generer_modele_application.py [chemin_de_sortie.xlsx]

Ouvrir ensuite le fichier dans Excel ou LibreOffice pour calculer les formules.
La version 1 (pack et téléphone) est archivée dans archives/.
"""
import sys
from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter as L

SORTIE = sys.argv[1] if len(sys.argv) > 1 else "modele_financier.xlsx"

P_ = "Arial"
F_TITRE = Font(name=P_, size=14, bold=True)
F_SECTION = Font(name=P_, size=10, bold=True, color="FFFFFF")
F_ENTETE = Font(name=P_, size=10, bold=True)
F_NORMAL = Font(name=P_, size=10)
F_GRAS = Font(name=P_, size=10, bold=True)
F_INPUT = Font(name=P_, size=10, color="0000FF")
F_LIEN = Font(name=P_, size=10, color="008000")
F_NOTE = Font(name=P_, size=9, italic=True, color="555555")
R_SECTION = PatternFill("solid", fgColor="1F3A5F")
R_ENTETE = PatternFill("solid", fgColor="D9E2EC")
R_CLE = PatternFill("solid", fgColor="FFFF00")
R_TOTAL = PatternFill("solid", fgColor="EEF2F6")

EUR = '#,##0 "€";(#,##0 "€");"-"'
EUR2 = '#,##0.00 "€";(#,##0.00 "€");"-"'
PCT = '0.0%;(0.0%);"-"'
PCT2 = '0.00%;(0.00%);"-"'
NB = '#,##0;(#,##0);"-"'
NB1 = '#,##0.0;(#,##0.0);"-"'
X = '0.0"x"'

SCEN = ["Prudent", "Central", "Ambitieux"]
SC = {"Prudent": "C", "Central": "D", "Ambitieux": "E"}
NM = 36
C0 = 3

wb = Workbook()

# ---------------------------------------------------------------- Lisez_moi
lm = wb.active
lm.title = "Lisez_moi"
for i, (t, f) in enumerate([
    ("Modèle financier MECUM, version 2 : application iPhone gratuite avec version complète", F_TITRE),
    ("Généré le 13/11/2026 par outils/generer_modele_application.py. Montants en euros hors taxe sauf mention TTC.", F_NORMAL),
    ("", F_NORMAL),
    ("Comment utiliser ce classeur", F_GRAS),
    ("1. Toutes les hypothèses sont dans la feuille Hypotheses, une colonne par scénario. Bleu : saisie modifiable. Noir : formule. Vert : lien vers une autre feuille.", F_NORMAL),
    ("2. Fond jaune : hypothèses qui pèsent le plus sur le résultat, à valider en priorité par le test des 30 jours.", F_NORMAL),
    ("3. Unitaire : ce que rapporte un achat et une installation. M_Prudent, M_Central, M_Ambitieux : projections mensuelles.", F_NORMAL),
    ("4. Synthese : résultats annuels et indicateurs. Sensibilites : grilles, scénario au choix en B3. Emploi_des_fonds : étapes de dépense.", F_NORMAL),
    ("", F_NORMAL),
    ("Mécanique du modèle", F_GRAS),
    ("Chaque mois, de nouvelles personnes installent l'application gratuite (installations organiques et publicité). Une part achète la version complète dans le mois.", F_NORMAL),
    ("Les utilisateurs gratuits restants forment une base qui s'érode chaque mois et dont une petite part achète plus tard.", F_NORMAL),
    ("Apple encaisse le prix TTC, reverse la TVA et retient sa commission. Le versement arrive environ un mois plus tard : le modèle décale l'encaissement d'un mois.", F_NORMAL),
    ("Une ligne optionnelle de licences pour les communes (module plan de sauvegarde) est prévue. Elle est nulle dans le scénario prudent.", F_NORMAL),
    ("", F_NORMAL),
    ("Marqueurs : [FAIT] donnée sourcée (sources.md), [EST] estimation, [HYP] hypothèse à tester (registre_hypotheses.md). Ces scénarios ne sont pas des prévisions.", F_NORMAL),
], start=1):
    lm.cell(row=i, column=1, value=t).font = f
lm.column_dimensions["A"].width = 150

# ---------------------------------------------------------------- Hypotheses
hy = wb.create_sheet("Hypotheses")
hy["A1"] = "Hypothèses par scénario"
hy["A1"].font = F_TITRE
hy["A2"] = "Bleu = saisie modifiable. Fond jaune = hypothèse clé à valider."
hy["A2"].font = F_NOTE
for j, h in enumerate(["Paramètre", "Unité", "Prudent", "Central", "Ambitieux", "Statut et source"], start=1):
    c = hy.cell(row=4, column=j, value=h)
    c.font, c.fill = F_ENTETE, R_ENTETE
P = {}


def ref(k, s):
    return f"Hypotheses!${SC[s]}${P[k]}"


HYP = [
    ("#", "Général"),
    ("tva", "Taux de TVA", "%", .2, .2, .2, PCT, False, "[FAIT] Taux normal France. Apple reverse la TVA."),
    ("comm", "Commission de l'App Store", "%", .15, .15, .15, PCT, False, "[FAIT] 15 % pour les membres du programme petites entreprises (Apple, août 2026). Inscription à faire."),
    ("delai", "Décalage de versement par Apple", "mois", 1, 1, 1, NB, False, "[EST] Versement environ 33 jours après la fin du mois."),
    ("debut", "Mois de sortie sur l'App Store", "mois", 6, 5, 4, NB, True, "[HYP] Test de 30 jours, puis 2 à 4 mois de développement."),
    ("#", "Prix (TTC, achat unique)"),
    ("p_comp", "Version complète", "€ TTC", 19.99, 24.99, 29.99, EUR2, True, "[HYP] Repère : HAVEN Pro à vie 29,99 USD (capture du 12/11/2026)."),
    ("p_fam", "Version famille (jusqu'à 5 personnes)", "€ TTC", 39.99, 49.99, 59.99, EUR2, False, "[HYP] Repère : HAVEN Pro Family 59,99 € (capture du 13/11/2026)."),
    ("part_fam", "Part des acheteurs qui prennent la version famille", "%", .15, .2, .25, PCT, False, "[HYP]"),
    ("#", "Installations"),
    ("org0", "Installations organiques le premier mois", "inst./mois", 150, 500, 1500, NB, True, "[HYP] Référencement App Store, contenus, liste d'attente, presse."),
    ("g1", "Croissance mensuelle, 12 premiers mois", "%", .06, .1, .14, PCT, True, "[HYP]"),
    ("g2", "Croissance mensuelle ensuite", "%", .02, .04, .06, PCT, False, "[HYP]"),
    ("pub1", "Publicité, année 1", "€/mois", 200, 300, 500, EUR, False, "[HYP] Annonces dans l'App Store surtout."),
    ("pub2", "Publicité, année 2", "€/mois", 300, 500, 1500, EUR, False, "[HYP]"),
    ("pub3", "Publicité, année 3", "€/mois", 400, 800, 3000, EUR, False, "[HYP]"),
    ("cpi", "Coût d'une installation payante", "€", 4, 2.5, 1.5, EUR2, True, "[HYP] A mesurer pendant le test. Aucune donnée française fiable trouvée."),
    ("#", "Passage au payant"),
    ("conv", "Part des nouveaux utilisateurs qui achètent dans le mois", "%", .02, .035, .05, PCT, True, "[HYP] Ordre de grandeur des applications à achat unique. A mesurer."),
    ("conv_b", "Part de la base gratuite qui achète chaque mois ensuite", "%", .002, .003, .004, PCT2, False, "[HYP]"),
    ("attr", "Erosion mensuelle de la base gratuite", "%", .08, .06, .05, PCT, False, "[HYP] Désinstallations et abandons."),
    ("#", "Licences communes (module plan de sauvegarde, optionnel)"),
    ("b2b_d", "Mois de première licence (0 = jamais)", "mois", 0, 10, 8, NB, False, "[HYP] Concurrents existants sur l'alerte : IntraMuros, Illiwap. A tester en entretiens."),
    ("b2b_p", "Prix annuel d'une licence", "€ HT/an", 600, 900, 1200, EUR, False, "[HYP]"),
    ("b2b1", "Nouvelles communes par mois, année 1", "/mois", 0, .5, 1, NB1, False, "[HYP]"),
    ("b2b2", "Nouvelles communes par mois, année 2", "/mois", 0, 1, 2, NB1, False, "[HYP]"),
    ("b2b3", "Nouvelles communes par mois, année 3", "/mois", 0, 1.5, 4, NB1, False, "[HYP]"),
    ("#", "Coûts"),
    ("heb", "Hébergement des contenus par installation (cartes, encyclopédie)", "€", .05, .03, .02, EUR2, False, "[EST] Stockage objet sans frais de sortie. Un département de carte par défaut."),
    ("apple", "Programme développeur Apple", "€/mois", 8.25, 8.25, 8.25, EUR2, False, "[A CONFIRMER] 99 € par an."),
    ("outils", "Outils (site, emailing, analyse)", "€/mois", 60, 80, 150, EUR, False, "[EST]"),
    ("compta", "Expert-comptable, assurances, banque", "€/mois", 150, 180, 250, EUR, False, "[EST] SASU."),
    ("dev1", "Développeur iOS indépendant (maintenance), année 1", "€/mois", 300, 400, 600, EUR, False, "[HYP] Après la v1."),
    ("dev2", "Développeur iOS indépendant, année 2", "€/mois", 300, 500, 1200, EUR, False, "[HYP]"),
    ("dev3", "Développeur iOS indépendant, année 3", "€/mois", 300, 800, 2500, EUR, False, "[HYP] Version Android en année 3 dans l'ambitieux."),
    ("cont1", "Contenus, créateurs, relectures, année 1", "€/mois", 100, 250, 500, EUR, False, "[HYP]"),
    ("cont2", "Contenus, créateurs, relectures, année 2", "€/mois", 150, 500, 1500, EUR, False, "[HYP]"),
    ("cont3", "Contenus, créateurs, relectures, année 3", "€/mois", 200, 800, 3000, EUR, False, "[HYP]"),
    ("remu1", "Rémunération chargée du fondateur, année 1", "€/mois", 0, 0, 0, EUR, False, "[FAIT] Le fondateur peut tenir 3 à 4 mois sans revenu (13/11/2026). Voir Synthese."),
    ("remu2", "Rémunération chargée du fondateur, année 2", "€/mois", 0, 1000, 2500, EUR, False, "[HYP]"),
    ("remu3", "Rémunération chargée du fondateur, année 3", "€/mois", 0, 2000, 4000, EUR, False, "[HYP]"),
    ("divers", "Divers", "€/mois", 50, 80, 150, EUR, False, "[EST]"),
    ("lanc", "Investissements de lancement (mois 1 à 4)", "€", 18500, 16600, 20000, EUR, True, "[EST] Application v1 iOS, Mac et iPhone de test, identité visuelle, relecture, juridique, marque, test. Détail : Emploi_des_fonds."),
    ("#", "Financement"),
    ("ap1", "Apport initial (mois 1)", "€", 10000, 10000, 10000, EUR, False, "[FAIT] Budget initial du fondateur."),
    ("ap2_m", "Apport n°2 : mois", "mois", 2, 2, 2, NB, False, "[HYP] Seulement après la décision du jour 30."),
    ("ap2", "Apport n°2 : montant", "€", 10000, 10000, 15000, EUR, False, "[HYP]"),
    ("ap3_m", "Apport n°3 : mois (0 = aucun)", "mois", 5, 5, 5, NB, False, "[HYP]"),
    ("ap3", "Apport n°3 : montant", "€", 10000, 15000, 10000, EUR, False, "[HYP] Total plafonné à 40 000 €. Peut être remplacé par un prêt d'honneur."),
    ("#", "Repères"),
    ("smic", "Coût mensuel d'une rémunération d'environ 1 500 € nets", "€/mois", 2200, 2200, 2200, EUR, False, "[EST] Repère pour savoir quand le projet peut te payer."),
    ("m_bas", "Multiple d'EBITDA, bas", "x", 2.5, 2.5, 2.5, X, False, "[FAIT] 1,5x à 7x en 2026 pour les marques en ligne."),
    ("m_haut", "Multiple d'EBITDA, haut", "x", 4.5, 4.5, 4.5, X, False, "[FAIT]"),
]
r = 5
for it in HYP:
    if it[0] == "#":
        hy.cell(row=r, column=1, value=it[1]).font = F_SECTION
        for j in range(1, 7):
            hy.cell(row=r, column=j).fill = R_SECTION
        r += 1
        continue
    k, lib, u, a, b, c_, fmt, cle, note = it
    P[k] = r
    hy.cell(row=r, column=1, value=lib).font = F_NORMAL
    hy.cell(row=r, column=2, value=u).font = F_NORMAL
    for j, v in zip((3, 4, 5), (a, b, c_)):
        cc = hy.cell(row=r, column=j, value=v)
        cc.font, cc.number_format = F_INPUT, fmt
        if cle:
            cc.fill = R_CLE
    hy.cell(row=r, column=6, value=note).font = F_NOTE
    r += 1
r += 1
hy.cell(row=r, column=1, value="Contrôle : fonds propres apportés (plafond 40 000 €)").font = F_GRAS
for j, s in zip((3, 4, 5), SCEN):
    col = SC[s]
    cc = hy.cell(row=r, column=j, value=f"={col}{P['ap1']}+{col}{P['ap2']}+IF({col}{P['ap3_m']}>0,{col}{P['ap3']},0)")
    cc.font, cc.number_format = F_GRAS, EUR
hy.column_dimensions["A"].width = 64
hy.column_dimensions["B"].width = 11
for col in "CDE":
    hy.column_dimensions[col].width = 13
hy.column_dimensions["F"].width = 100
hy.freeze_panes = "C5"

# ---------------------------------------------------------------- Unitaire
un = wb.create_sheet("Unitaire")
un["A1"] = "Ce que rapporte un achat et une installation (euros HT)"
un["A1"].font = F_TITRE
for j, s in enumerate(SCEN, start=2):
    c = un.cell(row=3, column=j, value=s)
    c.font, c.fill = F_ENTETE, R_ENTETE
un.cell(row=3, column=1, value="Par achat").font = F_ENTETE
un.cell(row=3, column=1).fill = R_ENTETE
U = {}
LIG = [
    ("ttc", "Prix moyen payé TTC (mix complète et famille)", lambda s: f"=(1-{ref('part_fam', s)})*{ref('p_comp', s)}+{ref('part_fam', s)}*{ref('p_fam', s)}", EUR2),
    ("ht", "Prix moyen HT", lambda s: f"={L(2 + SCEN.index(s))}4/(1+{ref('tva', s)})", EUR2),
    ("com", "Commission Apple", lambda s: f"={L(2 + SCEN.index(s))}5*{ref('comm', s)}", EUR2),
    ("net", "Revenu net par achat", lambda s: f"={L(2 + SCEN.index(s))}5-{L(2 + SCEN.index(s))}6", EUR2),
    ("ltv", "Revenu net attendu par installation (achat dans le mois et achats différés)",
     lambda s: f"={L(2 + SCEN.index(s))}7*({ref('conv', s)}+(1-{ref('conv', s)})*{ref('conv_b', s)}/({ref('attr', s)}+{ref('conv_b', s)}))-{ref('heb', s)}", EUR2),
    ("roi", "Revenu net par euro de publicité", lambda s: f"=IF({ref('cpi', s)}=0,0,{L(2 + SCEN.index(s))}8/{ref('cpi', s)})", '0.00'),
]
for i, (k, lib, fn, fmt) in enumerate(LIG, start=4):
    un.cell(row=i, column=1, value=lib).font = F_GRAS if k in ("net", "ltv", "roi") else F_NORMAL
    for s in SCEN:
        c = un.cell(row=i, column=2 + SCEN.index(s), value=fn(s))
        c.number_format, c.font = fmt, F_NORMAL
        U[(s, k)] = f"Unitaire!${L(2 + SCEN.index(s))}${i}"
un.cell(row=11, column=1, value="Lecture : sous 1,00, chaque euro de publicité rapporte moins d'un euro. La publicité ne sert alors qu'à tester des messages.").font = F_NOTE
un.column_dimensions["A"].width = 78
for col in "BCD":
    un.column_dimensions[col].width = 14

# ---------------------------------------------------------------- Mensuel
M = {}


def mensuel(s):
    ws = wb.create_sheet(f"M_{s}")
    h = lambda k: ref(k, s)  # noqa: E731
    ws["A1"] = f"Projection mensuelle sur 36 mois, scénario {s} (euros HT)"
    ws["A1"].font = F_TITRE
    rows, cur = {}, [4]
    a, z = C0, C0 + NM - 1

    def ligne(k, lib, fn, fmt=EUR, gras=False, tot=False):
        rr = cur[0]
        rows[k] = rr
        ws.cell(row=rr, column=1, value=lib).font = F_GRAS if gras else F_NORMAL
        for ci in range(a, z + 1):
            c = ws.cell(row=rr, column=ci, value=fn(L(ci), ci))
            c.number_format, c.font = fmt, F_GRAS if gras else F_NORMAL
            if tot:
                c.fill = R_TOTAL
        if tot:
            ws.cell(row=rr, column=1).fill = R_TOTAL
        cur[0] += 1

    def section(t):
        ws.cell(row=cur[0], column=1, value=t).font = F_SECTION
        for ci in range(1, z + 1):
            ws.cell(row=cur[0], column=ci).fill = R_SECTION
        cur[0] += 1

    g = lambda k, c: f"{c}{rows[k]}"  # noqa: E731
    prev = lambda k, ci: f"{L(ci - 1)}{rows[k]}"  # noqa: E731

    section("Calendrier")
    ligne("mois", "Mois", lambda c, ci: 1 if ci == a else f"={L(ci - 1)}{cur[0]}+1", NB, gras=True)
    ligne("an", "Année", lambda c, ci: f"=INT(({g('mois', c)}-1)/12)+1", NB)
    ligne("n", "Rang du mois depuis la sortie (0 = pas encore sortie)", lambda c, ci: f"=MAX(0,{g('mois', c)}-{h('debut')}+1)", NB)

    section("Utilisateurs")
    ligne("org", "Installations organiques",
          lambda c, ci: f"=IF({g('n', c)}=0,0,{h('org0')}*(1+{h('g1')})^(MIN({g('n', c)},12)-1)*(1+{h('g2')})^MAX(0,{g('n', c)}-12))", NB)
    ligne("pub", "Budget publicitaire", lambda c, ci: f"=IF({g('n', c)}=0,0,CHOOSE({g('an', c)},{h('pub1')},{h('pub2')},{h('pub3')}))")
    ligne("pay", "Installations payantes", lambda c, ci: f"=IF({h('cpi')}>0,{g('pub', c)}/{h('cpi')},0)", NB)
    ligne("inst", "Installations totales", lambda c, ci: f"={g('org', c)}+{g('pay', c)}", NB, gras=True, tot=True)
    ligne("ach_n", "Achats de nouveaux utilisateurs (dans le mois)", lambda c, ci: f"={g('inst', c)}*{h('conv')}", NB1)
    ligne("ach_b", "Achats différés (base gratuite du mois précédent)",
          lambda c, ci: "=0" if ci == a else f"={L(ci - 1)}{cur[0] + 2}*{h('conv_b')}", NB1)
    ligne("ach", "Achats totaux", lambda c, ci: f"={g('ach_n', c)}+{g('ach_b', c)}", NB1, gras=True)
    ligne("base", "Base d'utilisateurs gratuits en fin de mois",
          lambda c, ci: (f"={g('inst', c)}-{g('ach_n', c)}" if ci == a else
                         f"={prev('base', ci)}*(1-{h('attr')})-{g('ach_b', c)}+{g('inst', c)}-{g('ach_n', c)}"), NB)
    ligne("payants", "Utilisateurs payants cumulés", lambda c, ci: f"={g('ach', c)}" if ci == a else f"={prev('payants', ci)}+{g('ach', c)}", NB)
    ligne("communes", "Communes sous licence (cumul)",
          lambda c, ci: (f"=IF(AND({h('b2b_d')}>0,{g('mois', c)}>={h('b2b_d')}),CHOOSE({g('an', c)},{h('b2b1')},{h('b2b2')},{h('b2b3')}),0)"
                         if ci == a else
                         f"={prev('communes', ci)}+IF(AND({h('b2b_d')}>0,{g('mois', c)}>={h('b2b_d')}),CHOOSE({g('an', c)},{h('b2b1')},{h('b2b2')},{h('b2b3')}),0)"), NB1)

    section("Produits (HT, nets de la commission Apple)")
    ligne("ca_ttc", "Ventes de l'application TTC payées par les clients", lambda c, ci: f"={g('ach', c)}*{U[(s, 'ttc')]}")
    ligne("app", "Revenu net de l'application", lambda c, ci: f"={g('ach', c)}*{U[(s, 'net')]}")
    ligne("b2b", "Licences communes", lambda c, ci: f"={g('communes', c)}*{h('b2b_p')}/12")
    ligne("prod", "Produits nets totaux", lambda c, ci: f"={g('app', c)}+{g('b2b', c)}", gras=True, tot=True)

    section("Charges")
    ligne("ch_heb", "Hébergement des contenus", lambda c, ci: f"={g('inst', c)}*{h('heb')}")
    ligne("ch_pub", "Publicité", lambda c, ci: f"={g('pub', c)}")
    ligne("ch_cont", "Contenus, créateurs, relectures", lambda c, ci: f"=CHOOSE({g('an', c)},{h('cont1')},{h('cont2')},{h('cont3')})")
    ligne("ch_dev", "Développeur iOS (après la v1)",
          lambda c, ci: f"=IF({g('n', c)}=0,0,CHOOSE({g('an', c)},{h('dev1')},{h('dev2')},{h('dev3')}))")
    ligne("ch_fix", "Apple, outils, comptabilité, divers", lambda c, ci: f"={h('apple')}+{h('outils')}+{h('compta')}+{h('divers')}")
    ligne("ch_remu", "Rémunération du fondateur", lambda c, ci: f"=CHOOSE({g('an', c)},{h('remu1')},{h('remu2')},{h('remu3')})")
    ligne("ch_lanc", "Investissements de lancement", lambda c, ci: f"=IF({g('mois', c)}<=4,{h('lanc')}/4,0)")
    ligne("ch", "Total des charges", lambda c, ci: f"=SUM({c}{rows['ch_heb']}:{c}{rows['ch_lanc']})", gras=True, tot=True)

    section("Résultat et trésorerie")
    ligne("ebitda", "EBITDA", lambda c, ci: f"={g('prod', c)}-{g('ch', c)}", gras=True, tot=True)
    ligne("ebitda_av", "EBITDA avant rémunération du fondateur", lambda c, ci: f"={g('ebitda', c)}+{g('ch_remu', c)}")
    ligne("cum", "EBITDA cumulé", lambda c, ci: f"={g('ebitda', c)}" if ci == a else f"={prev('cum', ci)}+{g('ebitda', c)}")
    ligne("f_pos", "Indicateur : EBITDA positif (1 = oui)", lambda c, ci: f"=IF({g('ebitda', c)}>0,1,0)", NB)
    ligne("f_cum", "Indicateur : EBITDA cumulé positif", lambda c, ci: f"=IF({g('cum', c)}>0,1,0)", NB)
    ligne("f_paie", "Indicateur : le projet peut payer environ 1 500 € nets au fondateur",
          lambda c, ci: f"=IF({g('ebitda_av', c)}>={h('smic')},1,0)", NB)
    ligne("encais", "Encaissement de l'application (décalé)",
          lambda c, ci: "=0" if ci == a else f"={L(ci - 1)}{rows['app']}")
    ligne("apports", "Apports du fondateur",
          lambda c, ci: (f"=IF({g('mois', c)}=1,{h('ap1')},0)+IF({g('mois', c)}={h('ap2_m')},{h('ap2')},0)"
                         f"+IF(AND({h('ap3_m')}>0,{g('mois', c)}={h('ap3_m')}),{h('ap3')},0)"))
    ligne("flux", "Flux net de trésorerie", lambda c, ci: f"={g('encais', c)}+{g('b2b', c)}-{g('ch', c)}+{g('apports', c)}", gras=True)
    ligne("treso", "Trésorerie en fin de mois", lambda c, ci: f"={g('flux', c)}" if ci == a else f"={prev('treso', ci)}+{g('flux', c)}", gras=True, tot=True)
    ligne("f_neg", "Indicateur : trésorerie négative", lambda c, ci: f"=IF({g('treso', c)}<0,1,0)", NB)

    ws.column_dimensions["A"].width = 58
    ws.column_dimensions["B"].width = 2
    for ci in range(a, z + 1):
        ws.column_dimensions[L(ci)].width = 10
    ws.freeze_panes = ws.cell(row=5, column=a)
    for k, v in rows.items():
        M[(s, k)] = v


for s in SCEN:
    mensuel(s)
A1, Z1 = L(C0), L(C0 + NM - 1)


def pl(s, k):
    return f"M_{s}!${A1}${M[(s, k)]}:${Z1}${M[(s, k)]}"


# ---------------------------------------------------------------- Synthese
sy = wb.create_sheet("Synthese")
sy["A1"] = "Synthèse des trois scénarios sur 36 mois (euros HT)"
sy["A1"].font = F_TITRE
sy.cell(row=3, column=1, value="Indicateur").font = F_ENTETE
COL = {}
col = 2
for s in SCEN:
    for an in (1, 2, 3):
        c = sy.cell(row=3, column=col, value=f"{s} A{an}")
        c.font, c.fill = F_ENTETE, R_ENTETE
        COL[(s, an)] = col
        col += 1
ANN = [
    ("Installations", ("inst",), NB),
    ("Achats de la version complète", ("ach",), NB),
    ("Ventes TTC payées par les clients", ("ca_ttc",), EUR),
    ("Revenu net de l'application", ("app",), EUR),
    ("Licences communes", ("b2b",), EUR),
    ("Produits nets totaux", ("prod",), EUR),
    ("Publicité", ("ch_pub",), EUR),
    ("Autres charges et investissements", ("ch_heb", "ch_cont", "ch_dev", "ch_fix", "ch_remu", "ch_lanc"), EUR),
    ("dont rémunération du fondateur", ("ch_remu",), EUR),
    ("EBITDA", ("ebitda",), EUR),
]
SYR = {}
rr = 4
for lib, ks, fmt in ANN:
    sy.cell(row=rr, column=1, value=lib).font = F_GRAS if lib in ("Produits nets totaux", "EBITDA") else F_NORMAL
    for s in SCEN:
        for an in (1, 2, 3):
            f = "=" + "+".join(f"SUMIF({pl(s, 'an')},{an},{pl(s, k)})" for k in ks)
            c = sy.cell(row=rr, column=COL[(s, an)], value=f)
            c.number_format = fmt
            c.font = F_GRAS if lib in ("Produits nets totaux", "EBITDA") else F_LIEN
            if lib in ("Produits nets totaux", "EBITDA"):
                c.fill = R_TOTAL
    SYR[lib] = rr
    rr += 1
sy.cell(row=rr, column=1, value="Utilisateurs payants cumulés en fin d'année").font = F_NORMAL
for s in SCEN:
    for an in (1, 2, 3):
        c = sy.cell(row=rr, column=COL[(s, an)], value=f"=INDEX({pl(s, 'payants')},1,{12 * an})")
        c.number_format, c.font = NB, F_LIEN
rr += 1
sy.cell(row=rr, column=1, value="Trésorerie en fin d'année").font = F_GRAS
for s in SCEN:
    for an in (1, 2, 3):
        c = sy.cell(row=rr, column=COL[(s, an)], value=f"=INDEX({pl(s, 'treso')},1,{12 * an})")
        c.number_format, c.font, c.fill = EUR, F_GRAS, R_TOTAL
rr += 2
sy.cell(row=rr, column=1, value="Indicateurs sur 36 mois").font = F_ENTETE
sy.cell(row=rr, column=1).fill = R_ENTETE
for j, s in enumerate(SCEN, start=2):
    c = sy.cell(row=rr, column=j, value=s)
    c.font, c.fill = F_ENTETE, R_ENTETE
rr += 1
KPI = [
    ("Installations cumulées", lambda s: f"=SUM({pl(s, 'inst')})", NB),
    ("Achats cumulés", lambda s: f"=SUM({pl(s, 'ach')})", NB),
    ("Produits nets cumulés", lambda s: f"=SUM({pl(s, 'prod')})", EUR),
    ("EBITDA cumulé", lambda s: f"=SUM({pl(s, 'ebitda')})", EUR),
    ("Perte cumulée maximale", lambda s: f"=MIN(0,MIN({pl(s, 'cum')}))", EUR),
    ("Premier mois à EBITDA positif (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{pl(s, 'f_pos')},0),0)", NB),
    ("Premier mois où l'EBITDA cumulé devient positif (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{pl(s, 'f_cum')},0),0)", NB),
    ("Premier mois où le projet peut payer 1 500 € nets au fondateur (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{pl(s, 'f_paie')},0),0)", NB),
    ("Trésorerie minimale", lambda s: f"=MIN({pl(s, 'treso')})", EUR),
    ("Premier mois de trésorerie négative (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{pl(s, 'f_neg')},0),0)", NB),
    ("Fonds propres apportés", lambda s: f"=SUM({pl(s, 'apports')})", EUR),
    ("Revenu net par achat", lambda s: f"={U[(s, 'net')]}", EUR2),
    ("Revenu net attendu par installation", lambda s: f"={U[(s, 'ltv')]}", EUR2),
    ("Revenu net par euro de publicité", lambda s: f"={U[(s, 'roi')]}", '0.00'),
    ("Valorisation indicative basse (EBITDA A3)", lambda s: f"=MAX(0,{L(COL[(s, 3)])}{SYR['EBITDA']})*{ref('m_bas', s)}", EUR),
    ("Valorisation indicative haute (EBITDA A3)", lambda s: f"=MAX(0,{L(COL[(s, 3)])}{SYR['EBITDA']})*{ref('m_haut', s)}", EUR),
]
for lib, fn, fmt in KPI:
    sy.cell(row=rr, column=1, value=lib).font = F_NORMAL
    for j, s in enumerate(SCEN, start=2):
        c = sy.cell(row=rr, column=j, value=fn(s))
        c.number_format, c.font = fmt, F_LIEN
    rr += 1
sy.column_dimensions["A"].width = 70
for j in range(2, 11):
    sy.column_dimensions[L(j)].width = 14
sy.freeze_panes = "B4"

# ---------------------------------------------------------------- Sensibilites
se = wb.create_sheet("Sensibilites")
se["A1"] = "Analyses de sensibilité"
se["A1"].font = F_TITRE
se["A3"] = "Scénario analysé (1 = Prudent, 2 = Central, 3 = Ambitieux)"
se["A3"].font = F_GRAS
se["B3"] = 2
se["B3"].font, se["B3"].fill = F_INPUT, R_CLE


def ch(fn):
    return f"CHOOSE($B$3,{fn('Prudent')},{fn('Central')},{fn('Ambitieux')})"


se["A5"] = "Valeurs du scénario"
se["A5"].font = F_ENTETE
BASE = [
    ("Taux de TVA", ch(lambda s: ref("tva", s)), PCT),
    ("Commission Apple", ch(lambda s: ref("comm", s)), PCT),
    ("Part des acheteurs en version famille", ch(lambda s: ref("part_fam", s)), PCT),
    ("Rapport prix famille sur prix complète", ch(lambda s: f"{ref('p_fam', s)}/{ref('p_comp', s)}"), '0.00'),
    ("Charges mensuelles année 2, hors publicité", ch(lambda s: f"({ref('apple', s)}+{ref('outils', s)}+{ref('compta', s)}+{ref('divers', s)}+{ref('dev2', s)}+{ref('cont2', s)}+{ref('remu2', s)})"), EUR),
]
for i, (lib, f, fmt) in enumerate(BASE, start=6):
    se.cell(row=i, column=1, value=lib).font = F_NORMAL
    c = se.cell(row=i, column=2, value="=" + f)
    c.number_format, c.font = fmt, F_LIEN
TVA_, COM_, PF_, RF_, FIX2 = "$B$6", "$B$7", "$B$8", "$B$9", "$B$10"

r0 = 13
se.cell(row=r0, column=1, value="Grille 1 : achats mensuels nécessaires pour couvrir les charges de l'année 2, selon le prix de la version complète").font = F_ENTETE
prix = [14.99, 19.99, 24.99, 29.99, 34.99, 39.99]
se.cell(row=r0 + 1, column=1, value="Prix TTC de la version complète").font = F_NOTE
for j, v in enumerate(prix, start=2):
    c = se.cell(row=r0 + 1, column=j, value=v)
    c.number_format, c.font, c.fill = EUR2, F_INPUT, R_ENTETE
se.cell(row=r0 + 2, column=1, value="Revenu net par achat").font = F_NORMAL
se.cell(row=r0 + 3, column=1, value="Achats par mois au point mort").font = F_GRAS
for j in range(2, 2 + len(prix)):
    cl = L(j)
    c = se.cell(row=r0 + 2, column=j, value=f"={cl}{r0 + 1}*((1-{PF_})+{PF_}*{RF_})/(1+{TVA_})*(1-{COM_})")
    c.number_format, c.font = EUR2, F_NORMAL
    c = se.cell(row=r0 + 3, column=j, value=f"={FIX2}/{cl}{r0 + 2}")
    c.number_format, c.font = NB, F_GRAS

r1 = r0 + 6
se.cell(row=r1, column=1, value="Grille 2 : installations mensuelles nécessaires au point mort de l'année 2, selon le prix et le taux de passage au payant").font = F_ENTETE
convs = [.01, .02, .03, .04, .05, .07]
se.cell(row=r1 + 1, column=1, value="Taux de passage (lignes) / prix TTC (colonnes)").font = F_NOTE
for j, v in enumerate(prix, start=2):
    c = se.cell(row=r1 + 1, column=j, value=v)
    c.number_format, c.font, c.fill = EUR2, F_INPUT, R_ENTETE
for i, cv in enumerate(convs, start=r1 + 2):
    c = se.cell(row=i, column=1, value=cv)
    c.number_format, c.font = PCT, F_INPUT
    c.alignment = Alignment(horizontal="right")
    for j in range(2, 2 + len(prix)):
        cl = L(j)
        cc = se.cell(row=i, column=j, value=f"={FIX2}/({cl}${r0 + 2}*$A{i})")
        cc.number_format, cc.font = NB, F_NORMAL

r2 = r1 + 2 + len(convs) + 2
se.cell(row=r2, column=1, value="Grille 3 : revenu net par euro de publicité, selon le coût d'une installation et le taux de passage (prix du scénario)").font = F_ENTETE
cpis = [0.8, 1.2, 1.8, 2.5, 3.5, 5.0]
se.cell(row=r2 + 1, column=1, value="Taux de passage (lignes) / coût d'une installation (colonnes)").font = F_NOTE
for j, v in enumerate(cpis, start=2):
    c = se.cell(row=r2 + 1, column=j, value=v)
    c.number_format, c.font, c.fill = EUR2, F_INPUT, R_ENTETE
NET_ = ch(lambda s: U[(s, "net")])
for i, cv in enumerate(convs, start=r2 + 2):
    c = se.cell(row=i, column=1, value=cv)
    c.number_format, c.font = PCT, F_INPUT
    c.alignment = Alignment(horizontal="right")
    for j in range(2, 2 + len(cpis)):
        cl = L(j)
        cc = se.cell(row=i, column=j, value=f"={NET_}*$A{i}/{cl}${r2 + 1}")
        cc.number_format, cc.font = '0.00', F_NORMAL
se.cell(row=r2 + 2 + len(convs) + 1, column=1, value="Grille 3 : au-dessus de 1,00, la publicité rapporte plus qu'elle ne coûte (sans compter les achats différés).").font = F_NOTE
se.column_dimensions["A"].width = 72
for j in range(2, 9):
    se.column_dimensions[L(j)].width = 13

# ---------------------------------------------------------------- Emploi des fonds
ef = wb.create_sheet("Emploi_des_fonds")
ef["A1"] = "Emploi des fonds : 10 000 € puis jusqu'à 40 000 € (scénario central, euros HT)"
ef["A1"].font = F_TITRE
ef["A2"] = "Chaque étape n'est engagée que si la précédente a franchi son seuil (plan_30_jours.md)."
ef["A2"].font = F_NOTE
for j, t in enumerate(["Etape et poste", "Montant", "Cumul", "Condition"], start=1):
    c = ef.cell(row=4, column=j, value=t)
    c.font, c.fill = F_ENTETE, R_ENTETE
EMP = [
    ("#", "Etape 1 : valider la demande (jours 1 à 30)"),
    ("Domaine, page de test, emailing", 150, "Aucune"),
    ("Publicité de test (deux vagues)", 1200, "Aucune"),
    ("iPhone d'occasion compatible Apple Intelligence (test de l'assistant)", 550, "Aucune"),
    ("Entretiens (bons d'achat)", 200, "Aucune"),
    ("#", "Etape 2 : construire et publier la v1 (mois 2 à 5)"),
    ("Mac pour le développement (si tu n'en as pas)", 800, "Go au jour 30"),
    ("Société (SASU), banque, assurance", 900, "Go au jour 30"),
    ("Avocat : mentions santé, licences, conditions de vente", 1500, "Go au jour 30"),
    ("Recherche d'antériorité et dépôt de la marque", 600, "Go au jour 30"),
    ("Développeur iOS indépendant : application v1", 7000, "Deux devis comparés"),
    ("Identité visuelle par un graphiste (sans esthétique d'IA générique)", 2000, "Go au jour 30"),
    ("Relecture des fiches par un secouriste et un médecin", 1200, "30 fiches rédigées"),
    ("Programme développeur Apple (première année)", 100, "Go au jour 30"),
    ("Réserve de lancement (contenus, captures, vidéos de l'App Store)", 400, "Aucune"),
    ("#", "Etape 3 : après la sortie (mois 6 à 12)"),
    ("Développeur (maintenance, v1.1 et v2 avec assistant)", 4000, "Note de 4,5 sur l'App Store, plus de 3 % de passage au payant"),
    ("Contenus, créateurs, relectures", 2500, "Idem"),
    ("Réserve de trésorerie", 16800, "Ne pas descendre sous trois mois de charges"),
]
rr, first = 5, None
for it in EMP:
    if it[0] == "#":
        ef.cell(row=rr, column=1, value=it[1]).font = F_SECTION
        for j in range(1, 5):
            ef.cell(row=rr, column=j).fill = R_SECTION
        rr += 1
        continue
    lib, m, cond = it
    if lib.startswith("Réserve de lancement"):
        fin_etape2 = rr
    ef.cell(row=rr, column=1, value=lib).font = F_NORMAL
    c = ef.cell(row=rr, column=2, value=m)
    c.font, c.number_format = F_INPUT, EUR
    first = first or rr
    c = ef.cell(row=rr, column=3, value=f"=SUM($B${first}:B{rr})")
    c.number_format, c.font = EUR, F_NORMAL
    ef.cell(row=rr, column=4, value=cond).font = F_NOTE
    rr += 1
ef.cell(row=rr + 1, column=1, value="Total si toutes les étapes sont franchies").font = F_GRAS
c = ef.cell(row=rr + 1, column=2, value=f"=SUM(B{first}:B{rr - 1})")
c.font, c.number_format, c.fill = F_GRAS, EUR, R_TOTAL
ef.cell(row=rr + 2, column=1, value="Etapes 1 et 2 seulement (engagées avant la première vente)").font = F_NORMAL
c = ef.cell(row=rr + 2, column=2, value=f"=SUM(B{first}:B{fin_etape2})")
c.font, c.number_format = F_NORMAL, EUR
ef.column_dimensions["A"].width = 72
ef.column_dimensions["B"].width = 13
ef.column_dimensions["C"].width = 13
ef.column_dimensions["D"].width = 60

wb._sheets = [wb[n] for n in ["Lisez_moi", "Hypotheses", "Unitaire", "Synthese", "M_Prudent", "M_Central", "M_Ambitieux", "Sensibilites", "Emploi_des_fonds"]]
wb.active = 0
wb.save(SORTIE)
print(f"Classeur écrit : {SORTIE}")
