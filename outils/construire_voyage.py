#!/usr/bin/env python3
"""Contenu du mode Voyage (28/11/2026) : numéros d'urgence par pays, phrases à montrer, liste de départ.

Écrit contenus/voyage/voyage_v1.json et sa copie dans les ressources du cœur (SijamaisCore).
Statut des données :
- 112 dans les 27 pays de l'Union européenne : règle européenne (code des communications électroniques, art. 109).
- Numéros nationaux hors UE : [MEMOIRE], « verifie: false », à contrôler un par un sur la fiche
  Conseils aux voyageurs du pays (diplomatie.gouv.fr) avant publication. L'application l'affiche.
- Traductions : rédigées par l'assistant, « relu: false » tant qu'un locuteur natif ne les a pas relues.
"""
import json
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent

LANGUES = [
    ("en", "Anglais", "English"), ("es", "Espagnol", "Español"), ("it", "Italien", "Italiano"), ("de", "Allemand", "Deutsch"),
    ("pt", "Portugais", "Português"), ("nl", "Néerlandais", "Nederlands"), ("el", "Grec", "Ελληνικά"), ("hr", "Croate", "Hrvatski"),
    ("tr", "Turc", "Türkçe"), ("ar", "Arabe", "العربية"),
]

# (id, gratuit, français, {langue: traduction})
PHRASES = [
    ("aide", True, "Aidez-moi, s'il vous plaît !", {
        "en": "Help me, please!", "es": "¡Ayúdeme, por favor!", "it": "Mi aiuti, per favore!", "de": "Helfen Sie mir, bitte!",
        "pt": "Ajude-me, por favor!", "nl": "Help me, alstublieft!", "el": "Βοηθήστε με, παρακαλώ!", "hr": "Pomozite mi, molim vas!",
        "tr": "Lütfen bana yardım edin!", "ar": "ساعدوني من فضلكم!"}),
    ("ambulance", True, "Appelez une ambulance !", {
        "en": "Call an ambulance!", "es": "¡Llame a una ambulancia!", "it": "Chiami un'ambulanza!", "de": "Rufen Sie einen Krankenwagen!",
        "pt": "Chame uma ambulância!", "nl": "Bel een ambulance!", "el": "Καλέστε ασθενοφόρο!", "hr": "Zovite hitnu pomoć!",
        "tr": "Ambulans çağırın!", "ar": "اتصلوا بالإسعاف!"}),
    ("police", True, "Appelez la police !", {
        "en": "Call the police!", "es": "¡Llame a la policía!", "it": "Chiami la polizia!", "de": "Rufen Sie die Polizei!",
        "pt": "Chame a polícia!", "nl": "Bel de politie!", "el": "Καλέστε την αστυνομία!", "hr": "Zovite policiju!",
        "tr": "Polisi arayın!", "ar": "اتصلوا بالشرطة!"}),
    ("incendie", True, "Il y a un incendie !", {
        "en": "There is a fire!", "es": "¡Hay un incendio!", "it": "C'è un incendio!", "de": "Es brennt!",
        "pt": "Há um incêndio!", "nl": "Er is brand!", "el": "Υπάρχει φωτιά!", "hr": "Izbio je požar!",
        "tr": "Yangın var!", "ar": "يوجد حريق!"}),
    ("inconscient", True, "Cette personne a perdu connaissance.", {
        "en": "This person has lost consciousness.", "es": "Esta persona ha perdido el conocimiento.", "it": "Questa persona ha perso conoscenza.",
        "de": "Diese Person ist bewusstlos.", "pt": "Esta pessoa perdeu a consciência.", "nl": "Deze persoon is bewusteloos.",
        "el": "Αυτό το άτομο έχασε τις αισθήσεις του.", "hr": "Ova osoba je izgubila svijest.", "tr": "Bu kişi bilincini kaybetti.",
        "ar": "هذا الشخص فقد الوعي."}),
    ("blesse", True, "Je suis blessé(e).", {
        "en": "I am injured.", "es": "Estoy herido/a.", "it": "Sono ferito/a.", "de": "Ich bin verletzt.", "pt": "Estou ferido/a.",
        "nl": "Ik ben gewond.", "el": "Είμαι τραυματισμένος/η.", "hr": "Ozlijeđen/a sam.", "tr": "Yaralandım.", "ar": "أنا مصاب/مصابة."}),
    ("medecin", True, "J'ai besoin d'un médecin.", {
        "en": "I need a doctor.", "es": "Necesito un médico.", "it": "Ho bisogno di un medico.", "de": "Ich brauche einen Arzt.",
        "pt": "Preciso de um médico.", "nl": "Ik heb een dokter nodig.", "el": "Χρειάζομαι γιατρό.", "hr": "Trebam liječnika.",
        "tr": "Bir doktora ihtiyacım var.", "ar": "أحتاج إلى طبيب."}),
    ("hopital", True, "Où est l'hôpital le plus proche ?", {
        "en": "Where is the nearest hospital?", "es": "¿Dónde está el hospital más cercano?", "it": "Dov'è l'ospedale più vicino?",
        "de": "Wo ist das nächste Krankenhaus?", "pt": "Onde fica o hospital mais próximo?", "nl": "Waar is het dichtstbijzijnde ziekenhuis?",
        "el": "Πού είναι το πλησιέστερο νοσοκομείο;", "hr": "Gdje je najbliža bolnica?", "tr": "En yakın hastane nerede?", "ar": "أين أقرب مستشفى؟"}),
    ("allergie", True, "J'ai une allergie grave.", {
        "en": "I have a severe allergy.", "es": "Tengo una alergia grave.", "it": "Ho una grave allergia.", "de": "Ich habe eine schwere Allergie.",
        "pt": "Tenho uma alergia grave.", "nl": "Ik heb een ernstige allergie.", "el": "Έχω σοβαρή αλλεργία.", "hr": "Imam tešku alergiju.",
        "tr": "Ciddi bir alerjim var.", "ar": "لدي حساسية شديدة."}),
    ("enfant", True, "Mon enfant a disparu.", {
        "en": "My child is missing.", "es": "Mi hijo/hija ha desaparecido.", "it": "Mio figlio/mia figlia è scomparso/a.",
        "de": "Mein Kind ist verschwunden.", "pt": "O meu filho/a minha filha desapareceu.", "nl": "Mijn kind is vermist.",
        "el": "Το παιδί μου χάθηκε.", "hr": "Moje dijete je nestalo.", "tr": "Çocuğum kayboldu.", "ar": "طفلي مفقود."}),
    ("langue", True, "Je ne parle pas votre langue. Je viens de France.", {
        "en": "I don't speak your language. I am from France.", "es": "No hablo su idioma. Soy de Francia.",
        "it": "Non parlo la sua lingua. Vengo dalla Francia.", "de": "Ich spreche Ihre Sprache nicht. Ich komme aus Frankreich.",
        "pt": "Não falo a sua língua. Venho da França.", "nl": "Ik spreek uw taal niet. Ik kom uit Frankrijk.",
        "el": "Δεν μιλάω τη γλώσσα σας. Είμαι από τη Γαλλία.", "hr": "Ne govorim vaš jezik. Dolazim iz Francuske.",
        "tr": "Dilinizi konuşmuyorum. Fransa'dan geliyorum.", "ar": "لا أتكلم لغتكم. أنا من فرنسا."}),
    ("pharmacie", False, "Où est la pharmacie la plus proche ?", {
        "en": "Where is the nearest pharmacy?", "es": "¿Dónde está la farmacia más cercana?", "it": "Dov'è la farmacia più vicina?",
        "de": "Wo ist die nächste Apotheke?", "pt": "Onde fica a farmácia mais próxima?", "nl": "Waar is de dichtstbijzijnde apotheek?",
        "el": "Πού είναι το πλησιέστερο φαρμακείο;", "hr": "Gdje je najbliža ljekarna?", "tr": "En yakın eczane nerede?", "ar": "أين أقرب صيدلية؟"}),
    ("diabete", False, "J'ai du diabète.", {
        "en": "I have diabetes.", "es": "Tengo diabetes.", "it": "Ho il diabete.", "de": "Ich habe Diabetes.", "pt": "Tenho diabetes.",
        "nl": "Ik heb diabetes.", "el": "Έχω διαβήτη.", "hr": "Imam dijabetes.", "tr": "Diyabetim var.", "ar": "عندي مرض السكري."}),
    ("enceinte", False, "Je suis enceinte.", {
        "en": "I am pregnant.", "es": "Estoy embarazada.", "it": "Sono incinta.", "de": "Ich bin schwanger.", "pt": "Estou grávida.",
        "nl": "Ik ben zwanger.", "el": "Είμαι έγκυος.", "hr": "Trudna sam.", "tr": "Hamileyim.", "ar": "أنا حامل."}),
    ("medicament", False, "Je prends ce médicament tous les jours.", {
        "en": "I take this medicine every day.", "es": "Tomo este medicamento todos los días.", "it": "Prendo questo farmaco tutti i giorni.",
        "de": "Ich nehme dieses Medikament jeden Tag.", "pt": "Tomo este medicamento todos os dias.", "nl": "Ik neem dit medicijn elke dag.",
        "el": "Παίρνω αυτό το φάρμακο κάθε μέρα.", "hr": "Ovaj lijek uzimam svaki dan.", "tr": "Bu ilacı her gün kullanıyorum.",
        "ar": "آخذ هذا الدواء كل يوم."}),
    ("passeport", False, "J'ai perdu mon passeport.", {
        "en": "I have lost my passport.", "es": "He perdido mi pasaporte.", "it": "Ho perso il passaporto.",
        "de": "Ich habe meinen Reisepass verloren.", "pt": "Perdi o meu passaporte.", "nl": "Ik ben mijn paspoort kwijt.",
        "el": "Έχασα το διαβατήριό μου.", "hr": "Izgubio/la sam putovnicu.", "tr": "Pasaportumu kaybettim.", "ar": "فقدت جواز سفري."}),
    ("vol", False, "On m'a volé mes affaires.", {
        "en": "My belongings have been stolen.", "es": "Me han robado mis cosas.", "it": "Mi hanno rubato le mie cose.",
        "de": "Meine Sachen wurden gestohlen.", "pt": "Roubaram as minhas coisas.", "nl": "Mijn spullen zijn gestolen.",
        "el": "Μου έκλεψαν τα πράγματά μου.", "hr": "Ukrali su mi stvari.", "tr": "Eşyalarım çalındı.", "ar": "سُرقت أغراضي."}),
    ("ambassade", False, "Où est l'ambassade (ou le consulat) de France ?", {
        "en": "Where is the French embassy (or consulate)?", "es": "¿Dónde está la embajada (o el consulado) de Francia?",
        "it": "Dov'è l'ambasciata (o il consolato) di Francia?", "de": "Wo ist die französische Botschaft (oder das Konsulat)?",
        "pt": "Onde fica a embaixada (ou o consulado) da França?", "nl": "Waar is de Franse ambassade (of het consulaat)?",
        "el": "Πού είναι η πρεσβεία (ή το προξενείο) της Γαλλίας;", "hr": "Gdje je francusko veleposlanstvo (ili konzulat)?",
        "tr": "Fransa büyükelçiliği (veya konsolosluğu) nerede?", "ar": "أين سفارة فرنسا (أو القنصلية)؟"}),
    ("perdu", False, "Je suis perdu(e). Pouvez-vous m'aider ?", {
        "en": "I am lost. Can you help me?", "es": "Estoy perdido/a. ¿Puede ayudarme?", "it": "Mi sono perso/a. Può aiutarmi?",
        "de": "Ich habe mich verlaufen. Können Sie mir helfen?", "pt": "Estou perdido/a. Pode ajudar-me?", "nl": "Ik ben verdwaald. Kunt u mij helpen?",
        "el": "Έχω χαθεί. Μπορείτε να με βοηθήσετε;", "hr": "Izgubio/la sam se. Možete li mi pomoći?", "tr": "Kayboldum. Bana yardım edebilir misiniz?",
        "ar": "أنا تائه. هل يمكنك مساعدتي؟"}),
    ("adresse", False, "Pouvez-vous écrire l'adresse, s'il vous plaît ?", {
        "en": "Could you write down the address, please?", "es": "¿Puede escribir la dirección, por favor?", "it": "Può scrivere l'indirizzo, per favore?",
        "de": "Können Sie bitte die Adresse aufschreiben?", "pt": "Pode escrever o endereço, por favor?", "nl": "Kunt u het adres opschrijven, alstublieft?",
        "el": "Μπορείτε να γράψετε τη διεύθυνση, παρακαλώ;", "hr": "Možete li napisati adresu, molim vas?", "tr": "Adresi yazabilir misiniz, lütfen?",
        "ar": "هل يمكنك كتابة العنوان من فضلك؟"}),
]

