import AppKit
import Defaults
import SwiftUI

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

	private var window: NSWindow!
	private var windowController: NSWindowController!

	private var eventMonitor = EventMonitor()

	func applicationDidFinishLaunching(_ notification: Notification) {
		window = NSWindow(
			contentRect: NSZeroRect,
			styleMask: [.closable, .titled],
			backing: .buffered,
			defer: true
		)

		window.title = "CenterMouse"
		window.contentView = NSHostingView(rootView: SettingsView())
		windowController = NSWindowController(window: window)

		Settings.setActivationPolicy()

		openSettingsWindow()
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		openSettingsWindow()
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		openSettingsWindow()
		return true
	}

	@IBAction func settingsMenuItemActivated(_ sender: Any) {
		openSettingsWindow()
	}

	func openSettingsWindow() {
		// Works around an annoyance where the app always comes to the foreground when
		// being previewed in Xcode's SwiftUI Canvas.
		guard
			ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"
		else {
			return
		}

		windowController.window?.center()
		windowController.showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
	}
}
