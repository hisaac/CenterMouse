import Cocoa

final class MouseMover {
	public static func moveMouseToCenterOfMainScreen(_ notification: Notification? = nil) {
		if let notification {
			print(notification.name)
		}
		guard let mainScreen = NSScreen.main else { return }
		let centerOfMainScreen = CGPoint(x: mainScreen.frame.midX, y: mainScreen.frame.midY)
		let result = CGWarpMouseCursorPosition(centerOfMainScreen)
		if result == .success {
			print("Success!", result.self)
		} else {
			print("Error!", result.rawValue)
		}
	}
}