UE = {"DE": "Allemagne", "AT": "Autriche", "BE": "Belgique", "BG": "Bulgarie", "CY": "Chypre", "HR": "Croatie", "DK": "Danemark",
      "ES": "Espagne", "EE": "Estonie", "FI": "Finlande", "GR": "Grèce", "HU": "Hongrie", "IE": "Irlande", "IT": "Italie", "LV": "Lettonie",
      "LT": "Lituanie", "LU": "Luxembourg", "MT": "Malte", "NL": "Pays-Bas", "PL": "Pologne", "PT": "Portugal", "CZ": "Tchéquie",
      "RO": "Roumanie", "SK": "Slovaquie", "SI": "Slovénie", "SE": "Suède"}
LANGUE_PAYS = {"DE": "de", "AT": "de", "BE": "nl", "CY": "el", "HR": "hr", "ES": "es", "GR": "el", "IE": "en", "IT": "it", "MT": "en",
               "NL": "nl", "PT": "pt"}
# Compléments utiles dans l'UE [MEMOIRE]
COMPLEMENTS_UE = {"GR": [("Police touristique", "1571")], "ES": [("Police nationale", "091")]}

# Hors UE : (code, nom, zone, langue, [(service, numéro)]) [MEMOIRE], à vérifier.
HORS_UE = [
    ("GB", "Royaume-Uni", "Europe", "en", [("Toutes urgences", "999"), ("Toutes urgences (aussi)", "112")]),
    ("CH", "Suisse", "Europe", "de", [("Urgences", "112"), ("Police", "117"), ("Ambulance", "144"), ("Pompiers", "118"), ("Hélicoptère de sauvetage (Rega)", "1414")]),
    ("NO", "Norvège", "Europe", "en", [("Police", "112"), ("Ambulance", "113"), ("Pompiers", "110")]),
    ("IS", "Islande", "Europe", "en", [("Toutes urgences", "112")]),
    ("AD", "Andorre", "Europe", "es", [("Urgences", "112"), ("Police", "110"), ("Ambulance et pompiers", "118")]),
    ("MC", "Monaco", "Europe", None, [("Urgences", "112"), ("Police", "17"), ("Pompiers et secours", "18")]),
    ("TR", "Turquie", "Europe", "tr", [("Toutes urgences", "112")]),
    ("MA", "Maroc", "Afrique", "ar", [("Police (en ville)", "19"), ("Gendarmerie (hors ville)", "177"), ("Pompiers et ambulance", "15")]),
    ("TN", "Tunisie", "Afrique", "ar", [("Police", "197"), ("SAMU", "190"), ("Protection civile", "198")]),
    ("DZ", "Algérie", "Afrique", "ar", [("Police", "17"), ("Protection civile", "14"), ("Gendarmerie", "1055")]),
    ("EG", "Égypte", "Afrique", "ar", [("Police", "122"), ("Ambulance", "123"), ("Pompiers", "180"), ("Police touristique", "126")]),
    ("SN", "Sénégal", "Afrique", None, [("Police", "17"), ("Pompiers", "18"), ("SAMU", "1515")]),
    ("CI", "Côte d'Ivoire", "Afrique", None, [("Police", "111"), ("Pompiers", "180"), ("SAMU", "185")]),
    ("MU", "Maurice", "Afrique", "en", [("Police", "999"), ("SAMU", "114"), ("Pompiers", "115")]),
    ("MG", "Madagascar", "Afrique", None, [("Police", "117"), ("Pompiers", "118")]),
    ("CV", "Cap-Vert", "Afrique", "pt", [("Police", "132"), ("Ambulance", "130"), ("Pompiers", "131")]),
    ("ZA", "Afrique du Sud", "Afrique", "en", [("Police", "10111"), ("Ambulance", "10177"), ("Depuis un mobile", "112")]),
    ("US", "États-Unis", "Amériques", "en", [("Toutes urgences", "911")]),
    ("CA", "Canada", "Amériques", "en", [("Toutes urgences", "911")]),
    ("MX", "Mexique", "Amériques", "es", [("Toutes urgences", "911")]),
    ("CU", "Cuba", "Amériques", "es", [("Police", "106"), ("Ambulance", "104"), ("Pompiers", "105")]),
    ("DO", "République dominicaine", "Amériques", "es", [("Toutes urgences", "911")]),
    ("BR", "Brésil", "Amériques", "pt", [("Police", "190"), ("SAMU", "192"), ("Pompiers", "193")]),
    ("AR", "Argentine", "Amériques", "es", [("Police", "911"), ("Ambulance", "107"), ("Pompiers", "100")]),
    ("CL", "Chili", "Amériques", "es", [("Police", "133"), ("Ambulance", "131"), ("Pompiers", "132")]),
    ("PE", "Pérou", "Amériques", "es", [("Police", "105"), ("Ambulance (SAMU)", "106"), ("Pompiers", "116")]),
    ("IL", "Israël", "Asie", "en", [("Police", "100"), ("Ambulance", "101"), ("Pompiers", "102")]),
    ("AE", "Émirats arabes unis", "Asie", "ar", [("Police", "999"), ("Ambulance", "998"), ("Pompiers", "997")]),
    ("IN", "Inde", "Asie", "en", [("Toutes urgences", "112"), ("Ambulance", "108")]),
    ("LK", "Sri Lanka", "Asie", "en", [("Police", "119"), ("Ambulance", "1990")]),
    ("TH", "Thaïlande", "Asie", "en", [("Police", "191"), ("Ambulance", "1669"), ("Pompiers", "199"), ("Police touristique", "1155")]),
    ("VN", "Viêt Nam", "Asie", "en", [("Police", "113"), ("Pompiers", "114"), ("Ambulance", "115")]),
    ("KH", "Cambodge", "Asie", "en", [("Police", "117"), ("Pompiers", "118"), ("Ambulance", "119")]),
    ("ID", "Indonésie", "Asie", "en", [("Toutes urgences", "112"), ("Police", "110"), ("Ambulance", "118")]),
    ("PH", "Philippines", "Asie", "en", [("Toutes urgences", "911")]),
    ("CN", "Chine", "Asie", None, [("Police", "110"), ("Ambulance", "120"), ("Pompiers", "119")]),
    ("JP", "Japon", "Asie", "en", [("Police", "110"), ("Ambulance et pompiers", "119")]),
    ("KR", "Corée du Sud", "Asie", "en", [("Police", "112"), ("Ambulance et pompiers", "119")]),
    ("AU", "Australie", "Océanie", "en", [("Toutes urgences", "000"), ("Depuis un mobile (aussi)", "112")]),
    ("NZ", "Nouvelle-Zélande", "Océanie", "en", [("Toutes urgences", "111")]),
]

