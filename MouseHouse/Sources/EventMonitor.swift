import Cocoa
import Combine
import KeyboardShortcuts

final class EventMonitor {
	var subscriptions = Set<AnyCancellable>()

	init() {
		NSWorkspace.shared.notificationCenter
			.publisher(for: .deviceDidWake)
			.sink(receiveValue: MouseMover.moveMouseToCenterOfMainScreen(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenIsLocked)
			.sink(receiveValue: MouseMover.moveMouseToCenterOfMainScreen(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenIsUnlocked)
			.sink(receiveValue: MouseMover.moveMouseToCenterOfMainScreen(_:))
			.store(in: &subscriptions)

		DistributedNotificationCenter.default()
			.publisher(for: .screenSaverDidLaunch)
			.sink(receiveValue: MouseMover.moveMouseToCenterOfMainScreen(_:))
			.store(in: &subscriptions)

		KeyboardShortcuts.onKeyUp(for: .moveMouseToHouse) {
			MouseMover.moveMouseToCenterOfMainScreen()
		}
	}

	deinit {
		subscriptions.forEach { $0.cancel() }
	}
}

extension NSNotification.Name {
	// These do work
	static let deviceDidWake = NSWorkspace.didWakeNotification
	static let screenIsLocked = NSNotification.Name("com.apple.screenIsLocked")
	static let screenIsUnlocked = NSNotification.Name("com.apple.screenIsUnlocked")
	static let screenSaverDidLaunch = NSNotification.Name("com.apple.screensaver.didlaunch")

	// These don't seem to work
	static let screenSaverDidStart = NSNotification.Name("com.apple.screensaver.didstart")
	static let screenSaverDidStop = NSNotification.Name("com.apple.screensaver.didstop")
}
