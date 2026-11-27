import Foundation

/// Cartes hors ligne de toute la France (27/11/2026) : une vue d'ensemble embarquée (zoom 0 à 8),
/// puis un fichier par département (zoom 15), téléchargé une fois et lisible sans réseau.
/// Gratuit : le département de l'utilisateur (la carte protège). Premium : tous les autres.
public struct CartesFrance: Decodable, Sendable {
    public struct Departement: Decodable, Sendable, Hashable, Identifiable {
        public let code: String
        public let nom: String
        public let region: String
        /// Ouest, sud, est, nord.
        public let cadre: [Double]
        /// Contours simplifiés (anneaux extérieurs, [longitude, latitude]).
        public let contours: [[[Double]]]
        public var id: String { code }

        /// Vrai si le point est dans le département (cadre, puis contour : méthode du rayon).
        public func contient(latitude: Double, longitude: Double) -> Bool {
            guard cadre.count == 4, longitude >= cadre[0], latitude >= cadre[1], longitude <= cadre[2], latitude <= cadre[3] else { return false }
            return contours.contains { anneau in
                var dedans = false
                var j = anneau.count - 1
                for i in anneau.indices {
                    let (xi, yi, xj, yj) = (anneau[i][0], anneau[i][1], anneau[j][0], anneau[j][1])
                    if (yi > latitude) != (yj > latitude), longitude < (xj - xi) * (latitude - yi) / (yj - yi) + xi { dedans.toggle() }
                    j = i
                }
                return dedans
            }
        }

        public var centre: (latitude: Double, longitude: Double) { ((cadre[1] + cadre[3]) / 2, (cadre[0] + cadre[2]) / 2) }
    }

    public struct VueEnsemble: Decodable, Sendable {
        public let fichier: String
        public let cadre: [Double]
        public let zoomMax: Int
    }

    public let version: String
    public let zoomMax: Int
    public let vueEnsemble: VueEnsemble
    /// Adresse de l'hébergement des fichiers (vide tant que l'hébergement n'est pas en place).
    public let adresseBase: String
    public let departements: [Departement]

    public static var integre: CartesFrance? {
        Bundle.module.url(forResource: "departements", withExtension: "json")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(CartesFrance.self, from: $0) }
    }

    public func departement(_ code: String) -> Departement? { departements.first { $0.code == code } }

    /// Les régions dans l'ordre alphabétique, outre-mer à la fin.
    public var regions: [String] {
        Array(Set(departements.map(\.region))).sorted { a, b in
            if a == "Outre-mer" { return false }
            if b == "Outre-mer" { return true }
            return a.localizedCompare(b) == .orderedAscending
        }
    }

    /// Le département qui contient un point.
    public func departement(latitude: Double, longitude: Double) -> Departement? {
        departements.first { $0.contient(latitude: latitude, longitude: longitude) }
    }

    /// Règle d'accès : le département principal est gratuit ; les autres demandent l'abonnement.
    public static func peutTelecharger(_ code: String, principal: String?, abonne: Bool) -> Bool {
        abonne || code == principal
    }

    /// Adresse d'un fichier départemental chez l'hébergeur.
    public func adresse(_ code: String) -> URL? {
        guard !adresseBase.isEmpty else { return nil }
        return URL(string: adresseBase.hasSuffix("/") ? adresseBase + "\(code).pmtiles" : adresseBase + "/\(code).pmtiles")
    }
}

/// Catalogue publié avec les fichiers (cartes_france/catalogue.json) : taille et empreinte de chaque département.
public struct CatalogueCartes: Decodable, Sendable {
    public struct Fichier: Decodable, Sendable {
        public let fichier: String
        public let octets: Int64
        public let sha256: String
    }

    public let version: String
    public let fichiers: [String: Fichier]
}

/// Compose le style MapLibre : vue d'ensemble en dessous, départements téléchargés par-dessus, points de secours au-dessus.
/// Les noms de lieux ne se dédoublent pas : ceux de la vue d'ensemble s'arrêtent au zoom 9, ceux des départements commencent au zoom 9.
public enum StyleCarte {
    public static func composer(modele: Data, vueEnsemble: URL?, departements: [(code: String, fichier: URL)], points: URL, glyphes: String) throws -> Data {
        guard var style = try JSONSerialization.jsonObject(with: modele) as? [String: Any],
              let couches = style["layers"] as? [[String: Any]],
              var sources = style["sources"] as? [String: Any],
              let fond = sources["fond"] as? [String: Any] else { throw CocoaError(.fileReadCorruptFile) }

        sources.removeValue(forKey: "fond")
        if var secours = sources["secours"] as? [String: Any] {
            secours["data"] = points.absoluteString
            sources["secours"] = secours
        }
        func source(_ fichier: URL) -> [String: Any] {
            var s = fond
            s["url"] = "pmtiles://" + fichier.absoluteString
            return s
        }

        let duFond = couches.filter { ($0["source"] as? String) == "fond" }
        let autres = couches.filter { ($0["source"] as? String) != "fond" }
        let arriere = autres.filter { ($0["type"] as? String) == "background" }
        let dessus = autres.filter { ($0["type"] as? String) != "background" }

        var resultat = arriere
        if let v = vueEnsemble {
            sources["vue"] = source(v)
            for var c in duFond {
                c["id"] = "vue-" + (c["id"] as? String ?? "")
                c["source"] = "vue"
                if (c["type"] as? String) == "symbol" { c["maxzoom"] = 9 }
                resultat.append(c)
            }
        }
        for d in departements {
            let nom = "fond-" + d.code
            sources[nom] = source(d.fichier)
            for var c in duFond {
                c["id"] = d.code + "-" + (c["id"] as? String ?? "")
                c["source"] = nom
                if (c["type"] as? String) == "symbol" { c["minzoom"] = max(c["minzoom"] as? Double ?? 0, vueEnsemble == nil ? 0 : 9) }
                resultat.append(c)
            }
        }
        resultat += dessus
        style["sources"] = sources
        style["layers"] = resultat
        style["glyphs"] = (style["glyphs"] as? String ?? "").replacingOccurrences(of: "__GLYPHES__", with: glyphes)
        return try JSONSerialization.data(withJSONObject: style, options: [.sortedKeys])
    }
}