DEPART = [
    ("ariane", True, "S'inscrire sur Ariane", "Le service du ministère des Affaires étrangères : vous recevez les alertes du pays, et l'ambassade peut vous joindre en cas de crise."),
    ("conseils", True, "Lire la fiche « Conseils aux voyageurs » du pays", "Sur diplomatie.gouv.fr : sécurité, santé, formalités, zones déconseillées."),
    ("papiers", False, "Passeport ou carte d'identité valides", "Vérifier la durée de validité exigée par le pays, et le visa."),
    ("ceam", False, "Carte européenne d'assurance maladie (pour l'Europe)", "À demander sur ameli.fr, plusieurs semaines avant le départ [A VERIFIER : délai exact]."),
    ("assistance", False, "Assurance assistance et rapatriement", "Vérifier ce que couvre votre carte bancaire ; noter le numéro d'assistance et le numéro de contrat."),
    ("sante", False, "Vaccins et traitements", "En parler à un médecin bien avant le départ ; centre de vaccinations internationales si besoin."),
    ("medicaments", False, "Médicaments dans leur boîte, avec l'ordonnance, en bagage cabine", ""),
    ("banque", False, "Numéro d'opposition de la carte bancaire", "Le noter dans le dossier de voyage."),
    ("copies", False, "Copies des papiers", "Dans le dossier de voyage, protégé par Face ID."),
    ("proche", True, "Laisser son itinéraire à un proche", "Hébergements, vols, dates de retour."),
    ("permis", False, "Permis de conduire international, si vous louez une voiture hors d'Europe", ""),
    ("energie", False, "Adaptateur de prise et batterie externe", ""),
]


