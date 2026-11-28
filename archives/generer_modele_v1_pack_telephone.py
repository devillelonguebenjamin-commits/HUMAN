#!/usr/bin/env python3
"""Génère modele_financier.xlsx (projet HUMAN, phase 1).

Le classeur ne contient que des hypothèses saisies (en bleu) et des formules.
Trois scénarios (Prudent, Central, Ambitieux) sont calculés côte à côte sur 36 mois.

Usage :
    python3 outils/generer_modele_financier.py [chemin_de_sortie.xlsx]

Après génération, recalculer les formules avec LibreOffice (script recalc.py de la
compétence xlsx, ou simple ouverture dans Excel / LibreOffice).
"""
import sys
from openpyxl import Workbook
from openpyxl.comments import Comment
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter as L

SORTIE = sys.argv[1] if len(sys.argv) > 1 else "modele_financier.xlsx"

POLICE = "Arial"
F_TITRE = Font(name=POLICE, size=14, bold=True)
F_SECTION = Font(name=POLICE, size=10, bold=True, color="FFFFFF")
F_ENTETE = Font(name=POLICE, size=10, bold=True)
F_NORMAL = Font(name=POLICE, size=10)
F_GRAS = Font(name=POLICE, size=10, bold=True)
F_INPUT = Font(name=POLICE, size=10, color="0000FF")
F_LIEN = Font(name=POLICE, size=10, color="008000")
F_NOTE = Font(name=POLICE, size=9, italic=True, color="555555")
REMPL_SECTION = PatternFill("solid", fgColor="1F3A5F")
REMPL_ENTETE = PatternFill("solid", fgColor="D9E2EC")
REMPL_CLE = PatternFill("solid", fgColor="FFFF00")
REMPL_TOTAL = PatternFill("solid", fgColor="EEF2F6")
FIN = Side(style="thin", color="BBBBBB")
BORD_BAS = Border(bottom=FIN)

FMT_EUR = '#,##0 "€";(#,##0 "€");"-"'
FMT_EUR2 = '#,##0.00 "€";(#,##0.00 "€");"-"'
FMT_PCT = '0.0%;(0.0%);"-"'
FMT_NB = '#,##0;(#,##0);"-"'
FMT_NB1 = '#,##0.0;(#,##0.0);"-"'
FMT_X = '0.0"x"'

SCEN = ["Prudent", "Central", "Ambitieux"]
SCEN_COL = {"Prudent": "C", "Central": "D", "Ambitieux": "E"}
NB_MOIS = 36
COL0 = 3  # première colonne mensuelle (C)

wb = Workbook()

# --------------------------------------------------------------------------
# Feuille Lisez_moi
# --------------------------------------------------------------------------
lm = wb.active
lm.title = "Lisez_moi"
lignes = [
    ("Modèle financier HUMAN, phase 1 (exploration)", F_TITRE),
    ("Généré le 12/11/2026 par outils/generer_modele_financier.py. Montants en euros hors taxe sauf mention contraire.", F_NORMAL),
    ("", F_NORMAL),
    ("Comment utiliser ce classeur", F_GRAS),
    ("1. Toutes les hypothèses sont dans la feuille Hypotheses, une colonne par scénario (Prudent, Central, Ambitieux).", F_NORMAL),
    ("2. Les cellules en bleu sont des saisies modifiables. Les cellules en noir sont des formules. Les cellules en vert reprennent une autre feuille.", F_NORMAL),
    ("3. Les cellules sur fond jaune sont les hypothèses qui pèsent le plus sur le résultat. Ce sont elles que les tests des 30 premiers jours doivent valider.", F_NORMAL),
    ("4. Unitaire : économie unitaire de chaque produit, par scénario. M_Prudent, M_Central, M_Ambitieux : projection mensuelle sur 36 mois.", F_NORMAL),
    ("5. Synthese : résultats annuels des trois scénarios côte à côte. Sensibilites : grilles de sensibilité (choisir le scénario en B3).", F_NORMAL),
    ("6. Emploi_des_fonds : utilisation proposée des 10 000 € initiaux puis de l'enveloppe de 40 000 €.", F_NORMAL),
    ("", F_NORMAL),
    ("Conventions et limites", F_GRAS),
    ("Le mois 1 est le premier mois après la décision de lancement. La TVA est supposée neutre en trésorerie (encaissée puis reversée).", F_NORMAL),
    ("L'EBITDA est calculé avant impôt, avant intérêts d'emprunt et avant amortissements. Les remboursements de prêts figurent dans les flux de financement.", F_NORMAL),
    ("Les valeurs marquées [HYP] sont des hypothèses de travail, [EST] des estimations, [FAIT] des données sourcées (voir sources.md et registre_hypotheses.md).", F_NORMAL),
    ("Aucun chiffre de ce modèle n'est une prévision. Ce sont des scénarios construits pour tester la décision.", F_NORMAL),
]
for i, (txt, police) in enumerate(lignes, start=1):
    c = lm.cell(row=i, column=1, value=txt)
    c.font = police
lm.column_dimensions["A"].width = 150

# --------------------------------------------------------------------------
# Feuille Hypotheses
# --------------------------------------------------------------------------
hy = wb.create_sheet("Hypotheses")
hy["A1"] = "Hypothèses par scénario"
hy["A1"].font = F_TITRE
hy["A2"] = "Bleu = saisie modifiable. Fond jaune = hypothèse clé à valider par les tests. Montants en euros HT sauf mention TTC."
hy["A2"].font = F_NOTE
entetes = ["Paramètre", "Unité", "Prudent", "Central", "Ambitieux", "Statut et source"]
for j, h in enumerate(entetes, start=1):
    c = hy.cell(row=4, column=j, value=h)
    c.font = F_ENTETE
    c.fill = REMPL_ENTETE
    c.alignment = Alignment(horizontal="center" if j > 1 else "left")

P = {}  # clé -> numéro de ligne


def ref(cle, scen):
    """Référence absolue vers l'hypothèse `cle` du scénario `scen`."""
    return f"Hypotheses!${SCEN_COL[scen]}${P[cle]}"


