import Cocoa
import Defaults

final class StatusItemController: NSObject {

	weak var delegate: PreferencesWindowDelegate?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private lazy var menu = buildMenu()

	override init() {
		super.init()
		setupStatusItem()
		setupUserDefaultsObservers()
	}

	private func setupStatusItem() {
		statusItem.button?.image = NSImage(
			systemSymbolName: "dot.circle.and.hand.point.up.left.fill",
			accessibilityDescription: nil
		)
		if #available(macOS 13.0, *) {
			statusItem.button?.image?.withSymbolConfiguration(.preferringHierarchical())
		}

		statusItem.button?.target = self
		statusItem.button?.action = #selector(didClickStatusItem(_:))
		statusItem.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])
	}

	private func setupUserDefaultsObservers() {
		Defaults.observe(.debugEnabled) { [weak self] change in
			if change.newValue == true {
				self?.debugMenuItem.state = .on
			} else {
				self?.debugMenuItem.state = .off
			}
		}.tieToLifetime(of: self)

		Defaults.observe(.mouseMovingEnabled) { [weak self] change in
			if change.newValue == true {
				self?.mouseMovingMenuItem.state = .on
			} else {
				self?.mouseMovingMenuItem.state = .off
			}
		}.tieToLifetime(of: self)
	}

	private func buildMenu() -> NSMenu {
		let menu = NSMenu()
		menu.delegate = self
		menu.items = [
			NSMenuItem(
				title: LocalizedStrings.appVersion,
				target: self,
				isEnabled: false
			),
			NSMenuItem.separator(),
			mouseMovingMenuItem,
			NSMenuItem.separator(),
			debugMenuItem,
			NSMenuItem.separator(),
			NSMenuItem(
				title: "Preferences…",
				action: #selector(openPreferencesWindow),
				keyEquivalent: ",",
				target: self
			),
			NSMenuItem(
				title: "About MouseHouse",
				action: #selector(openAboutPage),
				target: self
			),
			NSMenuItem(
				title: "Quit",
				action: #selector(NSApp.terminate),
				keyEquivalent: "q",
				target: NSApp
			)
		]
		return menu
	}

	private lazy var debugMenuItem: NSMenuItem = {
		return NSMenuItem(
			title: "Debug",
			action: #selector(toggleDebugMode),
			target: self
		)
	}()

	private lazy var mouseMovingMenuItem: NSMenuItem = {
		return NSMenuItem(
			title: "MouseHouse Enabled",
			action: #selector(toggleMouseMovingEnabled),
			target: self
		)
	}()

	// MARK: - Menu Item Actions

	@objc
	private func openPreferencesWindow() {
		delegate?.openPreferencesWindow()
	}

	@objc
	private func openAboutPage() {
		#warning("Update this URL")
		guard let url = URL(string: "https://level.software") else { return }
		NSWorkspace.shared.open(url)
	}

	@objc
	private func toggleDebugMode() {
		Defaults[.debugEnabled].toggle()
	}

	@objc
	private func toggleMouseMovingEnabled() {
		Defaults[.mouseMovingEnabled].toggle()
	}

	// MARK: - Mouse Click Handling

	@objc
	private func didClickStatusItem(_ sender: NSStatusItem) {
		if isCurrentEventRightClickUp() {
			rightClickAction()
		} else {
			leftClickAction()
		}
	}

	private func isCurrentEventRightClickUp() -> Bool {
		guard let currentEvent = NSApp.currentEvent else { return false }
		let isRightClick = currentEvent.type == .rightMouseUp
		let isControlClick = currentEvent.modifierFlags.contains(.control)
		return isRightClick || isControlClick
	}

	private func rightClickAction() {
		toggleMouseMovingEnabled()
	}

	private func leftClickAction() {
		statusItem.menu = menu
		statusItem.button?.performClick(nil)
	}
}

extension StatusItemController: NSMenuDelegate {
	internal func menuDidClose(_ menu: NSMenu) {
		// In order to handle a right-click event on the status item,
		// we need to set the status item's menu to `nil`. Otherwise
		// a right-click will perform the same action as a left-click.
		statusItem.menu = nil
	}
}

extension NSMenuItem {
	convenience init(title: String,
					 action: Selector? = nil,
					 keyEquivalent: String = "",
					 target: AnyObject? = nil,
					 isEnabled: Bool = true) {
		self.init(title: title, action: action, keyEquivalent: keyEquivalent)
		self.target = target
		self.isEnabled = isEnabled
	}
}
