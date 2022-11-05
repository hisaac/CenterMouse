import Cocoa

enum LocalizedStrings {
	/// Localized version of "Enabled"
	/// For use as the title for the "Enabled" menu item
	static let enabledMenuItemTitle = NSLocalizedString(
		"enabledMenuItemTitle",
		value: "Mouse Moving Enabled",
		comment: #"Title for the "Enabled" menu item"#
	)

	// MARK: - Version Number

	/// Localized version of the word "Version"
	/// For use in representing the app's version number
	static let versionTitle = NSLocalizedString(
		"versionTitle",
		value: "Version",
		comment: "The word for 'Version'"
	)

	/// Localized version of the app's version number
	/// Formatted as: "Version 1.0.1"
	static var appVersion: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
		return "\(versionTitle) \(versionNumber)"
	}

	/// Get a system localized string
	/// Use https://itunes.apple.com/no/app/system-strings/id570467776 to find strings
	static func localizedString(forKey key: String) -> String {
		return Bundle(for: NSApplication.self).localizedString(forKey: key, value: nil, table: nil)
	}
}