# (clé, libellé, unité, prudent, central, ambitieux, format, clé?, note)
HYP = [
    ("#", "Général"),
    ("tva", "Taux de TVA", "%", 0.20, 0.20, 0.20, FMT_PCT, False, "[FAIT] Taux normal France."),
    ("debut", "Mois de début des ventes", "mois", 4, 3, 3, FMT_NB, False, "[HYP] Après test de demande et application v1."),
    ("#", "Prix de vente (TTC)"),
    ("prix_pack", "Pack carte mémoire 256 Go (savoirs hors ligne, français)", "€ TTC", 79, 89, 89, FMT_EUR, True, "[HYP] A tester en page d'atterrissage. Repères : apps US 25 à 35 USD, Prepper Disk 240 USD."),
    ("prix_num", "Pack numérique (téléchargement)", "€ TTC", 39, 49, 49, FMT_EUR, True, "[HYP] Repère : HAVEN Pro 24,99 USD, achat unique."),
    ("prix_ess", "Téléphone durci Essentiel prêt à l'emploi", "€ TTC", 299, 319, 329, FMT_EUR, True, "[HYP] Téléphone type Armor 22 Pro (prix public UE estimé 190 à 200 € TTC) + pack 128 Go. Prime de préparation à tester."),
    ("prix_auto", "Téléphone durci Autonomie prêt à l'emploi", "€ TTC", 419, 449, 479, FMT_EUR, True, "[HYP] Téléphone type Armor 24 Pro 22 000 mAh (offres UE les plus basses vers 272 € TTC, Kimovil, 12/11/2026) + pack 256 Go."),
    ("prix_b2b", "Téléphone Essentiel en lot B2B", "€ HT", 235, 245, 255, FMT_EUR, False, "[HYP] Remise de volume, paiement par virement."),
    ("#", "Coûts d'achat unitaires (HT)"),
    ("c_carte256", "Carte microSD 256 Go de marque", "€", 32, 28, 26, FMT_EUR2, False, "[EST] Prix de gros France, à confirmer par devis. Marché mémoire tendu."),
    ("c_carte128", "Carte microSD 128 Go de marque", "€", 17, 15, 14, FMT_EUR2, False, "[EST] Idem."),
    ("c_lecteur", "Lecteur de carte USB-C", "€", 3, 3, 3, FMT_EUR2, False, "[EST] Pour les téléphones sans lecteur microSD."),
    ("c_emb", "Emballage et guide papier de démarrage", "€", 3, 2.5, 2.5, FMT_EUR2, False, "[EST]"),
    ("c_dup", "Duplication et contrôle de la carte", "€", 1, 1, 1, FMT_EUR2, False, "[EST] Duplicateur multi-cartes amorti."),
    ("c_heb", "Hébergement et bande passante par téléchargement", "€", 1.5, 1, 1, FMT_EUR2, False, "[EST] Environ 55 Go par client."),
    ("a_ess_g", "Achat téléphone Essentiel via grossiste UE", "€", 170, 160, 155, FMT_EUR2, True, "[HYP] Prix public UE estimé 190 à 200 € TTC, soit environ 160 € HT. A confirmer par devis."),
    ("a_auto_g", "Achat téléphone Autonomie via grossiste UE", "€", 245, 235, 228, FMT_EUR2, True, "[EST] Offres UE les plus basses vers 272 € TTC, soit 227 € HT (Kimovil, 12/11/2026). A confirmer par devis."),
    ("c_prepa", "Préparation et test d'un téléphone", "€", 5, 4, 4, FMT_EUR2, False, "[EST] 10 à 15 minutes par appareil."),
    ("mois_imp", "Mois de passage à l'import direct (0 = jamais)", "mois", 0, 19, 13, FMT_NB, False, "[HYP] Seulement si les volumes le justifient. Statut d'importateur : voir 04_legal.md."),
    ("a_ess_i", "Achat téléphone Essentiel en import direct, rendu France", "€", 140, 135, 130, FMT_EUR2, False, "[HYP] Environ 15 % sous le prix grossiste UE. A confirmer par devis fabricant."),
    ("a_auto_i", "Achat téléphone Autonomie en import direct, rendu France", "€", 208, 198, 190, FMT_EUR2, False, "[HYP] Environ 15 % sous le prix grossiste UE. A confirmer par devis fabricant."),
    ("c_regl", "Coûts réglementaires unitaires en import", "€", 17, 16, 16, FMT_EUR2, False, "[FAIT] Copie privée 14 € HT au-delà de 64 Go. [EST] Eco-contributions et contrôle : 2 à 3 €."),
    ("inv_imp", "Coût fixe du passage à l'import (essais, enregistrements, conseil)", "€", 8000, 6000, 6000, FMT_EUR, False, "[EST] Vérification DAS en laboratoire, filières REP, avocat."),
    ("#", "Coûts variables de vente"),
    ("exp_pack", "Expédition d'un pack carte", "€", 3.5, 3.5, 3.5, FMT_EUR2, False, "[EST] Lettre suivie."),
    ("exp_ess", "Expédition d'un téléphone Essentiel", "€", 8.5, 8.5, 8.5, FMT_EUR2, False, "[EST] Colis suivi avec signature."),
    ("exp_auto", "Expédition d'un téléphone Autonomie", "€", 9.5, 9.5, 9.5, FMT_EUR2, False, "[EST] Colis suivi avec signature, environ 700 g."),
    ("exp_b2b", "Expédition par téléphone en lot B2B", "€", 3, 3, 3, FMT_EUR2, False, "[EST] Envoi groupé."),
    ("pay_pct", "Frais de paiement, part variable (sur le TTC)", "%", 0.015, 0.015, 0.015, FMT_PCT, False, "[EST] Carte européenne standard, à confirmer."),
    ("pay_fixe", "Frais de paiement, part fixe par commande", "€", 0.25, 0.25, 0.25, FMT_EUR2, False, "[EST]"),
    ("sav_pack", "Provision SAV et retours, pack carte", "% CA", 0.05, 0.04, 0.03, FMT_PCT, False, "[HYP]"),
    ("sav_num", "Provision remboursements, pack numérique", "% CA", 0.03, 0.02, 0.02, FMT_PCT, False, "[HYP]"),
    ("sav_tel", "Provision SAV, retours et rétractations, téléphones", "% CA", 0.08, 0.06, 0.05, FMT_PCT, True, "[HYP] Rétractation 14 jours et garantie légale 2 ans à la charge du vendeur."),
    ("logi", "Logistique par commande physique (consommables, préparation)", "€", 1.5, 2, 2.5, FMT_EUR2, False, "[EST]"),
    ("#", "Demande et acquisition"),
    ("org_base", "Commandes organiques le premier mois de vente", "cmd/mois", 10, 25, 40, FMT_NB, True, "[HYP] Liste d'attente, contenus, créateurs. A valider par le test de demande."),
    ("g1", "Croissance mensuelle des commandes organiques, 12 premiers mois de vente", "%", 0.05, 0.09, 0.11, FMT_PCT, True, "[HYP]"),
    ("g2", "Croissance mensuelle des commandes organiques ensuite", "%", 0.02, 0.04, 0.05, FMT_PCT, True, "[HYP]"),
    ("pub1", "Budget publicitaire mensuel, année 1", "€/mois", 400, 800, 1500, FMT_EUR, False, "[HYP]"),
    ("pub2", "Budget publicitaire mensuel, année 2", "€/mois", 600, 2000, 5000, FMT_EUR, False, "[HYP]"),
    ("pub3", "Budget publicitaire mensuel, année 3", "€/mois", 800, 3500, 10000, FMT_EUR, False, "[HYP]"),
    ("cac", "Coût d'acquisition d'une commande payante", "€", 60, 40, 32, FMT_EUR, True, "[EST] Repère : CPA médian e-commerce 30 à 50 USD, électronique 49 USD (2025)."),
    ("mix_pack", "Part des commandes : pack carte", "%", 0.45, 0.40, 0.35, FMT_PCT, True, "[HYP]"),
    ("mix_num", "Part des commandes : pack numérique", "%", 0.30, 0.25, 0.20, FMT_PCT, True, "[HYP]"),
    ("mix_ess", "Part des commandes : téléphone Essentiel", "%", 0.15, 0.20, 0.25, FMT_PCT, True, "[HYP]"),
    ("mix_auto", "Part des commandes : téléphone Autonomie", "%", 0.10, 0.15, 0.20, FMT_PCT, True, "[HYP]"),
    ("att_acc", "Part des commandes avec accessoires", "%", 0.10, 0.15, 0.20, FMT_PCT, False, "[HYP] Radio à manivelle, panneau solaire, batterie externe."),
    ("pan_acc", "Panier accessoires moyen", "€ HT", 40, 45, 50, FMT_EUR, False, "[HYP]"),
    ("mg_acc", "Marge brute sur accessoires", "%", 0.25, 0.30, 0.33, FMT_PCT, False, "[EST] Négoce."),
    ("b2b1", "Unités B2B par mois, année 1", "u/mois", 0, 0, 0, FMT_NB, False, "[HYP]"),
    ("b2b2", "Unités B2B par mois, année 2", "u/mois", 0, 5, 15, FMT_NB, False, "[HYP]"),
    ("b2b3", "Unités B2B par mois, année 3", "u/mois", 3, 15, 40, FMT_NB, False, "[HYP]"),
    ("#", "Charges fixes mensuelles"),
    ("outils", "Outils (boutique en ligne, emailing, hébergement)", "€/mois", 120, 150, 250, FMT_EUR, False, "[EST]"),
    ("compta", "Expert-comptable et assurances", "€/mois", 200, 220, 300, FMT_EUR, False, "[EST] RC professionnelle et produits incluse."),
    ("free1", "Prestataires (développement, contenus, relecture pro), année 1", "€/mois", 200, 300, 600, FMT_EUR, False, "[HYP]"),
    ("free2", "Prestataires, année 2", "€/mois", 200, 500, 1500, FMT_EUR, False, "[HYP]"),
    ("free3", "Prestataires, année 3", "€/mois", 200, 800, 3000, FMT_EUR, False, "[HYP]"),
    ("cont1", "Contenus et créateurs (échantillons, tournages, affiliation), année 1", "€/mois", 100, 250, 500, FMT_EUR, False, "[HYP]"),
    ("cont2", "Contenus et créateurs, année 2", "€/mois", 150, 500, 1500, FMT_EUR, False, "[HYP]"),
    ("cont3", "Contenus et créateurs, année 3", "€/mois", 200, 800, 3000, FMT_EUR, False, "[HYP]"),
    ("remu1", "Rémunération chargée du fondateur, année 1", "€/mois", 0, 0, 0, FMT_EUR, False, "[HYP] Pas de rémunération la première année."),
    ("remu2", "Rémunération chargée du fondateur, année 2", "€/mois", 0, 1500, 2500, FMT_EUR, False, "[HYP]"),
    ("remu3", "Rémunération chargée du fondateur, année 3", "€/mois", 500, 2500, 4500, FMT_EUR, False, "[HYP]"),
    ("equipe1", "Equipe et sous-traitance logistique, année 1", "€/mois", 0, 0, 0, FMT_EUR, False, "[HYP]"),
    ("equipe2", "Equipe et sous-traitance logistique, année 2", "€/mois", 0, 0, 4000, FMT_EUR, False, "[HYP]"),
    ("equipe3", "Equipe et sous-traitance logistique, année 3", "€/mois", 0, 1500, 12000, FMT_EUR, False, "[HYP]"),
    ("divers", "Divers", "€/mois", 80, 100, 200, FMT_EUR, False, "[EST]"),
    ("inv_lanc", "Investissements de lancement (répartis sur les mois 1 à 3)", "€", 8000, 10000, 13000, FMT_EUR, False, "[EST] Tests de demande, application v1, juridique, marque, validation des contenus, téléphones de test, création de société."),
    ("#", "Stock et financement"),
    ("mois_stock", "Stock cible, en mois d'achats du mois suivant", "mois", 1, 1.5, 1.5, FMT_NB1, False, "[HYP] Régime de croisière."),
    ("mois_stock0", "Stock cible pendant les 6 premiers mois de vente", "mois", 0.5, 0.5, 0.5, FMT_NB1, False, "[HYP] Ventes en précommande : le client paie avant l'achat du stock."),
    ("apport1", "Apport initial du fondateur (mois 1)", "€", 10000, 10000, 10000, FMT_EUR, False, "[FAIT] Budget initial indiqué par le fondateur."),
    ("ap2_mois", "Apport complémentaire n°1 : mois", "mois", 2, 2, 2, FMT_NB, False, "[HYP] Débloqué uniquement si la décision au jour 30 est positive."),
    ("ap2", "Apport complémentaire n°1 : montant", "€", 5000, 10000, 15000, FMT_EUR, False, "[HYP] Dans la limite de 40 000 € de fonds propres au total."),
    ("ap3_mois", "Apport complémentaire n°2 : mois (0 = aucun)", "mois", 0, 9, 5, FMT_NB, False, "[HYP] Débloqué uniquement si les seuils de vente sont atteints."),
    ("ap3", "Apport complémentaire n°2 : montant", "€", 0, 5000, 15000, FMT_EUR, False, "[HYP]"),
    ("ph_mois", "Prêt d'honneur : mois de versement (0 = aucun)", "mois", 0, 9, 7, FMT_NB, False, "[HYP] Après preuve de ventes. Taux zéro, à la personne."),
    ("ph", "Prêt d'honneur : montant", "€", 0, 10000, 20000, FMT_EUR, False, "[FAIT] Dispositif de 1 000 à 80 000 €, un tiers maximum du financement total."),
    ("ph_duree", "Prêt d'honneur : durée de remboursement", "mois", 60, 60, 60, FMT_NB, False, "[FAIT] 1 à 7 ans."),
    ("ph_diff", "Prêt d'honneur : différé", "mois", 12, 12, 12, FMT_NB, False, "[FAIT] 0 à 24 mois."),
    ("pb_mois", "Prêt bancaire : mois de versement (0 = aucun)", "mois", 0, 9, 7, FMT_NB, False, "[HYP] Adossé au prêt d'honneur."),
    ("pb", "Prêt bancaire : montant", "€", 0, 10000, 30000, FMT_EUR, False, "[HYP]"),
    ("pb_duree", "Prêt bancaire : durée", "mois", 60, 60, 60, FMT_NB, False, "[HYP]"),
    ("pb_taux", "Prêt bancaire : taux annuel", "%", 0.045, 0.045, 0.045, FMT_PCT, False, "[EST] A confirmer auprès des banques."),
    ("#", "Valorisation indicative"),
    ("mult_bas", "Multiple d'EBITDA, fourchette basse", "x", 2.5, 2.5, 2.5, FMT_X, False, "[FAIT] Marques e-commerce : 1,5x à 7x l'EBITDA ajusté en 2026."),
    ("mult_haut", "Multiple d'EBITDA, fourchette haute", "x", 4.5, 4.5, 4.5, FMT_X, False, "[FAIT] 3,5x à 5,5x pour les marques différenciées."),
]

