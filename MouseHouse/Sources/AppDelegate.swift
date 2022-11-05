import AppKit
import Defaults
import Preferences
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow?
	var eventMonitor: EventMonitor?
	var statusItemController: StatusItemController?

	func applicationDidFinishLaunching(_ notification: Notification) {
		eventMonitor = EventMonitor()

		statusItemController = StatusItemController()
		statusItemController?.delegate = self
	}

	lazy var preferencesWindowController: PreferencesWindowController = {
		let controller = PreferencesWindowController(panes: [
			Preferences.Pane(
				identifier: .general,
				title: "General",
				toolbarIcon: NSImage(
					systemSymbolName: "gearshape",
					accessibilityDescription: "General Preferences"
				)!,
				contentView: { GeneralPreferencesView() }
			)
		])
		controller.hidesToolbarForSingleItem = false
		return controller
	}()
}

protocol PreferencesWindowDelegate: AnyObject {
	func openPreferencesWindow()
}

extension AppDelegate: PreferencesWindowDelegate {
	func openPreferencesWindow() {
		preferencesWindowController.show()
	}
}
