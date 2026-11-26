// Produit contenus/guides/SIJAMAIS_guides_v1.1.docx à partir de guides_v1.1.json,
// pour le transmettre à Claude Design avec prompts/claude_design_schemas_guides.md.
// Usage : node outils/guides_en_word.js
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, Table, TableRow, TableCell,
  WidthType, ShadingType, BorderStyle, AlignmentType, LevelFormat, PageBreak,
  Footer, PageNumber,
} = require("docx");

const RACINE = path.resolve(__dirname, "..");
const d = JSON.parse(fs.readFileSync(path.join(RACINE, "contenus/guides/guides_v1.1.json"), "utf8"));
const SORTIE = path.join(RACINE, "contenus/guides/SIJAMAIS_guides_v1.1.docx");
const S = d.meta.sources;

// Schémas demandés dans le prompt Claude Design, par guide.
const SCHEMAS = {
  "arret-cardiaque": [[1, "Position des mains et des bras, rythme 100 à 120 par minute"], [2, "Électrodes du défibrillateur et pictogramme du défibrillateur"]],
  "inconscient-respire": [[3, "Position latérale de sécurité en 3 vignettes"]],
  "etouffement": [[4, "Claques dans le dos, puis compressions au creux de l'estomac"]],
  "saignement": [[5, "Main protégée qui appuie sur la plaie, victime allongée"]],
  "brulure": [[6, "Brûlure sous l'eau tempérée, minuteur 20 minutes"]],
  "alerte": [[7, "Frise du signal d'alerte, fin d'alerte, corne de brume"]],
  "reflexes": [[8, "Les 7 réflexes en 7 pictogrammes"]],
  "abri-evacuation": [[9, "Plan d'une pièce de mise à l'abri calfeutrée"]],
  "pfms": [[10, "Couper l'électricité, l'eau et le gaz"]],
  "kit72h": [[11, "Le kit vu de dessus, objets nommés"], [12, "6 litres par personne"]],
  "risques": [[13, "Inondation : voiture emportée, sous-sol interdit"], [14, "Séisme : s'abriter loin des fenêtres"]],
  "incendie-domicile": [[15, "Plan du logement et emplacement du détecteur de fumée"]],
  "monoxyde": [[16, "Appareils interdits à l'intérieur, aérer"]],
  "eau": [[17, "Filtrer, faire bouillir, désinfecter"]],
  "feu": [[18, "Triangle du feu et petit feu en tipi"]],
  "orientation": [[19, "Trouver le sud avec une montre, en France"]],
  "signaux": [[20, "Trois feux en triangle, bras levés en Y"]],
  "abri": [[21, "Abri de fortune avec une bâche"]],
  "cyberattaque": [[22, "Appareil bloqué : couper le Wi-Fi, débrancher, ne pas éteindre"]],
  "canicule": [[23, "Volets fermés le jour, ouverts la nuit"]],
  "coupure-electricite": [[24, "Réfrigérateur fermé, lampe allumée pour voir le retour du courant"]],
};

const POLICE = "Arial";
const VERT = "1F3B2D", ORANGE = "C9541C", ROUGE = "C8102E", GRIS = "5B6B60";
const LARGEUR = 9638; // A4, marges de 2 cm : 11906 - 2 * 1134

const p = (texte, o = {}) => new Paragraph({ spacing: { after: 100 }, ...o.para, children: [new TextRun({ text: texte, font: POLICE, size: 22, ...o.run })] });
const runs = (parts, para = {}) => new Paragraph({ spacing: { after: 100 }, ...para, children: parts.map(([t, r]) => new TextRun({ text: t, font: POLICE, size: 22, ...r })) });
const sousTitre = (t) => new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun({ text: t })] });
const puce = (t) => new Paragraph({ numbering: { reference: "puces", level: 0 }, spacing: { after: 60 }, children: [new TextRun({ text: t, font: POLICE, size: 22 })] });
const bord = { style: BorderStyle.SINGLE, size: 4, color: "D5DBD2" };

let numeroListe = 0;
const config = [{ reference: "puces", levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 270 } } } }] }];
function etapes(items) {
  const ref = "etapes" + (++numeroListe);
  config.push({ reference: ref, levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 360 } } } }] });
  return items.map((t) => new Paragraph({ numbering: { reference: ref, level: 0 }, spacing: { after: 60 }, children: [new TextRun({ text: t, font: POLICE, size: 22 })] }));
}

