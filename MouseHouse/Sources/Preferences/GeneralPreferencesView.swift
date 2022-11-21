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
					Text("\u{2022}  Waking from sleep")
					Text("\u{2022}  Locking the screen")
					Text("\u{2022}  Unlocking the screen")
					Text("\u{2022}  Exiting the screen saver")
				}.preferenceDescription()
			}

			Preferences.Section(title: "Keyboard Shortcut", bottomDivider: true) {
				Form {
					KeyboardShortcuts.Recorder(for: .moveMouseToHouse)
				}
				Text("Define a global keyboard shortcut to move the mouse")
					.preferenceDescription()
			}
		}
		VStack(alignment: .trailing) {
			HStack {
				Button("About") {
					
					NSApp.orderFrontStandardAboutPanel(
						options: [
							.applicationIcon: NSWorkspace.shared.icon(forFile: Bundle.main.bundlePath),
							.credits: LocalizedStrings.credits
						]
					)
				}
				Button("Quit") {
					NSApp.terminate(nil)
				}
			}
			Text("You can safely close this window, and MouseHouse will continue to run in the background")
				.preferenceDescription()
		}.padding([.leading, .trailing, .bottom])
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
