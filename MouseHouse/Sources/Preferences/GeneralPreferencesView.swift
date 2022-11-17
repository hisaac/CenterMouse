import Defaults
import KeyboardShortcuts
import Preferences
import SwiftUI

extension Preferences.PaneIdentifier {
	static let general = Self("general")
}

extension KeyboardShortcuts.Name {
	static let moveMouseToHouse = Self("moveMouseToHouse")
}

/// The main view of the "General" preference pane
struct GeneralPreferencesView: View {

	@Default(.systemEventMonitoringEnabled) var systemEventMonitoringEnabled

	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "System Event Monitoring") {
				Toggle("Move mouse on system events", isOn: $systemEventMonitoringEnabled)
				Group {
					Text("System events include:")
					Text("•  Waking from sleep")
					Text("•  Unlocking the screen")
					Text("•  Exiting the screen saver")
				}.preferenceDescription()
			}

			Preferences.Section(title: "Keyboard Shortcut", bottomDivider: true) {
				Form {
					KeyboardShortcuts.Recorder(for: .moveMouseToHouse)
				}
				Text("Define a global keyboard shortcut to move the mouse to the center of your main monitor")
					.preferenceDescription()
			}
			Preferences.Section(title: "", verticalAlignment: .center) {
				HStack {
					Button("Quit") {
						NSApp.terminate(nil)
					}
					Button("About") {
						NSApp.orderFrontStandardAboutPanel(
							options: [.credits: LocalizedStrings.creds]
						)
					}
				}
			}
		}
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
