// Produit l'icône de l'application (1024 × 1024) à partir de app/design/icone.svg. Usage : node outils/icone_app.js
const {chromium}=require('playwright');const path=require('path');
(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:1024,height:1024}});
await p.goto('file://'+path.resolve(__dirname,'../app/design/icone.svg'));
await p.screenshot({path:path.resolve(__dirname,'../app/design/icone-1024.png'),omitBackground:false});await b.close();console.log('icône écrite');})();