function encadre(titre, texte, couleur, fond) {
  return new Table({
    width: { size: LARGEUR, type: WidthType.DXA }, columnWidths: [LARGEUR],
    rows: [new TableRow({ children: [new TableCell({
      width: { size: LARGEUR, type: WidthType.DXA },
      shading: { type: ShadingType.CLEAR, fill: fond, color: "auto" },
      borders: { top: { style: BorderStyle.SINGLE, size: 12, color: couleur }, bottom: { style: BorderStyle.SINGLE, size: 12, color: couleur }, left: { style: BorderStyle.SINGLE, size: 12, color: couleur }, right: { style: BorderStyle.SINGLE, size: 12, color: couleur } },
      margins: { top: 100, bottom: 100, left: 160, right: 160 },
      children: [runs([[titre + " ", { bold: true, color: couleur }], [texte, {}]], { spacing: { after: 0 } })],
    })] })],
  });
}

function tableau(lignes, largeurs, entete) {
  const rows = [];
  const cell = (t, w, gras, fond) => new TableCell({
    width: { size: w, type: WidthType.DXA }, borders: { top: bord, bottom: bord, left: bord, right: bord },
    shading: fond ? { type: ShadingType.CLEAR, fill: fond, color: "auto" } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [p(t, { run: { bold: gras, size: 20 }, para: { spacing: { after: 0 } } })],
  });
  if (entete) rows.push(new TableRow({ tableHeader: true, children: entete.map((t, i) => cell(t, largeurs[i], true, "E7EAE2")) }));
  for (const l of lignes) rows.push(new TableRow({ children: l.map((t, i) => cell(t, largeurs[i], i === 0, null)) }));
  return new Table({ width: { size: LARGEUR, type: WidthType.DXA }, columnWidths: largeurs, rows });
}

const espace = () => new Paragraph({ spacing: { after: 80 }, children: [] });

function bloc(b) {
  const out = [];
  if (b.titre && !["risk", "plant"].includes(b.t)) out.push(sousTitre(b.titre));
  switch (b.t) {
    case "text": out.push(p(b.body)); break;
    case "alert": out.push(encadre("Attention :", b.body, ROUGE, "FBE9EB"), espace()); break;
    case "tip": out.push(encadre("Bon à savoir :", b.body, "00843D", "E8F3EC"), espace()); break;
    case "steps": out.push(...etapes(b.items)); break;
    case "list": b.items.forEach((t) => out.push(puce(t))); break;
    case "risk": out.push(sousTitre(b.titre)); b.items.forEach((t) => out.push(puce(t))); break;
    case "check": b.items.forEach((t) => out.push(p("☐  " + t, { para: { indent: { left: 270 }, spacing: { after: 60 } } }))); break;
    case "kv": out.push(tableau(b.items, [2600, LARGEUR - 2600]), espace()); break;
    case "plant": out.push(sousTitre(b.titre), tableau(b.items, [2000, LARGEUR - 2000]), espace()); break;
    case "numbers": out.push(tableau(b.items.map((x) => [x.n, x.label + " : " + x.desc]), [1800, LARGEUR - 1800]), espace()); break;
    case "dodont": (b.dont || []).forEach((t) => out.push(puce("À éviter : " + t))); break;
    case "form": out.push(p("Formulaire à remplir dans l'application :", { run: { italics: true, color: GRIS } })); b.fields.forEach((f) => out.push(p(f + " : ______________________", { para: { indent: { left: 270 }, spacing: { after: 60 } } }))); break;
    case "calc": out.push(p(b.body), p(`Calcul dans l'application : ${b.parPersonne} ${b.unite} × nombre de personnes du foyer.`, { run: { italics: true, color: GRIS } })); break;
    default: throw new Error("bloc inconnu " + b.t);
  }
  return out;
}

const enfants = [];
// Couverture
enfants.push(
  new Paragraph({ spacing: { before: 2400, after: 200 }, children: [new TextRun({ text: "SI", font: POLICE, size: 72, bold: true, color: "E0662A" }), new TextRun({ text: "JAMAIS", font: POLICE, size: 72, bold: true, color: VERT })] }),
  p("Prêt, même hors réseau.", { run: { size: 28, color: GRIS } }),
  new Paragraph({ spacing: { before: 600, after: 120 }, children: [new TextRun({ text: `Les ${d.guides.length} guides de l'application`, font: POLICE, size: 40, bold: true })] }),
  p(`Version ${d.meta.version} du ${d.meta.date}. Document de travail, à transmettre à Claude Design avec le prompt « claude_design_schemas_guides.md ».`),
  encadre("Ne pas diffuser :", d.meta.avertissement, ROUGE, "FBE9EB"),
  espace(),
  sousTitre("Comment lire ce document"),
  puce("Chaque guide porte son identifiant (par exemple « arret-cardiaque ») : c'est le nom à utiliser pour les fichiers de schémas, « schema-arret-cardiaque-1.svg »."),
  puce("Les encadrés orange « Schéma prévu » indiquent où placer chacun des 24 schémas demandés dans le prompt, avec leur numéro."),
  puce("« Consigne officielle » : texte repris de documents de l'État. « Conseil pratique » : texte rédigé par SIJAMAIS à partir de sources diverses."),
  puce("Les encadrés « À vérifier » listent ce qui doit être confirmé avant diffusion. Les guides de premiers secours seront relus par un formateur agréé."),
  puce("Tous ces guides sont gratuits dans l'application."),
  new Paragraph({ children: [new PageBreak()] }),
  new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "Sommaire" })] }),
);
for (const c of d.categories) {
  const liste = d.guides.filter((g) => g.cat === c.id);
  enfants.push(p(`${c.titre} (${liste.length} guides)`, { run: { bold: true, color: VERT }, para: { spacing: { before: 160, after: 40 } } }));
  enfants.push(p(liste.map((g) => g.titre).join(" · "), { run: { size: 20, color: GRIS } }));
}

