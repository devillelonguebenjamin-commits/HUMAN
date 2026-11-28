import Foundation
import Observation
import StoreKit
import SijamaisCore

/// Abonnement premium avec StoreKit 2 : produits, achat, restauration, suivi des droits.
/// Rien n'est stocké chez SIJAMAIS : c'est Apple qui sait si le foyer est abonné (Partage familial compris).
@Observable
@MainActor
final class Abonnement {
    private(set) var produits: [Product] = []
    private(set) var actif = false
    private(set) var produitActif: String?
    var message: String?
    private(set) var enCours = false

    init() {
        // Achats faits ailleurs (autre appareil, Partage familial, renouvellement, remboursement).
        Task { [weak self] in
            for await resultat in Transaction.updates {
                if case let .verified(t) = resultat { await t.finish() }
                await self?.actualiser()
            }
        }
        Task { [weak self] in
            await self?.charger()
            await self?.actualiser()
        }
    }

    func charger() async {
        do {
            produits = try await Product.products(for: OffrePremium.identifiants)
                .sorted { OffrePremium.rang($0.id) < OffrePremium.rang($1.id) }
            if produits.isEmpty { message = "Les offres ne sont pas disponibles pour le moment." }
        } catch {
            message = "Impossible de charger les offres. Vérifiez la connexion internet."
        }
    }

    /// Le foyer est abonné si Apple fournit un droit vérifié, non remboursé, sur l'un des 4 abonnements.
    func actualiser() async {
        var trouve: String?
        for await resultat in Transaction.currentEntitlements {
            if case let .verified(t) = resultat, t.revocationDate == nil, OffrePremium.identifiants.contains(t.productID) {
                trouve = t.productID
            }
        }
        produitActif = trouve
        actif = trouve != nil
    }

    func acheter(_ produit: Product) async {
        enCours = true
        defer { enCours = false }
        do {
            switch try await produit.purchase() {
            case let .success(verification):
                if case let .verified(t) = verification {
                    await t.finish()
                    message = "Merci ! Votre abonnement est actif."
                } else {
                    message = "L'achat n'a pas pu être vérifié."
                }
                await actualiser()
            case .pending:
                message = "Achat en attente d'autorisation (par exemple, d'un parent)."
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            message = "L'achat n'a pas abouti."
        }
    }

    func restaurer() async {
        enCours = true
        defer { enCours = false }
        do {
            try await AppStore.sync()
            await actualiser()
            message = actif ? "Votre abonnement est rétabli." : "Aucun abonnement trouvé pour cet identifiant Apple."
        } catch {
            message = "La restauration n'a pas abouti."
        }
    }
}
