import AppKit
import Defaults
import SwiftUI

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

	private var window: NSWindow!
	private var windowController: NSWindowController!

	private var eventMonitor = EventMonitor()

	/// Whether or not the app is relaunching after it has been launched and quit before
	///
	/// We track this to know whether or not to open the Settings window. If this is a
	/// fresh relaunch, we _don't_ want to open the Settings window right away.
	private var isRelaunch = false

	func applicationWillFinishLaunching(_ notification: Notification) {
		if Defaults[.firstTimeAppLaunched] {
			Defaults[.firstTimeAppLaunched] = false
		} else {
			isRelaunch = true
		}
	}

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

	@IBAction func windowMenuMainWindowItemActivated(_ sender: NSMenuItem) {
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

		// We only need to check whether this is a relaunch the first time this method
		// is called (by `applicationDidBecomeActive(_:)`). After that, we'll want to
		// open the Settings window whenever this method is called, so we set the value
		// to `false`.
		guard isRelaunch == false else {
			isRelaunch = false
			return
		}

		windowController.window?.center()
		windowController.showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
	}
}