r = 5
for item in HYP:
    if item[0] == "#":
        c = hy.cell(row=r, column=1, value=item[1])
        c.font = F_SECTION
        for j in range(1, 7):
            hy.cell(row=r, column=j).fill = REMPL_SECTION
        r += 1
        continue
    cle, lib, unite, v1, v2, v3, fmt, est_cle, note = item
    P[cle] = r
    hy.cell(row=r, column=1, value=lib).font = F_NORMAL
    hy.cell(row=r, column=2, value=unite).font = F_NORMAL
    hy.cell(row=r, column=2).alignment = Alignment(horizontal="center")
    for j, v in zip((3, 4, 5), (v1, v2, v3)):
        c = hy.cell(row=r, column=j, value=v)
        c.font = F_INPUT
        c.number_format = fmt
        if est_cle:
            c.fill = REMPL_CLE
    hy.cell(row=r, column=6, value=note).font = F_NOTE
    r += 1

# Contrôle : la somme du mix doit faire 100 %
r += 1
hy.cell(row=r, column=1, value="Contrôle : somme des parts de commandes (doit être égale à 100 %)").font = F_GRAS
for j, s in zip((3, 4, 5), SCEN):
    col = SCEN_COL[s]
    c = hy.cell(row=r, column=j,
                value=f"={col}{P['mix_pack']}+{col}{P['mix_num']}+{col}{P['mix_ess']}+{col}{P['mix_auto']}")
    c.font = F_GRAS
    c.number_format = FMT_PCT
R_CTRL_MIX = r
r += 1
hy.cell(row=r, column=1, value="Contrôle : total des fonds propres apportés (plafond indiqué par le fondateur : 40 000 €)").font = F_GRAS
for j, s in zip((3, 4, 5), SCEN):
    col = SCEN_COL[s]
    c = hy.cell(row=r, column=j,
                value=f"={col}{P['apport1']}+{col}{P['ap2']}+IF({col}{P['ap3_mois']}>0,{col}{P['ap3']},0)")
    c.font = F_GRAS
    c.number_format = FMT_EUR

hy.column_dimensions["A"].width = 68
hy.column_dimensions["B"].width = 10
for col in "CDE":
    hy.column_dimensions[col].width = 13
hy.column_dimensions["F"].width = 105
hy.freeze_panes = "C5"

# --------------------------------------------------------------------------
# Feuille Unitaire : un bloc par scénario
# --------------------------------------------------------------------------
un = wb.create_sheet("Unitaire")
un["A1"] = "Economie unitaire par produit et par scénario (euros HT)"
un["A1"].font = F_TITRE
un["A2"] = "Toutes les cellules sont des formules alimentées par la feuille Hypotheses."
un["A2"].font = F_NOTE
PRODUITS = ["Pack carte 256 Go", "Pack numérique", "Tél. Essentiel (grossiste UE)", "Tél. Autonomie (grossiste UE)",
            "Tél. Essentiel (import direct)", "Tél. Autonomie (import direct)", "Tél. Essentiel (lot B2B)",
            "Tél. Essentiel (lot B2B, import)"]
PCOL = {"pack": "B", "num": "C", "ess_g": "D", "auto_g": "E", "ess_i": "F", "auto_i": "G", "b2b": "H", "b2b_i": "I"}
U = {}  # (scenario, ligne, produit) -> référence

