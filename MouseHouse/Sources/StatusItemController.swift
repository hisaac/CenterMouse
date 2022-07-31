import Cocoa

final class StatusItemController {

	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private lazy var menu = buildMenu()

	init() {
		setupStatusItem()
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

	private func buildMenu() -> NSMenu {
		return NSMenu()
	}

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
//		toggleIsEnabled()
	}

	private func leftClickAction() {
		statusItem.menu = menu
		statusItem.button?.performClick(nil)
	}
}
