# Schémas des guides

24 schémas réalisés avec Claude Design le 26 novembre 2026 (prompt : `prompts/claude_design_schemas_guides.md`). Maquettes d'écran associées : `../claude_design_schemas_et_ecrans_v1.pdf`.

| Fichier | Rôle |
|---|---|
| `schema-<guide>-<n>.svg` | Schéma source, 800 × 600, sans script ni lien externe (vérifié) |
| `png/` | Versions PNG pour le fichier Word (`node outils/schemas_en_png.js`) |
| `textes-alternatifs.csv` | Titre et texte alternatif de chaque schéma, lus par `outils/construire_guides_v11.py` |

Les schémas 1 à 6 (arrêt cardiaque, défibrillateur, position latérale de sécurité, étouffement, saignement, brûlure) doivent être relus par un formateur agréé aux premiers secours avant toute diffusion.

Mettre à jour après une modification :

```
node outils/schemas_en_png.js
python3 outils/construire_guides_v11.py
python3 outils/integrer_guides_maquette.py
node outils/guides_en_word.js
```
