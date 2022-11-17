import Cocoa

enum LocalizedStrings {
	static var credits: NSAttributedString = {
		guard
			let creditsMarkdownFileURL = Bundle.main.url(forResource: "Credits", withExtension: "md"),
			let creditsMarkdownString = try? NSAttributedString(
				contentsOf: creditsMarkdownFileURL,
				options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
			)
		else {
			return NSAttributedString()
		}
		return creditsMarkdownString
	}()

	static var creds: NSAttributedString = {
//		let titleFont = NSFont.preferredFont(forTextStyle: .title2)
//		let headlineFont = NSFont.preferredFont(forTextStyle: .headline)
//		let italicHeadlineFont = NSFont(descriptor: headlineFont.fontDescriptor.withSymbolicTraits(.italic), size: headlineFont.pointSize)
//
//		var creditsString = NSMutableAttributedString()
//		creditsString.append(NSAttributedString(string: "Credits\n", attributes: [.font: titleFont]))
//
//		creditsString.append(NSAttributedString(string: "Programming\n", attributes: [.font: italicHeadlineFont]))
//		creditsString.append(NSAttributedString(string: "\tIsaac Halvorson\n"))
//
//		creditsString.append(NSAttributedString(string: "App Icon\n", attributes: [.font: italicHeadlineFont]))
//		creditsString.append(NSAttributedString(string: "\tMatt Pennig\n"))
//
//		creditsString.append(NSAttributedString(string: "QA Testing\n", attributes: [.font: italicHeadlineFont]))
//		creditsString.append(NSAttributedString(string: "\tEli Mellen\n"))

		var creditsString = NSMutableAttributedString()

		return creditsString
	}()
}
