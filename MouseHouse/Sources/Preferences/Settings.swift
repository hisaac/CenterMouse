import Defaults
import Foundation

extension Defaults.Keys {
	/// Whether debug mode is enabled
	static let debugEnabled = Key<Bool>("debugEnabled", default: false)

	/// Whether system event monitoring is enabled
	static let systemEventMonitoringEnabled = Key<Bool>("systemEventMonitoringEnabled", default: false)

	/// Whether or not mouse moving is enabled
	static let mouseMovingEnabled = Key<Bool>("mouseMovingEnabled", default: true)

	/// Tracks if this is the first time the app has been launched
	static let firstLaunch = Key<Bool>("firstLaunch", default: true)

	/// Whether or not to hide the menu item from the menu bar
	static let showMenuItem = Key<Bool>("showMenuItem", default: true)

	/// Whether or not to show the app in the dock
	static let showInDock = Key<Bool>("showInDock", default: false)

	/// What happens when left-clicking on the status item
	static let statusItemLeftClickBehavior = Key<StatusItemLeftClickBehavior>("statusItemLeftClickBehavior", default: .openMenu)
}

enum StatusItemLeftClickBehavior: String, Defaults.Serializable {
	case openMenu
	case toggleMonitoring
}

extension Defaults {
	/// Reset `Defaults.Key` items back to their default value.
	static func resetToDefaults() {
		reset([
			.debugEnabled,
			.systemEventMonitoringEnabled,
			.firstLaunch,
			.showMenuItem,
			.showInDock,
			.statusItemLeftClickBehavior
		])
	}
}
