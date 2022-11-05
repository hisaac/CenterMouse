import Defaults
import Preferences
import SwiftUI

extension Preferences.PaneIdentifier {
	static let general = Self("general")
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
				#warning("TODO: Add toggles for event types")
				Toggle("Move mouse when waking from sleep", isOn: $systemEventMonitoringEnabled)
				Toggle("Move mouse when unlocking screen", isOn: $systemEventMonitoringEnabled)
				Toggle("Move mouse when leaving screen saver", isOn: $systemEventMonitoringEnabled)
			}

			Preferences.Section(title: "User Interface") {
				Toggle("Show dock icon", isOn: $showInDock)
				Toggle("Show menu item", isOn: $showMenuItem)
				Text("When the menu item is hidden, launching the app will bring up this preferences window")
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
