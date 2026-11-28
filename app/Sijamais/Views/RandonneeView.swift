import ActivityKit
import CoreLocation
import SwiftUI
import UserNotifications
import SijamaisCore

/// Mode Randonnée et montagne. Gratuit : alerter les secours, les guides utiles. Premium : fiche de sortie et compte à rebours.
struct RandonneeView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        List {
            Section {
                NavigationLink { AlerteMontagneView() } label: {
                    Label("Alerter les secours en montagne", systemImage: "sos").font(.headline).foregroundStyle(Charte.secours)
                }
            } footer: {
                Text("Gratuit : votre position GPS et un message prêt à lire au 112.")
            }

            Section {
                NavigationLink { AvalancheView() } label: {
                    Label("Bulletin avalanche du jour", systemImage: "snowflake")
                }
            } footer: {
                Text("Gratuit : le bulletin de Météo-France pour 36 massifs, de novembre à mai, lisible sans réseau une fois téléchargé.")
            }

            Section {
                BandeauRetour()
                if modele.abonnement.actif {
                    NavigationLink { FicheSortieView() } label: { Label("Ma fiche de sortie", systemImage: "map") }
                    NavigationLink { TracesView() } label: { Label("Mes traces GPX (Komoot, Visorando, Garmin...)", systemImage: "point.topleft.down.to.point.bottomright.curvepath") }
                } else {
                    NavigationLink { PremiumView() } label: {
                        Label("Ma fiche de sortie et le compte à rebours du retour", systemImage: "lock.fill")
                    }
                }
            } header: {
                Text("Avant de partir")
            } footer: {
                Text("Prévenez toujours un proche de votre itinéraire et de votre heure de retour.")
            }

            Section("Les guides utiles") {
                ForEach(["orientation", "signaux", "priorites", "trousse-survie", "eau", "abri"], id: \.self) { id in
                    if let g = modele.guide(id) {
                        NavigationLink { GuideView(guide: g) } label: { Text(g.titre) }
                    }
                }
            }
        }
        .navigationTitle("Randonnée")
    }
}

/// Bandeau qui s'affiche quand une sortie est en cours, et en rouge si l'heure de retour est dépassée.
struct BandeauRetour: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        TimelineView(.periodic(from: .now, by: 30)) { contexte in
            switch modele.ficheSortie.etat(maintenant: contexte.date) {
            case .preparation:
                EmptyView()
            case let .enCours(reste):
                Label("Sortie en cours : retour prévu dans \(reste / 60) h \(reste % 60) min", systemImage: "figure.hiking")
                    .foregroundStyle(Charte.securite)
            case let .enRetard(minutes):
                VStack(alignment: .leading, spacing: 8) {
                    Label("Heure de retour dépassée de \(minutes) min", systemImage: "exclamationmark.triangle.fill").font(.headline)
                    Text("Si vous êtes bien rentré, terminez la sortie dans la fiche. Sinon :").font(.footnote)
                    HStack {
                        if !modele.ficheSortie.telephoneNumerique.isEmpty, let u = URL(string: "tel:\(modele.ficheSortie.telephoneNumerique)") {
                            Link("Appeler \(modele.ficheSortie.procheNom.isEmpty ? "mon proche" : modele.ficheSortie.procheNom)", destination: u)
                        }
                        Spacer()
                        if let u = URL(string: "tel:112") { Link("Appeler le 112", destination: u).bold() }
                    }
                }
                .foregroundStyle(Charte.secours)
            }
        }
    }
}

/// Position GPS, sans réseau : le GPS de l'iPhone fonctionne sans antenne téléphonique.
@Observable
@MainActor
final class Localisateur: NSObject, CLLocationManagerDelegate {
    private let gestionnaire = CLLocationManager()
    private(set) var position: Coordonnees?
    private(set) var precision: Double?
    private(set) var refus = false

    override init() {
        super.init()
        gestionnaire.delegate = self
        gestionnaire.desiredAccuracy = kCLLocationAccuracyBest
    }

