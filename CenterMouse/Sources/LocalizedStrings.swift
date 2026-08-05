import Cocoa

enum LocalizedStrings {
	private static let titleFont = NSFont.preferredFont(forTextStyle: .title3)

	private static let headlineFont: NSFont = {
		let headline = NSFont.preferredFont(forTextStyle: .headline)
		let descriptor = headline.fontDescriptor.withSymbolicTraits([.bold, .italic])
		return NSFont(descriptor: descriptor, size: 0) ?? headline
	}()

	static let credits: NSAttributedString = {
		let creditsString = NSMutableAttributedString()

		// MARK: - More Info Link
		creditsString.append(
			NSAttributedString(string: "More info: ", attributes: [.font: titleFont])
		)
		creditsString.append(
			NSAttributedString(
				string: "hisaac.net/CenterMouse",
				attributes: [
					.link: "https://hisaac.net/CenterMouse",
					.font: titleFont
				]
			)
		)
		creditsString.append(NSAttributedString(string: "\n"))

		// MARK: - Credits
		creditsString.append(
			NSAttributedString(string: "\nCredits\n", attributes: [.font: titleFont])
		)
		creditsString.append(creditedPerson(name: "Isaac Halvorson", role: "Programming"))
		creditsString.append(creditedPerson(name: "Eli Mellen", role: "Initial Idea and QA Testing"))

		// MARK: - Open Source Libraries
		creditsString.append(
			NSAttributedString(string: "\nOpen Source Libraries\n", attributes: [.font: titleFont])
		)
		creditsString.append(openSourceLibrary(
			name: "Defaults", url: "https://github.com/sindresorhus/Defaults"
		))
		creditsString.append(openSourceLibrary(
			name: "KeyboardShortcuts", url: "https://github.com/sindresorhus/KeyboardShortcuts"
		))
		creditsString.append(openSourceLibrary(
			name: "LaunchAtLogin", url: "https://github.com/sindresorhus/LaunchAtLogin-Modern"
		))

		return creditsString
	}()

	private static func creditedPerson(name: String, role: String) -> NSAttributedString {
		let creditedPersonString = NSMutableAttributedString()

		creditedPersonString.append(
			NSAttributedString(string: "\(role)\n", attributes: [.font: headlineFont])
		)
		creditedPersonString.append(
			NSAttributedString(string: "    \(name)\n")
		)

		return creditedPersonString
	}

	private static func openSourceLibrary(name: String, url: String) -> NSAttributedString {
		let openSourceLibraryString = NSMutableAttributedString()

		openSourceLibraryString.append(NSAttributedString(string: "  \u{2022} "))
		openSourceLibraryString.append(
			NSAttributedString(string: "\(name)\n", attributes: [.link: url])
		)

		return openSourceLibraryString
	}
}
