import Defaults
import Foundation

extension Defaults.Keys {
	/// Whether debug mode is enabled
	static let debugEnabled = Key<Bool>("debugEnabled", default: false)

	/// Whether system event monitoring is enabled
	static let systemEventMonitoringEnabled = Key<Bool>("systemEventMonitoringEnabled", default: false)
}

extension Defaults {
	/// Reset `Defaults.Key` items back to their default value.
	static func resetToDefaults() {
		reset([
			.debugEnabled,
			.systemEventMonitoringEnabled,
		])
	}
}