bloc = 4
for s in SCEN:
    h = lambda k: ref(k, s)  # noqa: E731
    c = un.cell(row=bloc, column=1, value=f"Scénario {s}")
    c.font = F_SECTION
    for j in range(1, 10):
        un.cell(row=bloc, column=j).fill = REMPL_SECTION
    for j, p in enumerate(PRODUITS, start=2):
        c = un.cell(row=bloc + 1, column=j, value=p)
        c.font = F_ENTETE
        c.fill = REMPL_ENTETE
        c.alignment = Alignment(horizontal="center", wrap_text=True)
    un.cell(row=bloc + 1, column=1, value="Par unité vendue").font = F_ENTETE
    un.cell(row=bloc + 1, column=1).fill = REMPL_ENTETE
    lignes_u = ["prix_ttc", "prix_ht", "achat", "exped", "paiement", "sav", "logi", "cv", "marge", "taux"]
    libelles = {
        "prix_ttc": "Prix de vente TTC", "prix_ht": "Prix de vente HT", "achat": "Coût d'achat et de préparation",
        "exped": "Expédition", "paiement": "Frais de paiement", "sav": "Provision SAV et retours",
        "logi": "Logistique", "cv": "Total des coûts variables", "marge": "Marge de contribution unitaire (avant acquisition)",
        "taux": "Taux de marge de contribution",
    }
    R = {k: bloc + 2 + i for i, k in enumerate(lignes_u)}
    for k in lignes_u:
        c = un.cell(row=R[k], column=1, value=libelles[k])
        c.font = F_GRAS if k in ("cv", "marge", "taux") else F_NORMAL
    tva = h("tva")
    carte256 = f"({h('c_carte256')}+{h('c_emb')}+{h('c_dup')})"
    carte128 = f"({h('c_carte128')}+{h('c_emb')}+{h('c_dup')})"
    defs = {
        "pack": dict(ttc=f"={h('prix_pack')}", ht=None,
                     achat=f"={h('c_carte256')}+{h('c_lecteur')}+{h('c_emb')}+{h('c_dup')}",
                     exped=f"={h('exp_pack')}", pay=True, sav=h("sav_pack"), logi=True),
        "num": dict(ttc=f"={h('prix_num')}", ht=None, achat=f"={h('c_heb')}", exped="=0", pay=True,
                    sav=h("sav_num"), logi=False),
        "ess_g": dict(ttc=f"={h('prix_ess')}", ht=None, achat=f"={h('a_ess_g')}+{carte128}+{h('c_prepa')}",
                      exped=f"={h('exp_ess')}", pay=True, sav=h("sav_tel"), logi=True),
        "auto_g": dict(ttc=f"={h('prix_auto')}", ht=None, achat=f"={h('a_auto_g')}+{carte256}+{h('c_prepa')}",
                       exped=f"={h('exp_auto')}", pay=True, sav=h("sav_tel"), logi=True),
        "ess_i": dict(ttc=f"={h('prix_ess')}", ht=None,
                      achat=f"={h('a_ess_i')}+{h('c_regl')}+{carte128}+{h('c_prepa')}",
                      exped=f"={h('exp_ess')}", pay=True, sav=h("sav_tel"), logi=True),
        "auto_i": dict(ttc=f"={h('prix_auto')}", ht=None,
                       achat=f"={h('a_auto_i')}+{h('c_regl')}+{carte256}+{h('c_prepa')}",
                       exped=f"={h('exp_auto')}", pay=True, sav=h("sav_tel"), logi=True),
        "b2b": dict(ttc=None, ht=f"={h('prix_b2b')}", achat=f"={h('a_ess_g')}+{carte128}+{h('c_prepa')}",
                    exped=f"={h('exp_b2b')}", pay=False, sav=h("sav_tel"), logi=True),
        "b2b_i": dict(ttc=None, ht=f"={h('prix_b2b')}",
                      achat=f"={h('a_ess_i')}+{h('c_regl')}+{carte128}+{h('c_prepa')}",
                      exped=f"={h('exp_b2b')}", pay=False, sav=h("sav_tel"), logi=True),
    }
    for p, d in defs.items():
        col = PCOL[p]
        cell = lambda k: f"{col}{R[k]}"  # noqa: E731
        if d["ttc"] is not None:
            un[cell("prix_ttc")] = d["ttc"]
            un[cell("prix_ht")] = f"={cell('prix_ttc')}/(1+{tva})"
        else:
            un[cell("prix_ht")] = d["ht"]
            un[cell("prix_ttc")] = f"={cell('prix_ht')}*(1+{tva})"
        un[cell("achat")] = d["achat"]
        un[cell("exped")] = d["exped"]
        un[cell("paiement")] = (f"={cell('prix_ttc')}*{h('pay_pct')}+{h('pay_fixe')}" if d["pay"] else "=0")
        un[cell("sav")] = f"={cell('prix_ht')}*{d['sav']}"
        un[cell("logi")] = (f"={h('logi')}" if d["logi"] else "=0")
        un[cell("cv")] = f"=SUM({col}{R['achat']}:{col}{R['logi']})"
        un[cell("marge")] = f"={cell('prix_ht')}-{cell('cv')}"
        un[cell("taux")] = f"=IF({cell('prix_ht')}=0,0,{cell('marge')}/{cell('prix_ht')})"
        for k in lignes_u:
            c = un[cell(k)]
            c.number_format = FMT_PCT if k == "taux" else FMT_EUR2
            hyp_direct = k in ("achat", "exped", "logi") or (k == "prix_ttc" and d["ttc"] is not None) \
                or (k == "prix_ht" and d["ttc"] is None)
            c.font = F_LIEN if hyp_direct else (F_GRAS if k in ("cv", "marge", "taux") else F_NORMAL)
            if k in ("cv", "marge", "taux"):
                c.fill = REMPL_TOTAL
            U[(s, k, p)] = f"Unitaire!${col}${R[k]}"
    # Moyennes pondérées par commande (hors B2B)
    rm = bloc + 2 + len(lignes_u) + 1
    un.cell(row=rm, column=1, value="Par commande moyenne (mix du scénario, hors B2B)").font = F_ENTETE
    un.cell(row=rm, column=1).fill = REMPL_ENTETE
    for j, t in ((2, "Achat via grossiste UE"), (3, "Achat en import direct")):
        c = un.cell(row=rm, column=j, value=t)
        c.font = F_ENTETE
        c.fill = REMPL_ENTETE
        c.alignment = Alignment(horizontal="center", wrap_text=True)

    def moy(k, tel_e, tel_a):
        return (f"={h('mix_pack')}*{U[(s, k, 'pack')]}+{h('mix_num')}*{U[(s, k, 'num')]}"
                f"+{h('mix_ess')}*{U[(s, k, tel_e)]}+{h('mix_auto')}*{U[(s, k, tel_a)]}")

    rows_m = [
        ("panier", "Panier moyen HT, hors accessoires", moy("prix_ht", "ess_g", "auto_g"), moy("prix_ht", "ess_i", "auto_i"), FMT_EUR2),
        ("contrib", "Marge de contribution moyenne, hors accessoires", moy("marge", "ess_g", "auto_g"), moy("marge", "ess_i", "auto_i"), FMT_EUR2),
        ("acc", "Marge moyenne sur accessoires par commande", f"={h('att_acc')}*{h('pan_acc')}*{h('mg_acc')}", f"={h('att_acc')}*{h('pan_acc')}*{h('mg_acc')}", FMT_EUR2),
    ]
    for i, (k, lib, f_g, f_i, fmt) in enumerate(rows_m, start=1):
        un.cell(row=rm + i, column=1, value=lib).font = F_NORMAL
        for col, f in (("B", f_g), ("C", f_i)):
            un[f"{col}{rm + i}"] = f
            un[f"{col}{rm + i}"].number_format = fmt
            un[f"{col}{rm + i}"].font = F_NORMAL
        U[(s, k, "g")] = f"Unitaire!$B${rm + i}"
        U[(s, k, "i")] = f"Unitaire!$C${rm + i}"
    rt = rm + 4
    un.cell(row=rt, column=1, value="Marge de contribution totale par commande (avant acquisition)").font = F_GRAS
    for col in ("B", "C"):
        un[f"{col}{rt}"] = f"={col}{rm + 2}+{col}{rm + 3}"
        un[f"{col}{rt}"].number_format = FMT_EUR2
        un[f"{col}{rt}"].font = F_GRAS
        un[f"{col}{rt}"].fill = REMPL_TOTAL
    U[(s, "contrib_tot", "g")] = f"Unitaire!$B${rt}"
    U[(s, "contrib_tot", "i")] = f"Unitaire!$C${rt}"
    un.cell(row=rt + 1, column=1, value="Marge par commande payante après coût d'acquisition").font = F_GRAS
    for col in ("B", "C"):
        un[f"{col}{rt + 1}"] = f"={col}{rt}-{h('cac')}"
        un[f"{col}{rt + 1}"].number_format = FMT_EUR2
        un[f"{col}{rt + 1}"].font = F_GRAS
    U[(s, "apres_cac", "g")] = f"Unitaire!$B${rt + 1}"
    bloc = rt + 4

un.column_dimensions["A"].width = 58
for j in range(2, 10):
    un.column_dimensions[L(j)].width = 19
un.freeze_panes = "B4"

# --------------------------------------------------------------------------
# Feuilles mensuelles
# --------------------------------------------------------------------------
M = {}  # (scenario, clé) -> numéro de ligne (identique pour les trois feuilles)


