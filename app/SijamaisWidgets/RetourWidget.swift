import ActivityKit
import SwiftUI
import WidgetKit

@main
struct SijamaisWidgets: WidgetBundle {
    var body: some Widget {
        RetourActiviteWidget()
    }
}

/// Le compte à rebours est dessiné par le système (Text(timerInterval:)) : aucune mise à jour nécessaire.
/// Passé l'heure de retour, l'activité devient « périmée » et affiche l'alerte.
struct RetourActiviteWidget: Widget {
    private let orange = Color(red: 0xE0 / 255, green: 0x66 / 255, blue: 0x2A / 255)
    private let rouge = Color(red: 0xC8 / 255, green: 0x10 / 255, blue: 0x2E / 255)

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RetourAttributes.self) { contexte in
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "figure.hiking")
                    Text(contexte.isStale ? "Heure de retour dépassée" : "Retour prévu à").font(.headline)
                    Spacer()
                    Text(contexte.state.retour, style: .time).font(.headline)
                }
                if contexte.isStale {
                    Text("Si vous êtes rentré, terminez la sortie dans SIJAMAIS. Sinon, appelez le 112.").font(.footnote)
                } else {
                    Text(timerInterval: Date()...max(Date(), contexte.state.retour), countsDown: true)
                        .font(.title.monospacedDigit().bold())
                }
                Text(contexte.attributes.itineraire).font(.caption).lineLimit(1).opacity(0.8)
            }
            .padding()
            .foregroundStyle(.white)
            .activityBackgroundTint(contexte.isStale ? rouge : orange)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { contexte in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Retour", systemImage: "figure.hiking").font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(contexte.state.retour, style: .time).font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if contexte.isStale {
                        Text("Heure dépassée : rentré ? Sinon, 112.").foregroundStyle(rouge)
                    } else {
                        Text(timerInterval: Date()...max(Date(), contexte.state.retour), countsDown: true)
                            .font(.title2.monospacedDigit().bold())
                    }
                }
            } compactLeading: {
                Image(systemName: "figure.hiking").foregroundStyle(contexte.isStale ? rouge : orange)
            } compactTrailing: {
                if contexte.isStale {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(rouge)
                } else {
                    Text(timerInterval: Date()...max(Date(), contexte.state.retour), countsDown: true)
                        .monospacedDigit()
                        .frame(maxWidth: 56)
                }
            } minimal: {
                Image(systemName: "figure.hiking").foregroundStyle(contexte.isStale ? rouge : orange)
            }
        }
    }
}
