# JOURNAL DU PROJET HUMAN

Journal tenu par le cofondateur opérationnel (IA). Il trace les décisions, les changements de cap, les hypothèses structurantes et les questions ouvertes. Les sources détaillées sont dans `sources.md`, les hypothèses dans `registre_hypotheses.md`.

Convention de statut des affirmations dans tous les documents :

| Marqueur | Signification |
|---|---|
| [FAIT] | Fait vérifié, source citée dans `sources.md` |
| [EST] | Estimation calculée à partir de faits, méthode explicitée |
| [HYP] | Hypothèse de travail, inscrite au registre |
| [INT] | Intuition d'opérateur, non étayée, à tester |

## 2026-11-12 : Lancement de la phase 1

**Mandat.** Benjamin de Villelongue (fondateur, CEO) demande une exploration complète de la thèse "smartphone durci minimaliste à forte autonomie avec IA locale hors ligne et base de connaissances de survie", pour une décision go / no-go / pivot sous 1 à 2 semaines. Budget initial 10 000 €, fonds propres jusqu'à 40 000 €.

**Décisions d'organisation.**

1. Le dépôt git `HUMAN` est le dossier de projet. Les livrables sont à la racine, les prototypes dans `prototype/`, les scripts dans `outils/`.
2. Ordre d'exécution : les 7 étapes du brief, dans l'ordre. La recherche web précède toute rédaction. Les documents sont rédigés une fois le socle factuel réuni, pour éviter les contradictions entre documents.
3. Aucune question bloquante n'est posée pendant le travail. Les manques sont comblés par des hypothèses explicites, consignées au registre.
4. Aucune dépense n'est engagée pendant cette phase (pas d'achat de nom de domaine, pas de recherche de marque payante, pas de publicité). Les vérifications de disponibilité sont faites avec des outils gratuits et signalées comme préliminaires.

**Arborescence cible.**

```
HUMAN/
  00_SYNTHESE_DECISION.md
  01_marche.md
  02_concurrence.md
  03_produit_technique.md
  04_legal.md
  05_finances.md
  06_acquisition_marque.md
  07_risques_decision.md
  modele_financier.xlsx
  registre_hypotheses.md
  sources.md
  plan_30_jours.md
  questions_ouvertes.md
  JOURNAL.md
  prototype/
    landing/            (landing page de test prête à publier)
    mvp_logiciel/       (spécification et prototype de la pile logicielle hors ligne)
  outils/               (scripts : génération du modèle financier, relevé de prix)
```
