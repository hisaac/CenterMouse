import Cocoa
import Defaults
import OSLog

enum MouseMover {
	private static let logger = Logger(
		subsystem: Bundle.main.bundleIdentifier ?? "software.level.CenterMouse",
		category: "MouseMover"
	)

	/// Centers the pointer in response to a system event, respecting the user's
	/// preference for whether system events should be monitored at all.
	static func handleSystemEvent(_ notification: Notification) {
		guard Defaults[.monitorSystemEvents] else {
			logger.debug("System event monitoring is disabled. Ignoring \(notification.name.rawValue, privacy: .public)")
			return
		}

		logger.debug("Handling \(notification.name.rawValue, privacy: .public)")
		centerMousePointer()
	}

	/// Moves the pointer to the center of the primary display.
	///
	/// This is unconditional on purpose: it backs the user's keyboard shortcut, which should
	/// always work regardless of the system event monitoring preference.
	static func centerMousePointer() {
		// The first screen is always the primary display, which is the only screen whose
		// AppKit frame and `CGWarpMouseCursorPosition`'s global display coordinates share an
		// origin. That means its center needs no conversion between the two coordinate spaces.
		guard let primaryScreen = NSScreen.screens.first else {
			logger.error("No screens available, so there is nowhere to move the pointer to")
			return
		}

		let center = CGPoint(x: primaryScreen.frame.midX, y: primaryScreen.frame.midY)
		let result = CGWarpMouseCursorPosition(center)

		guard result == .success else {
			logger.error("Failed to move the pointer, CGWarpMouseCursorPosition returned \(result.rawValue)")
			return
		}

		logger.debug("Moved the pointer to \(center.x), \(center.y)")
	}
}