for (const c of d.categories) {
  const liste = d.guides.filter((g) => g.cat === c.id);
  enfants.push(new Paragraph({ children: [new PageBreak()] }));
  enfants.push(new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: `${c.titre} (${liste.length} guides)` })] }));
  enfants.push(p(c.desc, { run: { color: GRIS } }));
  for (const g of liste) {
    enfants.push(new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun({ text: g.titre })] }));
    enfants.push(runs([
      ["Identifiant : ", { color: GRIS, size: 18 }], [g.id, { bold: true, size: 18 }],
      ["   ·   ", { color: GRIS, size: 18 }], [g.niveau === "officiel" ? "Consigne officielle" : "Conseil pratique", { bold: true, size: 18, color: g.niveau === "officiel" ? "00843D" : GRIS }],
      ["   ·   ", { color: GRIS, size: 18 }], [`${g.duree} de lecture`, { color: GRIS, size: 18 }],
    ]));
    enfants.push(p(g.resume, { run: { italics: true } }));
    if (g.sensible) enfants.push(encadre("Urgence vitale :", "appelez le 15 ou le 112 (114 par SMS). Ce bandeau s'affiche en tête du guide.", ROUGE, "FBE9EB"), espace());
    for (const [n, desc] of SCHEMAS[g.id] || []) enfants.push(encadre(`Schéma prévu n° ${n} :`, `${desc}. Fichier : schema-${g.id}-${(SCHEMAS[g.id].findIndex((x) => x[0] === n)) + 1}.svg`, ORANGE, "FBEFE7"), espace());
    for (const b of g.blocs) enfants.push(...bloc(b));
    enfants.push(sousTitre("Sources"));
    for (const s of g.sources) enfants.push(puce(`${S[s].titre}, ${S[s].editeur}${S[s].date ? ", " + S[s].date : ""}`));
    if (g.a_verifier && g.a_verifier.length) enfants.push(espace(), encadre("À vérifier :", g.a_verifier.join(" ; "), "9A6A00", "FFF7DB"));
    enfants.push(espace());
  }
}

const doc = new Document({
  creator: "SIJAMAIS", title: "Guides SIJAMAIS v1.1", description: "Les guides de l'application SIJAMAIS",
  styles: {
    default: { document: { run: { font: POLICE, size: 22 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true, run: { font: POLICE, size: 36, bold: true, color: VERT }, paragraph: { spacing: { before: 240, after: 160 }, keepNext: true, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true, run: { font: POLICE, size: 30, bold: true, color: VERT }, paragraph: { spacing: { before: 360, after: 80 }, keepNext: true, outlineLevel: 1, border: { top: { style: BorderStyle.SINGLE, size: 6, color: "D5DBD2", space: 8 } } } },
      { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true, run: { font: POLICE, size: 23, bold: true, color: ORANGE }, paragraph: { spacing: { before: 160, after: 60 }, keepNext: true, outlineLevel: 2 } },
    ],
  },
  numbering: { config },
  sections: [{
    properties: { page: { size: { width: 11906, height: 16838 }, margin: { top: 1134, bottom: 1134, left: 1134, right: 1134 } } },
    footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: "SIJAMAIS · guides v1.1 · document de travail, ne pas diffuser · page ", font: POLICE, size: 16, color: GRIS }), new TextRun({ children: [PageNumber.CURRENT], font: POLICE, size: 16, color: GRIS })] })] }) },
    children: enfants,
  }],
});

Packer.toBuffer(doc).then((buf) => { fs.writeFileSync(SORTIE, buf); console.log("écrit :", path.relative(RACINE, SORTIE), d.guides.length, "guides"); });
