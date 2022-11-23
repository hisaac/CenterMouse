import Cocoa

enum LocalizedStrings {
	static let titleFont = NSFont.title3
	static let headlineFont = NSFont.headline.boldAndItalic()

	static var credits: NSAttributedString = {
		var creditsString = NSMutableAttributedString()

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
			name: "Preferences", url: "https://github.com/sindresorhus/Preferences"
		))

		return creditsString
	}()

	private static func creditedPerson(name: String, role: String, link: String? = nil) -> NSAttributedString {
		let creditedPersonString = NSMutableAttributedString()

		creditedPersonString.append(
			NSAttributedString(string: "\(role)\n", attributes: [.font: headlineFont])
		)

		let nameString: NSAttributedString
		if let link, let url = URL(string: link) {
			nameString = NSAttributedString(string: "    \(name)\n", attributes: [.link: url])
		} else {
			nameString = NSAttributedString(string: "    \(name)\n")
		}
		creditedPersonString.append(nameString)

		return creditedPersonString
	}

	private static func openSourceLibrary(name: String, url: URL) -> NSAttributedString {
		let openSourceLibraryString = NSMutableAttributedString()
		openSourceLibraryString.append(NSAttributedString(string: "  \u{2022} "))
		openSourceLibraryString.append(
			NSAttributedString(string: "\(name)\n", attributes: [.link: url])
		)
		return openSourceLibraryString
	}
}
