// These extensions snagged from https://gist.github.com/shaps80/2d21b2ab92ea4fddd7b545d77a47024b

import SwiftUI

#if os(macOS)
public typealias Font = NSFont
public typealias FontDescriptor = NSFontDescriptor
#else
public typealias Font = UIFont
public typealias FontDescriptor = UIFontDescriptor
#endif

public extension Font {
	static var caption2: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize - 6)
		#else
		.preferredFont(forTextStyle: .caption2)
		#endif
	}

	static var caption: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize - 5)
		#else
		.preferredFont(forTextStyle: .caption1)
		#endif
	}

	static var footnote: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize - 4)
		#else
		.preferredFont(forTextStyle: .footnote)
		#endif
	}

	static var callout: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize - 1)
		#else
		.preferredFont(forTextStyle: .callout)
		#endif
	}

	static var body: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize)
		#else
		.preferredFont(forTextStyle: .body)
		#endif
	}

	static var subheadline: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize - 2)
		#else
		.preferredFont(forTextStyle: .subheadline)
		#endif
	}

	static var headline: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize, weight: .semibold)
		#else
		.preferredFont(forTextStyle: .headline)
		#endif
	}

	static var title3: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize + 3)
		#else
		.preferredFont(forTextStyle: .title3)
		#endif
	}

	static var title2: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize + 5)
		#else
		.preferredFont(forTextStyle: .title2)
		#endif
	}

	static var title: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize + 11)
		#else
		.preferredFont(forTextStyle: .title1)
		#endif
	}

	static var largeTitle: Font {
		#if os(macOS)
		.systemFont(ofSize: Font.systemFontSize + 17)
		#else
		.preferredFont(forTextStyle: .largeTitle)
		#endif
	}

	static func monospaced() -> Font {
		#if os(macOS)
		.monospacedSystemFont(ofSize: Font.systemFontSize, weight: .regular)
		#else
		.system(.body, design: .monospaced)
		#endif
	}
}

public extension Font {

	enum Leading {
		case loose
		case tight
	}

	private func addingAttributes(_ attributes: [FontDescriptor.AttributeName: Any]) -> Font {
		let font = Font(descriptor: fontDescriptor.addingAttributes(attributes), size: pointSize)
		#if os(macOS)
		return font!
		#else
		return font
		#endif
	}

	static func system(size: CGFloat, weight: Font.Weight, design: FontDescriptor.SystemDesign = .default) -> Font {
		let descriptor = Font.systemFont(ofSize: size).fontDescriptor
			.addingAttributes([
				FontDescriptor.AttributeName.traits: [
					FontDescriptor.TraitKey.weight: weight.rawValue
				]
			]).withDesign(design)!

		let font = Font(descriptor: descriptor, size: size)
		#if os(macOS)
		return font!
		#else
		return font
		#endif
	}

	#if os(iOS)
	static func system(_ style: Font.TextStyle, design: FontDescriptor.SystemDesign = .default) -> Font {
		let descriptor = FontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(design)!
		return Font(descriptor: descriptor, size: 0)
	}
	#endif

	func weight(_ weight: Font.Weight) -> Font {
		addingAttributes([
			FontDescriptor.AttributeName.traits: [
				FontDescriptor.TraitKey.weight: weight.rawValue
			]
		])
	}

	func italic() -> Font {
		#if os(macOS)
		let descriptor = fontDescriptor.withSymbolicTraits(.italic)
		return Font(descriptor: descriptor, size: 0)!
		#else
		let descriptor = fontDescriptor.withSymbolicTraits(.traitItalic)!
		return Font(descriptor: descriptor, size: 0)
		#endif
	}

	func bold() -> Font {
		#if os(macOS)
		let descriptor = fontDescriptor.withSymbolicTraits(.bold)
		return Font(descriptor: descriptor, size: 0)!
		#else
		let descriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
		return Font(descriptor: descriptor, size: 0)
		#endif
	}

	func leading(_ leading: Leading) -> Font {
		#if os(macOS)
		let descriptor = fontDescriptor.withSymbolicTraits(leading == .loose ? .looseLeading : .tightLeading)
		return Font(descriptor: descriptor, size: 0)!
		#else
		let descriptor = fontDescriptor.withSymbolicTraits(leading == .loose ? .traitLooseLeading : .traitTightLeading)!
		return Font(descriptor: descriptor, size: 0)
		#endif
	}

}
