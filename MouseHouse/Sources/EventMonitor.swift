import Cocoa
import Combine

final class EventMonitor {
	var subscriptions = Set<AnyCancellable>()

	init() {
		NSWorkspace.shared.notificationCenter
			.publisher(for: .deviceDidWake)
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
	}

	deinit {
		subscriptions.forEach { $0.cancel() }
	}
}

extension NSNotification.Name {
	// These Work
	static let deviceDidWake = NSWorkspace.didWakeNotification
	static let screenIsUnlocked = NSNotification.Name("com.apple.screenIsUnlocked")
	static let screenSaverDidLaunch = NSNotification.Name("com.apple.screensaver.didlaunch")

	// These Don't Work
//	static let screenIsLocked = NSNotification.Name("com.apple.screenIsLocked")
//	static let screenSaverDidStart = NSNotification.Name("com.apple.screensaver.didstart")
//	static let screenSaverDidStop = NSNotification.Name("com.apple.screensaver.didstop")
}
