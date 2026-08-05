import Cocoa
import Combine
import Defaults
import KeyboardShortcuts

/// Main actor isolated because KeyboardShortcuts registers hotkeys on the main actor, and because
/// this is only ever constructed by the app delegate during launch.
@MainActor
final class EventMonitor {
	private var subscriptions = Set<AnyCancellable>()

	init() {
		NSWorkspace.shared.notificationCenter
			.publisher(for: .deviceDidWake)
			.sink(receiveValue: MouseMover.handleSystemEvent(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenIsLocked)
			.sink(receiveValue: MouseMover.handleSystemEvent(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenIsUnlocked)
			.sink(receiveValue: MouseMover.handleSystemEvent(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenSaverDidLaunch)
			.sink(receiveValue: MouseMover.handleSystemEvent(_:))
			.store(in: &subscriptions)

		// The keyboard shortcut deliberately bypasses the system event preference. If the user
		// presses the shortcut, they want the pointer moved.
		KeyboardShortcuts.onKeyUp(for: .centerMousePointer) {
			MouseMover.centerMousePointer()
		}

		// Only observe subsequent changes. The launch-time policy is applied by the app delegate,
		// which knows whether activating the app would steal focus.
		Defaults.publisher(.hideDockIcon, options: [])
			.sink { Settings.setActivationPolicy(hideDockIcon: $0.newValue) }
			.store(in: &subscriptions)
	}
}

extension NSNotification.Name {
	static let deviceDidWake = NSWorkspace.didWakeNotification
	static let screenIsLocked = NSNotification.Name("com.apple.screenIsLocked")
	static let screenIsUnlocked = NSNotification.Name("com.apple.screenIsUnlocked")
	static let screenSaverDidLaunch = NSNotification.Name("com.apple.screensaver.didlaunch")

	// Note: "com.apple.screensaver.didstart" and "com.apple.screensaver.didstop" look like they
	// belong here too, but neither is ever delivered in practice.
}