    func localiser() {
        refus = false
        if gestionnaire.authorizationStatus == .notDetermined { gestionnaire.requestWhenInUseAuthorization() }
        gestionnaire.requestLocation()
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let l = locations.last else { return }
        let c = Coordonnees(latitude: l.coordinate.latitude, longitude: l.coordinate.longitude, altitude: l.verticalAccuracy >= 0 ? l.altitude : nil)
        let p = l.horizontalAccuracy
        Task { @MainActor in self.position = c; self.precision = p }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in self.refus = true }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let s = manager.authorizationStatus
        Task { @MainActor in
            if s == .authorizedWhenInUse || s == .authorizedAlways { self.gestionnaire.requestLocation() }
            if s == .denied || s == .restricted { self.refus = true }
        }
    }
}

/// « Alerter les secours en montagne » (gratuit) : position, message dans l'ordre demandé par les secours, appel du 112.
struct AlerteMontagneView: View {
    @State private var gps = Localisateur()
    @State private var nom = ""
    @State private var lieu = ""
    @State private var victimes = 1
    @State private var blessures = ""
    @State private var meteo = ""

    var body: some View {
        Form {
            Section {
                if let u = URL(string: "tel:112") {
                    Link(destination: u) {
                        Label("Appeler le 112", systemImage: "phone.fill").font(.title2.bold()).frame(maxWidth: .infinity)
                            .padding(.vertical, 10).foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Charte.secours))
                    }
                }
                ForEach(MessageAlerte.conseils, id: \.self) { Text($0).font(.footnote) }
            }

            Section("Ma position") {
                if let p = gps.position {
                    Text(p.decimal).font(.title3.monospacedDigit().bold()).textSelection(.enabled)
                    Text(p.dms).font(.subheadline.monospacedDigit())
                    if let a = p.altitude { Text("Altitude : \(Int(a.rounded())) m") }
                    if let pr = gps.precision { Text("Précision : environ \(Int(pr.rounded())) m").font(.caption).foregroundStyle(.secondary) }
                } else if gps.refus {
                    Text("Position indisponible. Autorisez la localisation dans les réglages de l'iPhone, ou décrivez le lieu ci-dessous.").font(.footnote)
                } else {
                    ProgressView("Recherche de la position…")
                }
                Button("Actualiser la position") { gps.localiser() }
            }

            Section("Ce que je vais dire") {
                TextField("Mon nom", text: $nom)
                TextField("Lieu (sentier, sommet, refuge...)", text: $lieu)
                Stepper("Personnes à secourir : \(victimes)", value: $victimes, in: 1...20)
                TextField("Ce qui se passe (blessure, malaise, perdu...)", text: $blessures, axis: .vertical)
                TextField("Météo sur place", text: $meteo)
            }

            Section("Message à lire au 112") {
                ForEach(MessageAlerte.lignes(nom: nom, coordonnees: gps.position, lieu: lieu, victimes: victimes, blessures: blessures, meteo: meteo), id: \.self) {
                    Text($0).font(.body.bold())
                }
            }
        }
        .navigationTitle("Alerter les secours")
        .onAppear { gps.localiser() }
    }
}

/// Fiche de sortie (premium) : message pour un proche, « Je pars », « Je suis rentré », rappels si l'heure est dépassée.
struct FicheSortieView: View {
    @Environment(AppModel.self) private var modele

