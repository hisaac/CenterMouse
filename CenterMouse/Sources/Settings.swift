import AppKit
import Defaults

extension Defaults.Keys {
	static let hideDockIcon = Key<Bool>("hideDockIcon", default: false)
	static let monitorSystemEvents = Key<Bool>("monitorSystemEvents", default: true)
}

enum Settings {
	/// Shows or hides the Dock icon.
	///
	/// - Parameter activate: Whether to bring the app to the foreground afterwards. Switching to
	///   `.regular` while the app is frontmost otherwise leaves it behind other apps, but
	///   activating is wrong at launch, where it would steal focus from whatever the user is doing.
	@MainActor
	static func setActivationPolicy(hideDockIcon: Bool = Defaults[.hideDockIcon], activate: Bool = true) {
		NSApp.setActivationPolicy(hideDockIcon ? .accessory : .regular)

		if activate {
			NSApp.activate(ignoringOtherApps: true)
		}
	}
}
