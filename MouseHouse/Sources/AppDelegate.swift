import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	var eventMonitor: EventMonitor?
	var statusItemController: StatusItemController?

	func applicationDidFinishLaunching(_ notification: Notification) {
		eventMonitor = EventMonitor()
		statusItemController = StatusItemController()
	}
}