def feuille_mensuelle(s):
    ws = wb.create_sheet(f"M_{s}")
    h = lambda k: ref(k, s)  # noqa: E731
    ws["A1"] = f"Projection mensuelle sur 36 mois, scénario {s} (euros HT)"
    ws["A1"].font = F_TITRE
    ws["A2"] = "Toutes les cellules sont des formules. Modifier les hypothèses dans la feuille Hypotheses."
    ws["A2"].font = F_NOTE
    premiere, derniere = COL0, COL0 + NB_MOIS - 1
    rows = {}
    cur = [4]

    def ligne(cle, lib, formule, fmt=FMT_EUR, gras=False, total=False):
        """formule : fonction (col_lettre, col_index) -> chaîne de formule."""
        rr = cur[0]
        rows[cle] = rr
        c = ws.cell(row=rr, column=1, value=lib)
        c.font = F_GRAS if gras else F_NORMAL
        for ci in range(premiere, derniere + 1):
            cell = ws.cell(row=rr, column=ci, value=formule(L(ci), ci))
            cell.number_format = fmt
            cell.font = F_GRAS if gras else F_NORMAL
            if total:
                cell.fill = REMPL_TOTAL
        if total:
            ws.cell(row=rr, column=1).fill = REMPL_TOTAL
            ws.cell(row=rr, column=2).fill = REMPL_TOTAL
        cur[0] += 1

    def section(titre):
        rr = cur[0]
        ws.cell(row=rr, column=1, value=titre).font = F_SECTION
        for ci in range(1, derniere + 1):
            ws.cell(row=rr, column=ci).fill = REMPL_SECTION
        cur[0] += 1

    g = lambda cle, col: f"{col}{rows[cle]}"  # noqa: E731

    section("Calendrier")
    ligne("mois", "Mois", lambda c, ci: 1 if ci == premiere else f"={L(ci - 1)}{cur[0]}+1", FMT_NB, gras=True)
    ligne("annee", "Année", lambda c, ci: f"=INT(({g('mois', c)}-1)/12)+1", FMT_NB)
    ligne("n", "Rang du mois de vente (0 = pas encore de vente)", lambda c, ci: f"=MAX(0,{g('mois', c)}-{h('debut')}+1)", FMT_NB)
    ligne("imp", "Import direct actif (1 = oui)", lambda c, ci: f"=IF(AND({h('mois_imp')}>0,{g('mois', c)}>={h('mois_imp')}),1,0)", FMT_NB)

    section("Volumes")
    ligne("org", "Commandes organiques",
          lambda c, ci: f"=IF({g('n', c)}=0,0,{h('org_base')}*(1+{h('g1')})^(MIN({g('n', c)},12)-1)*(1+{h('g2')})^MAX(0,{g('n', c)}-12))", FMT_NB1)
    ligne("pub", "Budget publicitaire",
          lambda c, ci: f"=IF({g('n', c)}=0,0,CHOOSE({g('annee', c)},{h('pub1')},{h('pub2')},{h('pub3')}))")
    ligne("pay", "Commandes payantes", lambda c, ci: f"=IF({h('cac')}>0,{g('pub', c)}/{h('cac')},0)", FMT_NB1)
    ligne("cmd", "Commandes totales (hors B2B)", lambda c, ci: f"={g('org', c)}+{g('pay', c)}", FMT_NB1, gras=True, total=True)
    ligne("u_pack", "Unités pack carte", lambda c, ci: f"={g('cmd', c)}*{h('mix_pack')}", FMT_NB1)
    ligne("u_num", "Unités pack numérique", lambda c, ci: f"={g('cmd', c)}*{h('mix_num')}", FMT_NB1)
    ligne("u_ess", "Unités téléphone Essentiel", lambda c, ci: f"={g('cmd', c)}*{h('mix_ess')}", FMT_NB1)
    ligne("u_auto", "Unités téléphone Autonomie", lambda c, ci: f"={g('cmd', c)}*{h('mix_auto')}", FMT_NB1)
    ligne("u_b2b", "Unités B2B",
          lambda c, ci: f"=IF({g('n', c)}=0,0,CHOOSE({g('annee', c)},{h('b2b1')},{h('b2b2')},{h('b2b3')}))", FMT_NB1)

    u = lambda k, p: U[(s, k, p)]  # noqa: E731
    section("Chiffre d'affaires HT")
    ligne("ca_pack", "Pack carte", lambda c, ci: f"={g('u_pack', c)}*{u('prix_ht', 'pack')}")
    ligne("ca_num", "Pack numérique", lambda c, ci: f"={g('u_num', c)}*{u('prix_ht', 'num')}")
    ligne("ca_ess", "Téléphone Essentiel", lambda c, ci: f"={g('u_ess', c)}*{u('prix_ht', 'ess_g')}")
    ligne("ca_auto", "Téléphone Autonomie", lambda c, ci: f"={g('u_auto', c)}*{u('prix_ht', 'auto_g')}")
    ligne("ca_b2b", "B2B", lambda c, ci: f"={g('u_b2b', c)}*{u('prix_ht', 'b2b')}")
    ligne("ca_acc", "Accessoires", lambda c, ci: f"={g('cmd', c)}*{h('att_acc')}*{h('pan_acc')}")
    ligne("ca", "Chiffre d'affaires total", lambda c, ci: f"=SUM({c}{rows['ca_pack']}:{c}{rows['ca_acc']})", gras=True, total=True)

    section("Coûts variables")
    ligne("ach_pack", "Achats packs carte", lambda c, ci: f"={g('u_pack', c)}*{u('achat', 'pack')}")
    ligne("ach_num", "Hébergement packs numériques", lambda c, ci: f"={g('u_num', c)}*{u('achat', 'num')}")
    ligne("ach_tel", "Achats téléphones (B2C)",
          lambda c, ci: (f"={g('u_ess', c)}*IF({g('imp', c)}=1,{u('achat', 'ess_i')},{u('achat', 'ess_g')})"
                         f"+{g('u_auto', c)}*IF({g('imp', c)}=1,{u('achat', 'auto_i')},{u('achat', 'auto_g')})"))
    ligne("ach_b2b", "Achats téléphones (B2B)",
          lambda c, ci: f"={g('u_b2b', c)}*IF({g('imp', c)}=1,{u('achat', 'b2b_i')},{u('achat', 'b2b')})")
    ligne("ach_acc", "Achats accessoires", lambda c, ci: f"={g('ca_acc', c)}*(1-{h('mg_acc')})")
    ligne("exped", "Expéditions",
          lambda c, ci: (f"={g('u_pack', c)}*{h('exp_pack')}+{g('u_ess', c)}*{h('exp_ess')}"
                         f"+{g('u_auto', c)}*{h('exp_auto')}+{g('u_b2b', c)}*{h('exp_b2b')}"))
    ligne("paiem", "Frais de paiement",
          lambda c, ci: (f"=({g('ca_pack', c)}+{g('ca_num', c)}+{g('ca_ess', c)}+{g('ca_auto', c)}+{g('ca_acc', c)})"
                         f"*(1+{h('tva')})*{h('pay_pct')}+{g('cmd', c)}*{h('pay_fixe')}"))
    ligne("sav", "SAV, retours et rétractations",
          lambda c, ci: (f"={g('ca_pack', c)}*{h('sav_pack')}+{g('ca_num', c)}*{h('sav_num')}"
                         f"+({g('ca_ess', c)}+{g('ca_auto', c)}+{g('ca_b2b', c)})*{h('sav_tel')}"))
    ligne("logi", "Logistique",
          lambda c, ci: f"=({g('u_pack', c)}+{g('u_ess', c)}+{g('u_auto', c)}+{g('u_b2b', c)})*{h('logi')}")
    ligne("cv", "Total des coûts variables", lambda c, ci: f"=SUM({c}{rows['ach_pack']}:{c}{rows['logi']})", gras=True, total=True)
    ligne("mcv", "Marge sur coûts variables", lambda c, ci: f"={g('ca', c)}-{g('cv', c)}", gras=True, total=True)
    ligne("mcv_pct", "Taux de marge sur coûts variables", lambda c, ci: f"=IF({g('ca', c)}=0,0,{g('mcv', c)}/{g('ca', c)})", FMT_PCT)

    section("Acquisition et charges fixes")
    ligne("ch_pub", "Publicité", lambda c, ci: f"={g('pub', c)}")
    ligne("ch_cont", "Contenus et créateurs", lambda c, ci: f"=CHOOSE({g('annee', c)},{h('cont1')},{h('cont2')},{h('cont3')})")
    ligne("ch_outils", "Outils", lambda c, ci: f"={h('outils')}")
    ligne("ch_compta", "Expert-comptable et assurances", lambda c, ci: f"={h('compta')}")
    ligne("ch_free", "Prestataires", lambda c, ci: f"=CHOOSE({g('annee', c)},{h('free1')},{h('free2')},{h('free3')})")
    ligne("ch_remu", "Rémunération du fondateur", lambda c, ci: f"=CHOOSE({g('annee', c)},{h('remu1')},{h('remu2')},{h('remu3')})")
    ligne("ch_equipe", "Equipe et sous-traitance logistique", lambda c, ci: f"=CHOOSE({g('annee', c)},{h('equipe1')},{h('equipe2')},{h('equipe3')})")
    ligne("ch_divers", "Divers", lambda c, ci: f"={h('divers')}")
    ligne("ch_lanc", "Investissements de lancement", lambda c, ci: f"=IF({g('mois', c)}<=3,{h('inv_lanc')}/3,0)")
    ligne("ch_imp", "Coût fixe du passage à l'import", lambda c, ci: f"=IF(AND({h('mois_imp')}>0,{g('mois', c)}={h('mois_imp')}),{h('inv_imp')},0)")
    ligne("ch", "Total acquisition et charges fixes", lambda c, ci: f"=SUM({c}{rows['ch_pub']}:{c}{rows['ch_imp']})", gras=True, total=True)

    section("Résultat")
    ligne("ebitda", "EBITDA", lambda c, ci: f"={g('mcv', c)}-{g('ch', c)}", gras=True, total=True)
    ligne("ebitda_cum", "EBITDA cumulé",
          lambda c, ci: f"={g('ebitda', c)}" if ci == premiere else f"={L(ci - 1)}{cur[0]}+{g('ebitda', c)}")
    ligne("flag_pos", "Indicateur : EBITDA du mois positif (1 = oui)", lambda c, ci: f"=IF({g('ebitda', c)}>0,1,0)", FMT_NB)
    ligne("flag_cum", "Indicateur : EBITDA cumulé positif (1 = oui)", lambda c, ci: f"=IF({g('ebitda_cum', c)}>0,1,0)", FMT_NB)

    section("Trésorerie")

    def stock(c, ci):
        cc = L(ci + 1) if ci < derniere else c
        return (f"=IF({cc}{rows['n']}<=6,{h('mois_stock0')},{h('mois_stock')})*({cc}{rows['ach_pack']}+{cc}{rows['ach_tel']}"
                f"+{cc}{rows['ach_b2b']}+{cc}{rows['ach_acc']})")

    ligne("stock", "Stock cible en fin de mois", stock)
    ligne("d_stock", "Variation de stock (décaissement)",
          lambda c, ci: f"={g('stock', c)}" if ci == premiere else f"={g('stock', c)}-{L(ci - 1)}{rows['stock']}")
    ligne("apports", "Apports du fondateur",
          lambda c, ci: (f"=IF({g('mois', c)}=1,{h('apport1')},0)+IF({g('mois', c)}={h('ap2_mois')},{h('ap2')},0)"
                         f"+IF(AND({h('ap3_mois')}>0,{g('mois', c)}={h('ap3_mois')}),{h('ap3')},0)"))
    ligne("ph_in", "Prêt d'honneur : versement",
          lambda c, ci: f"=IF(AND({h('ph_mois')}>0,{g('mois', c)}={h('ph_mois')}),{h('ph')},0)")
    ligne("ph_out", "Prêt d'honneur : remboursement",
          lambda c, ci: (f"=IF(AND({h('ph_mois')}>0,{g('mois', c)}>{h('ph_mois')}+{h('ph_diff')},"
                         f"{g('mois', c)}<={h('ph_mois')}+{h('ph_diff')}+{h('ph_duree')}),{h('ph')}/{h('ph_duree')},0)"))
    ligne("pb_in", "Prêt bancaire : versement",
          lambda c, ci: f"=IF(AND({h('pb_mois')}>0,{g('mois', c)}={h('pb_mois')}),{h('pb')},0)")
    ligne("pb_out", "Prêt bancaire : mensualité (capital et intérêts)",
          lambda c, ci: (f"=IF(AND({h('pb_mois')}>0,{g('mois', c)}>{h('pb_mois')},{g('mois', c)}<={h('pb_mois')}+{h('pb_duree')}),"
                         f"-PMT({h('pb_taux')}/12,{h('pb_duree')},{h('pb')}),0)"))
    ligne("flux", "Flux net de trésorerie",
          lambda c, ci: (f"={g('ebitda', c)}-{g('d_stock', c)}+{g('apports', c)}+{g('ph_in', c)}-{g('ph_out', c)}"
                         f"+{g('pb_in', c)}-{g('pb_out', c)}"), gras=True)
    ligne("treso", "Trésorerie en fin de mois",
          lambda c, ci: f"={g('flux', c)}" if ci == premiere else f"={L(ci - 1)}{cur[0]}+{g('flux', c)}", gras=True, total=True)
    ligne("flag_neg", "Indicateur : trésorerie négative (1 = oui)", lambda c, ci: f"=IF({g('treso', c)}<0,1,0)", FMT_NB)

    ws.column_dimensions["A"].width = 46
    ws.column_dimensions["B"].width = 2
    for ci in range(premiere, derniere + 1):
        ws.column_dimensions[L(ci)].width = 11
    ws.freeze_panes = ws.cell(row=5, column=premiere)
    for k, v in rows.items():
        M[(s, k)] = v


