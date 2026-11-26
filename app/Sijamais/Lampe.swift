import AVFoundation
import Observation

/// Lampe torche : utilise le flash de l'iPhone.
@Observable
@MainActor
final class Lampe {
    private(set) var allumee = false

    var disponible: Bool {
        AVCaptureDevice.default(for: .video)?.hasTorch ?? false
    }

    func basculer() {
        guard let appareil = AVCaptureDevice.default(for: .video), appareil.hasTorch else { return }
        do {
            try appareil.lockForConfiguration()
            appareil.torchMode = allumee ? .off : .on
            appareil.unlockForConfiguration()
            allumee.toggle()
        } catch {
            allumee = false
        }
    }
}