def main() -> None:
    phrases = [{"id": i, "gratuit": g, "fr": fr, "traductions": t} for i, g, fr, t in PHRASES]
    for p in phrases:
        assert set(p["traductions"]) == {c for c, _, _ in LANGUES}, p["id"]
    pays = []
    for code, nom in sorted(UE.items(), key=lambda x: x[1]):
        pays.append({"code": code, "nom": nom, "zone": "Union européenne", "langue": LANGUE_PAYS.get(code),
                     "numeros": [{"service": "Toutes urgences", "numero": "112", "verifie": True}] +
                                [{"service": s, "numero": n, "verifie": False} for s, n in COMPLEMENTS_UE.get(code, [])],
                     "source": "112 : numéro d'urgence européen, valable dans toute l'Union"})
    for code, nom, zone, langue, nums in HORS_UE:
        pays.append({"code": code, "nom": nom, "zone": zone, "langue": langue,
                     "numeros": [{"service": s, "numero": n, "verifie": False} for s, n in nums], "source": "À vérifier sur diplomatie.gouv.fr"})
    contenu = {
        "version": "1.0", "date": "2026-11-28",
        "avertissement": "Numéros marqués « à confirmer » : vérifiez sur la fiche Conseils aux voyageurs du pays avant de partir.",
        "langues": [{"code": c, "nom": n, "autonyme": a, "relu": False} for c, n, a in LANGUES],
        "phrases": phrases,
        "pays": sorted(pays, key=lambda p: p["nom"]),
        "depart": [{"id": i, "gratuit": g, "titre": t, "detail": d} for i, g, t, d in DEPART],
    }
    texte = json.dumps(contenu, ensure_ascii=False, indent=1) + "\n"
    assert "—" not in texte and "–" not in texte
    for cible in (RACINE / "contenus" / "voyage" / "voyage_v1.json", RACINE / "app" / "SijamaisKit" / "Sources" / "SijamaisCore" / "Ressources" / "voyage.json"):
        cible.write_text(texte, encoding="utf-8")
    print(f"{len(phrases)} phrases x {len(LANGUES)} langues, {len(pays)} pays, {len(DEPART)} points de départ")


if __name__ == "__main__":
    main()
