# Premium : abonnement et écran Premium

Construit le 27/11/2026 avec l'accord de Benjamin. Prix décidés : individuel 3,99 € par mois ou 29,99 € par an ; famille 5,99 € par mois ou 44,99 € par an (Partage familial d'Apple, jusqu'à 6 personnes).

## Ce qui est fait

| Élément | Où |
|---|---|
| Offres, univers, règle « ce qui protège reste gratuit », avec leurs tests | `app/SijamaisKit/Sources/SijamaisCore/Premium.swift` |
| Abonnement StoreKit 2 : produits, achat, achat en attente (demande à un parent), restauration, droits du Partage familial, remboursements | `app/Sijamais/Abonnement.swift` |
| Écran Premium : gratuit toujours, 4 univers (Enfants disponible ; Randonnée, Voyage, Mer « bientôt »), offres, conditions de renouvellement, restauration, gestion de l'abonnement | `app/Sijamais/Views/PremiumView.swift` |
| Accès | Tuile « Premium » à l'accueil, section « Abonnement » des réglages |
| Verrouillage | Les 10 modules « version famille » de l'Espace enfants. Un module fermé dit à l'enfant de demander à un parent ; **aucun achat dans l'Espace enfants** |
| Essais sans compte Apple | `app/Sijamais/Premium.storekit`, branché au schéma Xcode : les achats sont simulés, avec les vrais prix en euros |

## Essayer dans Xcode

1. `xcodegen generate`, puis Cmd + R.
2. Accueil, puis la tuile « Premium » : les 4 offres s'affichent avec leurs prix.
3. Acheter une offre : la feuille d'achat d'Apple s'ouvre en mode test, et l'achat est fictif.
4. Ouvrir l'Espace enfants : les cadenas ont disparu.
5. Pour annuler l'achat de test : menu Debug, puis StoreKit, puis Manage Transactions, et supprimer la transaction.

## Avant la vraie mise en vente (à faire par Benjamin)

1. **Compte Apple Developer** (99 $ par an) et contrat « Applications payantes » signé dans App Store Connect, avec coordonnées bancaires et fiscales. Il faut savoir avant si tu encaisses en ton nom ou au nom d'une entreprise.
2. **Créer les 4 abonnements dans App Store Connect**, dans un même groupe, avec **exactement ces identifiants** :
   - `fr.sijamais.premium.famille.annuel`
   - `fr.sijamais.premium.famille.mensuel`
   - `fr.sijamais.premium.annuel`
   - `fr.sijamais.premium.mensuel`

   Le Partage familial s'active sur les deux offres famille.
3. **Conditions d'utilisation et politique de confidentialité** : Apple exige des liens vers ces deux textes dans l'application et dans la fiche App Store pour tout abonnement. Ils ne sont pas encore rédigés ; je peux en faire un premier jet, à faire relire.
4. **Captures et texte de l'offre** pour la vérification d'Apple. L'écran Premium affiche déjà le prix, la durée et les conditions de renouvellement.

## Points d'attention

- Aujourd'hui, seul l'Espace enfants justifie l'abonnement. Il faut au moins un mode de plus (Randonnée, priorité 2) avant de lancer la vente.
- Les modules des enfants ne peuvent pas être vendus avant leurs relectures (PSC1, enseignant, gendarme).
