// Convertit les schémas SVG en PNG (2x) pour le fichier Word. Usage : node outils/schemas_en_png.js
const {chromium}=require('playwright');const fs=require('fs');const path=require('path');
const D=path.resolve(__dirname,'../contenus/guides/schemas');
(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:800,height:600},deviceScaleFactor:2});
for(const f of fs.readdirSync(D).filter(f=>f.endsWith('.svg'))){await p.goto('file://'+D+'/'+f);await p.screenshot({path:D+'/png/'+f.replace('.svg','.png'),omitBackground:false});}
await b.close();console.log('PNG écrits');})();
