import SwiftUI

@main
struct SijamaisApp: App {
    @State private var modele = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(modele)
                .tint(Charte.balise)
        }
    }
}
