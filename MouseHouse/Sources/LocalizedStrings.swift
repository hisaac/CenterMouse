import Cocoa

enum LocalizedStrings {
	static let titleFont = NSFont.title3
	static let headlineFont = NSFont.headline.boldAndItalic()

	static var credits: NSAttributedString = {
		var creditsString = NSMutableAttributedString()

		creditsString.append(
			NSAttributedString(string: "Credits\n", attributes: [.font: titleFont])
		)
		creditsString.append(creditedPerson(name: "Eli Mellen", role: "Initial Idea"))
		creditsString.append(creditedPerson(name: "Isaac Halvorson", role: "Programming"))
		creditsString.append(creditedPerson(name: "Eli Mellen", role: "QA Testing"))
		creditsString.append(creditedPerson(
			name: "Dila Yorgancı",
			role: "App Icon",
			link: "https://thenounproject.com/icon/click-home-815687/")
		)

		creditsString.append(
			NSAttributedString(string: "\nOpen Source Libraries\n", attributes: [.font: titleFont])
		)
		creditsString.append(openSourceLibrary(
			name: "Defaults", urlString: "https://github.com/sindresorhus/Defaults"
		))
		creditsString.append(openSourceLibrary(
			name: "KeyboardShortcuts", urlString: "https://github.com/sindresorhus/KeyboardShortcuts"
		))
		creditsString.append(openSourceLibrary(
			name: "Preferences", urlString: "https://github.com/sindresorhus/Preferences"
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

	private static func openSourceLibrary(name: String, urlString: String) -> NSAttributedString {
		guard let url = URL(string: urlString) else {
			preconditionFailure("\(urlString) is not a valid URL")
		}
		let openSourceLibraryString = NSMutableAttributedString()
		openSourceLibraryString.append(NSAttributedString("  \u{2022} "))
		openSourceLibraryString.append(
			NSAttributedString(string: "\(name)\n", attributes: [.link: url])
		)
		return openSourceLibraryString
	}
}
