import Charts
import SwiftUI
import UniformTypeIdentifiers
import SijamaisCore

/// Les traces GPX gardées sur le téléphone (dossier Documents/Traces), importées depuis Fichiers, iCloud ou une autre application.
enum BibliothequeTraces {
    static var dossier: URL {
        let d = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Traces", isDirectory: true)
        try? FileManager.default.createDirectory(at: d, withIntermediateDirectories: true)
        return d
    }

    static func lister() -> [(url: URL, trace: TraceGPX)] {
        let fichiers = (try? FileManager.default.contentsOfDirectory(at: dossier, includingPropertiesForKeys: [.contentModificationDateKey])) ?? []
        return fichiers.filter { $0.pathExtension.lowercased() == "gpx" }
            .compactMap { u in (try? Data(contentsOf: u)).flatMap { try? TraceGPX.lire($0, nomParDefaut: u.deletingPathExtension().lastPathComponent) }.map { (u, $0) } }
            .sorted { $0.trace.nom.localizedCompare($1.trace.nom) == .orderedAscending }
    }

    /// Copie le fichier choisi dans la bibliothèque, après avoir vérifié que c'est bien une trace lisible.
    static func importer(_ source: URL) throws -> TraceGPX {
        let acces = source.startAccessingSecurityScopedResource()
        defer { if acces { source.stopAccessingSecurityScopedResource() } }
        let donnees = try Data(contentsOf: source)
        let trace = try TraceGPX.lire(donnees, nomParDefaut: source.deletingPathExtension().lastPathComponent)
        var cible = dossier.appendingPathComponent(source.lastPathComponent)
        if cible.pathExtension.lowercased() != "gpx" { cible = cible.appendingPathExtension("gpx") }
        try? FileManager.default.removeItem(at: cible)
        try donnees.write(to: cible)
        return trace
    }
}

/// « Mes traces » (premium).
struct TracesView: View {
    @State private var traces: [(url: URL, trace: TraceGPX)] = []
    @State private var choisir = false
    @State private var erreur: String?

    private var typeGPX: [UTType] { [UTType(filenameExtension: "gpx") ?? .xml, .xml] }

    var body: some View {
        List {
            Section {
                Button { choisir = true } label: { Label("Ouvrir une trace GPX", systemImage: "square.and.arrow.down") }
                if let e = erreur { Text(e).font(.footnote).foregroundStyle(Charte.secours) }
            } footer: {
                Text("Exportez la trace depuis Komoot, Visorando, Strava, Garmin Connect ou votre montre (format GPX), enregistrez-la dans Fichiers, puis ouvrez-la ici. Elle reste sur ce téléphone.")
            }
            if !traces.isEmpty {
                Section("Mes traces") {
                    ForEach(traces, id: \.url) { t in
                        NavigationLink { TraceDetailView(url: t.url, trace: t.trace) } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(t.trace.nom).font(.headline)
                                Text(String(format: "%.1f km · +%d m", locale: Locale(identifier: "fr_FR"), t.trace.distanceMetres / 1000, Int(t.trace.denivele.positif.rounded())))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { index in
                        for i in index { try? FileManager.default.removeItem(at: traces[i].url) }
                        traces = BibliothequeTraces.lister()
                    }
                }
            }
        }
        .navigationTitle("Mes traces")
        .onAppear { traces = BibliothequeTraces.lister() }
        .fileImporter(isPresented: $choisir, allowedContentTypes: typeGPX) { resultat in
            switch resultat {
            case let .success(url):
                do { _ = try BibliothequeTraces.importer(url); erreur = nil } catch { erreur = "Ce fichier n'est pas une trace GPX lisible." }
                traces = BibliothequeTraces.lister()
            case .failure:
                erreur = "Le fichier n'a pas pu être ouvert."
            }
        }
    }
}

/// Détail d'une trace : chiffres clés, profil, fiche de sortie, envoi vers une autre application.
struct TraceDetailView: View {
    @Environment(AppModel.self) private var modele
    let url: URL
    let trace: TraceGPX
    @State private var utilisee = false

    var body: some View {
        let d = trace.denivele
        List {
            Section {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    chiffre("Distance", String(format: "%.1f km", locale: Locale(identifier: "fr_FR"), trace.distanceMetres / 1000))
                    chiffre("Marche estimée", duree(trace.minutesDeMarche))
                    chiffre("Dénivelé positif", "+\(Int(d.positif.rounded())) m")
                    chiffre("Dénivelé négatif", "-\(Int(d.negatif.rounded())) m")
                    if let mi = trace.altitudeMin, let ma = trace.altitudeMax {
                        chiffre("Altitude basse", "\(Int(mi.rounded())) m")
                        chiffre("Altitude haute", "\(Int(ma.rounded())) m")
                    }
                }
                .padding(.vertical, 4)
            } footer: {
                Text("Estimation sans pauses (méthode DIN 33466 : 4 km/h à plat, 300 m/h en montée, 500 m/h en descente). Avec 10 minutes de pause par heure : \(duree(trace.minutesAvecPauses)). Adaptez à votre groupe et à la météo.")
            }

            let profil = trace.profil()
            if profil.count > 1 {
                Section("Profil") {
                    Chart(profil.indices, id: \.self) { i in
                        AreaMark(x: .value("km", profil[i].km), y: .value("Altitude", profil[i].altitude))
                            .foregroundStyle(Charte.preparation.opacity(0.25))
                        LineMark(x: .value("km", profil[i].km), y: .value("Altitude", profil[i].altitude))
                            .foregroundStyle(Charte.preparation)
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .chartXAxisLabel("km")
                    .chartYAxisLabel("m")
                    .frame(height: 180)
                }
            }

            Section {
                Button {
                    modele.ficheSortie.itineraire = trace.resume
                    modele.ficheSortie.retour = modele.ficheSortie.depart.addingTimeInterval(Double(trace.minutesAvecPauses) * 60)
                    utilisee = true
                } label: { Label("Utiliser pour ma fiche de sortie", systemImage: "map") }
                if utilisee {
                    NavigationLink { FicheSortieView() } label: { Label("Itinéraire et heure de retour remplis : ouvrir la fiche", systemImage: "checkmark.circle.fill") }
                        .foregroundStyle(Charte.securite)
                }
                ShareLink(item: url) { Label("Envoyer vers une montre ou une autre application", systemImage: "square.and.arrow.up") }
            } footer: {
                Text("SIJAMAIS n'est pas un GPS de randonnée : suivez le balisage et la carte. La trace sert à préparer la sortie et à prévenir un proche.")
            }
        }
        .navigationTitle(trace.nom)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chiffre(_ titre: String, _ valeur: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(titre).font(.caption).foregroundStyle(.secondary)
            Text(valeur).font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func duree(_ m: Int) -> String { "\(m / 60) h \(String(format: "%02d", m % 60))" }
}