for s in SCEN:
    feuille_mensuelle(s)

C1, C2 = L(COL0), L(COL0 + NB_MOIS - 1)


def plage(s, cle):
    rr = M[(s, cle)]
    return f"M_{s}!${C1}${rr}:${C2}${rr}"


# --------------------------------------------------------------------------
# Feuille Synthese
# --------------------------------------------------------------------------
sy = wb.create_sheet("Synthese")
sy["A1"] = "Synthèse des trois scénarios sur 36 mois (euros HT)"
sy["A1"].font = F_TITRE
sy["A2"] = "Toutes les cellules sont des formules. Ces scénarios ne sont pas des prévisions."
sy["A2"].font = F_NOTE

sy.cell(row=4, column=1, value="Indicateur").font = F_ENTETE
col = 2
SYCOL = {}
for s in SCEN:
    for a in (1, 2, 3):
        c = sy.cell(row=4, column=col, value=f"{s} A{a}")
        c.font = F_ENTETE
        c.fill = REMPL_ENTETE
        c.alignment = Alignment(horizontal="center")
        SYCOL[(s, a)] = col
        col += 1
sy.cell(row=4, column=1).fill = REMPL_ENTETE

ANNUEL = [
    ("Commandes (hors B2B)", "cmd", FMT_NB, "sum"),
    ("Unités B2B", "u_b2b", FMT_NB, "sum"),
    ("Téléphones vendus (B2C et B2B)", ("u_ess", "u_auto", "u_b2b"), FMT_NB, "sum"),
    ("Chiffre d'affaires", "ca", FMT_EUR, "sum"),
    ("Coûts variables", "cv", FMT_EUR, "sum"),
    ("Marge sur coûts variables", "mcv", FMT_EUR, "sum"),
    ("Publicité, contenus et créateurs", ("ch_pub", "ch_cont"), FMT_EUR, "sum"),
    ("Autres charges fixes et investissements", ("ch_outils", "ch_compta", "ch_free", "ch_remu", "ch_equipe", "ch_divers", "ch_lanc", "ch_imp"), FMT_EUR, "sum"),
    ("EBITDA", "ebitda", FMT_EUR, "sum"),
    ("dont rémunération du fondateur (déjà déduite)", "ch_remu", FMT_EUR, "sum"),
]
SY = {}
rr = 5
for lib, cle, fmt, mode in ANNUEL:
    sy.cell(row=rr, column=1, value=lib).font = F_GRAS if lib in ("Chiffre d'affaires", "EBITDA") else F_NORMAL
    for s in SCEN:
        for a in (1, 2, 3):
            cles = cle if isinstance(cle, tuple) else (cle,)
            f = "=" + "+".join(f"SUMIF({plage(s, 'annee')},{a},{plage(s, k)})" for k in cles)
            c = sy.cell(row=rr, column=SYCOL[(s, a)], value=f)
            c.number_format = fmt
            c.font = F_GRAS if lib in ("Chiffre d'affaires", "EBITDA") else F_LIEN
            if lib in ("Chiffre d'affaires", "EBITDA"):
                c.fill = REMPL_TOTAL
    SY[lib] = rr
    rr += 1
# Ratios
sy.cell(row=rr, column=1, value="Taux de marge sur coûts variables").font = F_NORMAL
for s in SCEN:
    for a in (1, 2, 3):
        cl = L(SYCOL[(s, a)])
        c = sy.cell(row=rr, column=SYCOL[(s, a)],
                    value=f"=IF({cl}{SY['Chiffre d' + chr(39) + 'affaires']}=0,0,{cl}{SY['Marge sur coûts variables']}/{cl}{SY['Chiffre d' + chr(39) + 'affaires']})")
        c.number_format = FMT_PCT
        c.font = F_NORMAL
rr += 1
sy.cell(row=rr, column=1, value="EBITDA en % du chiffre d'affaires").font = F_NORMAL
for s in SCEN:
    for a in (1, 2, 3):
        cl = L(SYCOL[(s, a)])
        c = sy.cell(row=rr, column=SYCOL[(s, a)],
                    value=f"=IF({cl}{SY['Chiffre d' + chr(39) + 'affaires']}=0,0,{cl}{SY['EBITDA']}/{cl}{SY['Chiffre d' + chr(39) + 'affaires']})")
        c.number_format = FMT_PCT
        c.font = F_NORMAL
rr += 1
sy.cell(row=rr, column=1, value="Panier moyen HT par commande (hors B2B)").font = F_NORMAL
for s in SCEN:
    for a in (1, 2, 3):
        cl = L(SYCOL[(s, a)])
        f = (f"=IF({cl}{SY['Commandes (hors B2B)']}=0,0,(" + "+".join(
            f"SUMIF({plage(s, 'annee')},{a},{plage(s, k)})" for k in ("ca_pack", "ca_num", "ca_ess", "ca_auto", "ca_acc"))
            + f")/{cl}{SY['Commandes (hors B2B)']})")
        c = sy.cell(row=rr, column=SYCOL[(s, a)], value=f)
        c.number_format = FMT_EUR
        c.font = F_NORMAL
rr += 1
sy.cell(row=rr, column=1, value="Trésorerie en fin d'année").font = F_GRAS
for s in SCEN:
    for a in (1, 2, 3):
        c = sy.cell(row=rr, column=SYCOL[(s, a)], value=f"=INDEX({plage(s, 'treso')},1,{12 * a})")
        c.number_format = FMT_EUR
        c.font = F_GRAS
        c.fill = REMPL_TOTAL
R_TRESO_AN = rr
rr += 2

sy.cell(row=rr, column=1, value="Indicateurs sur 36 mois").font = F_ENTETE
sy.cell(row=rr, column=1).fill = REMPL_ENTETE
for j, s in enumerate(SCEN, start=2):
    c = sy.cell(row=rr, column=j, value=s)
    c.font = F_ENTETE
    c.fill = REMPL_ENTETE
    c.alignment = Alignment(horizontal="center")
