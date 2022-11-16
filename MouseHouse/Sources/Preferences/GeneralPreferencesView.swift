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
	@Default(.showMenuItem) var showMenuItem
	@Default(.showInDock) var showInDock
	@Default(.statusItemLeftClickBehavior) var statusItemLeftClickBehavior

	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "System Event Monitoring") {
				Toggle("Move mouse on system events", isOn: $systemEventMonitoringEnabled)
				Group {
					Text("System events include:")
					Text("• Waking from sleep")
					Text("• Unlocking the screen")
					Text("• Exiting the screen saver")
				}.preferenceDescription()
			}

			Preferences.Section(title: "Keyboard Shortcut") {
				Form {
					KeyboardShortcuts.Recorder(for: .moveMouseToHouse)
				}
				Text("Define a global keyboard shortcut to move the mouse to the center of your main monitor")
					.preferenceDescription()
			}


			Preferences.Section(title: "User Interface") {
				Toggle("Show dock icon", isOn: $showInDock)
				Toggle("Show menu item", isOn: $showMenuItem)
				Text(#"Disable both options to run MouseHouse in "headless" mode. When in this mode, launching the app will bring up this preferences window"#)
					.preferenceDescription()
			}
			Preferences.Section(title: "Left-click behavior") {
				Picker(selection: $statusItemLeftClickBehavior) {
					Text("Clicking opens menu").tag(StatusItemLeftClickBehavior.openMenu)
					Text("Clicking toggles system event monitoring").tag(StatusItemLeftClickBehavior.toggleMonitoring)
				} label: {
					EmptyView()
				}
				.pickerStyle(RadioGroupPickerStyle())
				.disabled(!showMenuItem)
			}
		}
		.padding(.trailing, 50)
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
