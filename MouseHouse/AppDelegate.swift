import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	var window: NSWindow?
	var mouseMover: MouseMover?

	func applicationDidFinishLaunching(_ notification: Notification) {
		mouseMover = MouseMover()
	}
}
