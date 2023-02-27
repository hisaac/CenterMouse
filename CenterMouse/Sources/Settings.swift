import AppKit
import Defaults

extension Defaults.Keys {
	static let hideDockIcon = Key<Bool>("hideDockIcon", default: false)
	static let monitorSystemEvents = Key<Bool>("monitorSystemEvents", default: true)
}

enum Settings {
	static func setActivationPolicy(hideDockIcon: Bool = Defaults[.hideDockIcon]) {
		NSApp.setActivationPolicy(hideDockIcon ? .accessory : .regular)
		NSApp.activate(ignoringOtherApps: true)
	}
}
