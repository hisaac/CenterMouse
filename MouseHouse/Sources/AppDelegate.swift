import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(_ notification: Notification) {
		eventMonitor = EventMonitor()
	}
}
