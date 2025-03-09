import AppKit
import Defaults
import SwiftUI

@main
@MainActor final class AppDelegate: NSObject, NSApplicationDelegate {

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

		// Excluding this from the Window menu so that it can be manually added.
		// This is being done to comply with an App Review requirement.
		window.isExcludedFromWindowsMenu = true

		window.contentView = NSHostingView(rootView: SettingsView())
		windowController = NSWindowController(window: window)

		if launchedAsLogInItem == false {
			openSettingsWindow()
		}
	}

	private var launchedAsLogInItem: Bool {
		// source: https://stackoverflow.com/a/19890943/4118208
		guard let event = NSAppleEventManager.shared().currentAppleEvent else { return false }
		return
			event.eventID == kAEOpenApplication &&
			event.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
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

		windowController.window?.center()
		windowController.showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
	}
}
