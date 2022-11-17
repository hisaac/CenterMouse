import AppKit
import Defaults
import Preferences
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow?
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(_ notification: Notification) {
		eventMonitor = EventMonitor()
		openPreferencesWindow()
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		openPreferencesWindow()
	}

	private func openPreferencesWindow() {
		// Works around an annoyance where the app always comes to the foreground when
		// being previewed in Xcode's SwiftUI Canvas.
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
			preferencesWindowController.show()
		}
	}

	lazy var preferencesWindowController: PreferencesWindowController = {
		return PreferencesWindowController(panes: [
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
	}()
}