rr += 1
KPI = [
    ("Chiffre d'affaires cumulé sur 36 mois", lambda s: f"=SUM({plage(s, 'ca')})", FMT_EUR),
    ("EBITDA cumulé sur 36 mois", lambda s: f"=SUM({plage(s, 'ebitda')})", FMT_EUR),
    ("Trésorerie minimale sur la période", lambda s: f"=MIN({plage(s, 'treso')})", FMT_EUR),
    ("Mois du point bas de trésorerie", lambda s: f"=MATCH(MIN({plage(s, 'treso')}),{plage(s, 'treso')},0)", FMT_NB),
    ("Premier mois avec trésorerie négative (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{plage(s, 'flag_neg')},0),0)", FMT_NB),
    ("Premier mois à EBITDA positif (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{plage(s, 'flag_pos')},0),0)", FMT_NB),
    ("Premier mois où l'EBITDA cumulé devient positif (0 = jamais)", lambda s: f"=IFERROR(MATCH(1,{plage(s, 'flag_cum')},0),0)", FMT_NB),
    ("Perte cumulée maximale (point bas de l'EBITDA cumulé)", lambda s: f"=MIN(0,MIN({plage(s, 'ebitda_cum')}))", FMT_EUR),
    ("Fonds propres apportés par le fondateur", lambda s: f"=SUM({plage(s, 'apports')})", FMT_EUR),
    ("Emprunts mobilisés", lambda s: f"=SUM({plage(s, 'ph_in')})+SUM({plage(s, 'pb_in')})", FMT_EUR),
    ("Trésorerie au mois 36", lambda s: f"=INDEX({plage(s, 'treso')},1,{NB_MOIS})", FMT_EUR),
    ("Marge de contribution par commande, avant acquisition", lambda s: f"={U[(s, 'contrib_tot', 'g')]}", FMT_EUR2),
    ("Marge par commande payante, après coût d'acquisition", lambda s: f"={U[(s, 'apres_cac', 'g')]}", FMT_EUR2),
    ("Valorisation indicative basse (EBITDA année 3 x multiple bas)", lambda s: f"=MAX(0,{L(SYCOL[(s, 3)])}{SY['EBITDA']})*{ref('mult_bas', s)}", FMT_EUR),
    ("Valorisation indicative haute (EBITDA année 3 x multiple haut)", lambda s: f"=MAX(0,{L(SYCOL[(s, 3)])}{SY['EBITDA']})*{ref('mult_haut', s)}", FMT_EUR),
]
for lib, fn, fmt in KPI:
    sy.cell(row=rr, column=1, value=lib).font = F_NORMAL
    for j, s in enumerate(SCEN, start=2):
        c = sy.cell(row=rr, column=j, value=fn(s))
        c.number_format = fmt
        c.font = F_LIEN
    rr += 1
rr += 1
sy.cell(row=rr, column=1, value="Lecture : une trésorerie négative signifie que le scénario n'est pas finançable en l'état. C'est le signal d'arrêt, pas une invitation à emprunter.").font = F_NOTE
sy.column_dimensions["A"].width = 62
for j in range(2, 11):
    sy.column_dimensions[L(j)].width = 15
sy.freeze_panes = "B5"

# --------------------------------------------------------------------------
# Feuille Sensibilites
# --------------------------------------------------------------------------
se = wb.create_sheet("Sensibilites")
se["A1"] = "Analyses de sensibilité"
se["A1"].font = F_TITRE
se["A3"] = "Scénario analysé (1 = Prudent, 2 = Central, 3 = Ambitieux)"
se["A3"].font = F_GRAS
se["B3"] = 2
se["B3"].font = F_INPUT
se["B3"].fill = REMPL_CLE
se["C3"] = '=CHOOSE($B$3,"Prudent","Central","Ambitieux")'
se["C3"].font = F_GRAS


def choix(fn):
    """CHOOSE sur le scénario sélectionné ; fn(scenario) -> référence."""
    return f"CHOOSE($B$3,{fn('Prudent')},{fn('Central')},{fn('Ambitieux')})"


se["A5"] = "Valeurs de base du scénario"
se["A5"].font = F_ENTETE
base = [
    ("Panier moyen HT par commande, hors accessoires", choix(lambda s: U[(s, "panier", "g")]), FMT_EUR2),
    ("Marge de contribution par commande, avant acquisition", choix(lambda s: U[(s, "contrib_tot", "g")]), FMT_EUR2),
    ("Coût d'acquisition d'une commande payante", choix(lambda s: ref("cac", s)), FMT_EUR2),
    ("Taux de frais proportionnels au prix (paiement et SAV, approximation)", f"={choix(lambda s: ref('pay_pct', s))}*(1+{choix(lambda s: ref('tva', s))})+{choix(lambda s: ref('sav_tel', s))}", FMT_PCT),
    ("Charges fixes mensuelles année 1 (hors publicité et lancement)", choix(lambda s: f"({ref('outils', s)}+{ref('compta', s)}+{ref('free1', s)}+{ref('cont1', s)}+{ref('remu1', s)}+{ref('equipe1', s)}+{ref('divers', s)})"), FMT_EUR),
    ("Charges fixes mensuelles année 2", choix(lambda s: f"({ref('outils', s)}+{ref('compta', s)}+{ref('free2', s)}+{ref('cont2', s)}+{ref('remu2', s)}+{ref('equipe2', s)}+{ref('divers', s)})"), FMT_EUR),
    ("Charges fixes mensuelles année 3", choix(lambda s: f"({ref('outils', s)}+{ref('compta', s)}+{ref('free3', s)}+{ref('cont3', s)}+{ref('remu3', s)}+{ref('equipe3', s)}+{ref('divers', s)})"), FMT_EUR),
]
B = {}
for i, (lib, f, fmt) in enumerate(base, start=6):
    se.cell(row=i, column=1, value=lib).font = F_NORMAL
    c = se.cell(row=i, column=2, value=f if f.startswith("=") else "=" + f)
    c.number_format = fmt
    c.font = F_LIEN
    B[i - 6] = f"$B${i}"
PANIER, CONTRIB, CAC_B, FRAIS, FIX1, FIX2, FIX3 = (B[i] for i in range(7))

# Grille 1 : marge par commande payante selon CAC et variation de prix
r0 = 15
se.cell(row=r0, column=1, value="Grille 1 : marge par commande payante (euros) selon le coût d'acquisition et la variation des prix de vente").font = F_ENTETE
se.cell(row=r0 + 1, column=1, value="Coût d'acquisition (lignes) / variation des prix (colonnes)").font = F_NOTE
variations = [-0.15, -0.10, -0.05, 0, 0.05, 0.10, 0.15]
cacs = [15, 25, 32, 40, 50, 60, 80]
for j, v in enumerate(variations, start=2):
    c = se.cell(row=r0 + 1, column=j, value=v)
    c.number_format = '+0%;-0%;0%'
    c.font = F_INPUT
    c.fill = REMPL_ENTETE
for i, k in enumerate(cacs, start=r0 + 2):
    c = se.cell(row=i, column=1, value=k)
    c.number_format = FMT_EUR
    c.font = F_INPUT
    c.alignment = Alignment(horizontal="right")
    for j in range(2, 2 + len(variations)):
        cl = L(j)
        cell = se.cell(row=i, column=j, value=f"={CONTRIB}+{cl}${r0 + 1}*{PANIER}*(1-{FRAIS})-$A{i}")
        cell.number_format = FMT_EUR2
        cell.font = F_NORMAL

# Grille 2 : commandes mensuelles au point mort
r1 = r0 + 2 + len(cacs) + 2
se.cell(row=r1, column=1, value="Grille 2 : commandes mensuelles nécessaires pour couvrir les charges fixes, selon la part de commandes payantes").font = F_ENTETE
se.cell(row=r1 + 1, column=1, value="Niveau de charges fixes (lignes) / part des commandes issues de la publicité (colonnes)").font = F_NOTE
parts = [0, 0.25, 0.5, 0.75, 1]
for j, v in enumerate(parts, start=2):
    c = se.cell(row=r1 + 1, column=j, value=v)
    c.number_format = '0%'
    c.font = F_INPUT
    c.fill = REMPL_ENTETE
for i, (lib, fx) in enumerate((("Charges fixes année 1", FIX1), ("Charges fixes année 2", FIX2), ("Charges fixes année 3", FIX3)), start=r1 + 2):
    se.cell(row=i, column=1, value=lib).font = F_NORMAL
    for j in range(2, 2 + len(parts)):
        cl = L(j)
        cell = se.cell(row=i, column=j,
                       value=f'=IF({CONTRIB}-{cl}${r1 + 1}*{CAC_B}<=0,"Impossible",{fx}/({CONTRIB}-{cl}${r1 + 1}*{CAC_B}))')
        cell.number_format = FMT_NB
        cell.font = F_NORMAL
        cell.alignment = Alignment(horizontal="right")

# Grille 3 : téléphone Autonomie, marge unitaire selon prix d'achat et prix de vente
r2 = r1 + 2 + 3 + 2
se.cell(row=r2, column=1, value="Grille 3 : marge de contribution d'un téléphone Autonomie (euros) selon le prix d'achat HT et le prix de vente TTC").font = F_ENTETE
se.cell(row=r2 + 1, column=1, value="Prix d'achat HT du téléphone nu (lignes) / prix de vente TTC du téléphone prêt à l'emploi (colonnes)").font = F_NOTE
pv = [379, 399, 429, 449, 479, 499]
pa = [190, 205, 220, 235, 250, 265]
for j, v in enumerate(pv, start=2):
    c = se.cell(row=r2 + 1, column=j, value=v)
    c.number_format = FMT_EUR
    c.font = F_INPUT
    c.fill = REMPL_ENTETE