    var body: some View {
        @Bindable var modele = modele
        Form {
            Section("Ma sortie") {
                TextField("Itinéraire (départ, sommet, retour)", text: $modele.ficheSortie.itineraire, axis: .vertical)
                DatePicker("Départ", selection: $modele.ficheSortie.depart)
                DatePicker("Retour prévu", selection: $modele.ficheSortie.retour, in: modele.ficheSortie.depart...)
                Stepper("Participants : \(modele.ficheSortie.participants)", value: $modele.ficheSortie.participants, in: 1...30)
                TextField("Véhicule garé (lieu, plaque)", text: $modele.ficheSortie.vehicule)
            }
            Section {
                Picker("Massif", selection: Binding(get: { modele.avalanche.massifSortie }, set: { modele.avalanche.massifSortie = $0 })) {
                    Text("Aucun (sortie sans neige)").tag(Int?.none)
                    ForEach(BulletinAvalanche.massifs) { m in Text(m.nom).tag(Int?.some(m.id)) }
                }
                if let id = modele.avalanche.massifSortie {
                    if let ligne = modele.avalanche.ligneSortie {
                        Text(ligne).font(.footnote)
                    } else {
                        Button("Télécharger le bulletin du jour") { Task { await modele.avalanche.telecharger(id) } }
                    }
                }
            } header: {
                Text("Neige et avalanches")
            } footer: {
                Text("Le risque du jour s'ajoute au message envoyé à votre proche.")
            }
            Section("Le proche à prévenir") {
                TextField("Nom", text: $modele.ficheSortie.procheNom)
                TextField("Téléphone", text: $modele.ficheSortie.procheTelephone).keyboardType(.phonePad)
            }
            Section {
                let message = modele.ficheSortie.message(avalanche: modele.avalanche.ligneSortie)
                if !modele.ficheSortie.telephoneNumerique.isEmpty,
                   let corps = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let u = URL(string: "sms:\(modele.ficheSortie.telephoneNumerique)&body=\(corps)") {
                    Link(destination: u) { Label("Envoyer par SMS à \(modele.ficheSortie.procheNom.isEmpty ? "mon proche" : modele.ficheSortie.procheNom)", systemImage: "message.fill") }
                }
                ShareLink(item: message) { Label("Partager autrement", systemImage: "square.and.arrow.up") }
            } header: {
                Text("Prévenir avant de partir")
            } footer: {
                Text(modele.ficheSortie.message(avalanche: modele.avalanche.ligneSortie)).font(.caption)
            }
            Section {
                BandeauRetour()
                if modele.ficheSortie.enCours {
                    Button("Je suis bien rentré") { terminer() }.bold().foregroundStyle(Charte.securite)
                } else {
                    Button("Je pars : activer le rappel de retour") { partir() }.bold()
                }
            } footer: {
                Text("À l'heure de retour, puis une heure après, une notification vous demande si vous êtes rentré. SIJAMAIS n'envoie jamais d'alerte tout seul : c'est vous, ou votre proche, qui appelez.")
            }
        }
        .navigationTitle("Fiche de sortie")
    }

    private func partir() {
        modele.ficheSortie.enCours = true
        let fiche = modele.ficheSortie
        demarrerCompteARebours(fiche)
        Task {
            let centre = UNUserNotificationCenter.current()
            guard (try? await centre.requestAuthorization(options: [.alert, .sound])) == true else { return }
            centre.removePendingNotificationRequests(withIdentifiers: ["retour-1", "retour-2"])
            for (id, delai, texte) in [("retour-1", 0.0, "C'est l'heure de retour prévue. Si tout va bien, terminez la sortie dans SIJAMAIS."),
                                       ("retour-2", 3600.0, "Retour dépassé d'une heure. Si vous avez besoin d'aide, appelez le 112.")] {
                let quand = fiche.retour.addingTimeInterval(delai)
                guard quand > Date() else { continue }
                let c = UNMutableNotificationContent()
                c.title = "Êtes-vous bien rentré ?"
                c.body = texte
                c.sound = .default
                let declencheur = UNTimeIntervalNotificationTrigger(timeInterval: quand.timeIntervalSinceNow, repeats: false)
                try? await centre.add(UNNotificationRequest(identifier: id, content: c, trigger: declencheur))
            }
        }
    }

    private func terminer() {
        modele.ficheSortie.enCours = false
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["retour-1", "retour-2"])
        Task {
            for activite in Activity<RetourAttributes>.activities { await activite.end(nil, dismissalPolicy: .immediate) }
        }
    }

    /// Compte à rebours sur l'écran verrouillé et dans la Dynamic Island (si l'utilisateur l'autorise).
    private func demarrerCompteARebours(_ fiche: FicheSortie) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        for activite in Activity<RetourAttributes>.activities { Task { await activite.end(nil, dismissalPolicy: .immediate) } }
        let ligne = fiche.itineraire.split(separator: "\n").first.map(String.init) ?? ""
        let contenu = ActivityContent(state: RetourAttributes.ContentState(retour: fiche.retour, proche: fiche.procheNom), staleDate: fiche.retour)
        _ = try? Activity.request(attributes: RetourAttributes(itineraire: ligne.isEmpty ? "Sortie en cours" : ligne), content: contenu)
    }
}