tva_c = choix(lambda s: ref("tva", s))
pack_c = choix(lambda s: f"({ref('c_carte256', s)}+{ref('c_emb', s)}+{ref('c_dup', s)}+{ref('c_prepa', s)})")
exp_c = choix(lambda s: ref("exp_auto", s))
payp_c = choix(lambda s: ref("pay_pct", s))
payf_c = choix(lambda s: ref("pay_fixe", s))
sav_c = choix(lambda s: ref("sav_tel", s))
logi_c = choix(lambda s: ref("logi", s))
for i, k in enumerate(pa, start=r2 + 2):
    c = se.cell(row=i, column=1, value=k)
    c.number_format = FMT_EUR
    c.font = F_INPUT
    c.alignment = Alignment(horizontal="right")
    for j in range(2, 2 + len(pv)):
        cl = L(j)
        ht = f"{cl}${r2 + 1}/(1+{tva_c})"
        cell = se.cell(row=i, column=j,
                       value=(f"={ht}-$A{i}-{pack_c}-{exp_c}-({cl}${r2 + 1}*{payp_c}+{payf_c})-{ht}*{sav_c}-{logi_c}"))
        cell.number_format = FMT_EUR2
        cell.font = F_NORMAL

# Grille 4 : pack carte, marge unitaire selon prix de vente et coût de la carte
r3 = r2 + 2 + len(pa) + 2
se.cell(row=r3, column=1, value="Grille 4 : marge de contribution d'un pack carte (euros) selon le coût de la carte 256 Go et le prix de vente TTC").font = F_ENTETE
se.cell(row=r3 + 1, column=1, value="Coût HT de la carte (lignes) / prix de vente TTC du pack (colonnes)").font = F_NOTE
pvp = [59, 69, 79, 89, 99, 119]
cc = [20, 24, 28, 32, 38, 45]
for j, v in enumerate(pvp, start=2):
    c = se.cell(row=r3 + 1, column=j, value=v)
    c.number_format = FMT_EUR
    c.font = F_INPUT
    c.fill = REMPL_ENTETE
autres_c = choix(lambda s: f"({ref('c_lecteur', s)}+{ref('c_emb', s)}+{ref('c_dup', s)})")
expp_c = choix(lambda s: ref("exp_pack", s))
savp_c = choix(lambda s: ref("sav_pack", s))
for i, k in enumerate(cc, start=r3 + 2):
    c = se.cell(row=i, column=1, value=k)
    c.number_format = FMT_EUR
    c.font = F_INPUT
    c.alignment = Alignment(horizontal="right")
    for j in range(2, 2 + len(pvp)):
        cl = L(j)
        ht = f"{cl}${r3 + 1}/(1+{tva_c})"
        cell = se.cell(row=i, column=j,
                       value=(f"={ht}-$A{i}-{autres_c}-{expp_c}-({cl}${r3 + 1}*{payp_c}+{payf_c})-{ht}*{savp_c}-{logi_c}"))
        cell.number_format = FMT_EUR2
        cell.font = F_NORMAL
se.cell(row=r3 + 2 + len(cc) + 1, column=1,
        value="Les en-têtes de lignes et de colonnes en bleu sont modifiables. Les grilles se recalculent avec le scénario choisi en B3.").font = F_NOTE
se.column_dimensions["A"].width = 70
for j in range(2, 10):
    se.column_dimensions[L(j)].width = 13

# --------------------------------------------------------------------------
# Feuille Emploi_des_fonds
# --------------------------------------------------------------------------
ef = wb.create_sheet("Emploi_des_fonds")
ef["A1"] = "Emploi des fonds : 10 000 € puis jusqu'à 40 000 € (euros HT)"
ef["A1"].font = F_TITRE
ef["A2"] = "Montants en bleu modifiables. Chaque étape n'est engagée que si l'étape précédente a franchi son seuil de validation (voir plan_30_jours.md et 07_risques_decision.md)."
ef["A2"].font = F_NOTE
for j, h_ in enumerate(["Etape et poste", "Montant", "Cumul", "Condition de déblocage"], start=1):
    c = ef.cell(row=4, column=j, value=h_)
    c.font = F_ENTETE
    c.fill = REMPL_ENTETE
EMPLOIS = [
    ("#", "Etape 1 : valider la demande (jours 1 à 30). Enveloppe : 10 000 € initiaux"),
    ("Nom de domaine, page d'atterrissage, outil d'emailing", 150, "Aucune"),
    ("Publicité de test (deux vagues, trois messages)", 1200, "Aucune"),
    ("Trois téléphones de test et cartes mémoire", 950, "Aucune"),
    ("Entretiens clients (dédommagements, déplacements)", 200, "Aucune"),
    ("Consultation avocat : statut distributeur, mentions santé, CGV", 1500, "Liste d'attente au-dessus du seuil"),
    ("Recherche d'antériorité et dépôt de marque INPI (2 classes)", 600, "Nom retenu par le fondateur"),
    ("#", "Etape 2 : première vente réelle (jours 31 à 90)"),
    ("Création de la société (SASU), compte bancaire, assurance RC", 900, "Décision GO au jour 30"),
    ("Application v1 : appui d'un développeur Android indépendant", 3000, "Décision GO au jour 30"),
    ("Relecture des fiches par un formateur secouriste et un médecin", 1200, "Décision GO au jour 30"),
    ("Premier stock : 100 cartes 256 Go, 30 lecteurs, emballages", 3400, "40 précommandes payées"),
    ("Premier lot de 20 téléphones via grossiste UE", 4000, "15 précommandes de téléphones payées"),
    ("Publicité et créateurs, mois 2 et 3", 2400, "Coût par commande sous le seuil"),
    ("#", "Etape 3 : montée en charge (mois 4 à 12). Enveloppe : jusqu'à 40 000 € au total"),
    ("Besoin en fonds de roulement (stock de 1,5 mois)", 8000, "Plus de 60 commandes par mois pendant 2 mois"),
    ("Contenus, créateurs, salons (Survival Expo)", 4000, "Idem"),
    ("Application v2 (IA locale avec citations), traduction", 5000, "Taux de remboursement sous 8 %"),
    ("Réserve de sécurité non affectée", 3500, "Ne pas descendre sous 3 mois de charges fixes"),
]
rr = 5
premier_montant = None
for item in EMPLOIS:
    if item[0] == "#":
        c = ef.cell(row=rr, column=1, value=item[1])
        c.font = F_SECTION
        for j in range(1, 5):
            ef.cell(row=rr, column=j).fill = REMPL_SECTION
        rr += 1
        continue
    lib, montant, cond = item
    ef.cell(row=rr, column=1, value=lib).font = F_NORMAL
    c = ef.cell(row=rr, column=2, value=montant)
    c.font = F_INPUT
    c.number_format = FMT_EUR
    if premier_montant is None:
        premier_montant = rr
    c = ef.cell(row=rr, column=3, value=f"=SUM($B${premier_montant}:B{rr})")
    c.number_format = FMT_EUR
    c.font = F_NORMAL
    ef.cell(row=rr, column=4, value=cond).font = F_NOTE
    rr += 1
ef.cell(row=rr + 1, column=1, value="Total engagé si toutes les étapes sont franchies").font = F_GRAS
c = ef.cell(row=rr + 1, column=2, value=f"=SUM(B{premier_montant}:B{rr - 1})")
c.font = F_GRAS
c.number_format = FMT_EUR
c.fill = REMPL_TOTAL
ef.cell(row=rr + 2, column=1, value="Plafond de fonds propres indiqué par le fondateur").font = F_NORMAL
c = ef.cell(row=rr + 2, column=2, value=40000)
c.font = F_INPUT
c.number_format = FMT_EUR
ef.cell(row=rr + 3, column=1, value="Marge restante sous le plafond").font = F_GRAS
c = ef.cell(row=rr + 3, column=2, value=f"=B{rr + 2}-B{rr + 1}")
c.font = F_GRAS
c.number_format = FMT_EUR
ef.cell(row=rr + 5, column=1, value="Les précommandes encaissées financent une partie du stock : le besoin réel de trésorerie est inférieur à ce total si les seuils sont atteints.").font = F_NOTE
ef.column_dimensions["A"].width = 72
ef.column_dimensions["B"].width = 14
ef.column_dimensions["C"].width = 14
ef.column_dimensions["D"].width = 55

# Ordre des feuilles
ordre = ["Lisez_moi", "Hypotheses", "Unitaire", "Synthese", "M_Prudent", "M_Central", "M_Ambitieux", "Sensibilites", "Emploi_des_fonds"]
wb._sheets = [wb[n] for n in ordre]
wb.active = 0
wb.save(SORTIE)
print(f"Classeur écrit : {SORTIE}")
