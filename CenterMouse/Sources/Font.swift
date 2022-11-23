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
		.preferredFont(forTextStyle: .caption2)
	}

	static var caption1: Font {
		.preferredFont(forTextStyle: .caption1)
	}

	static var footnote: Font {
		.preferredFont(forTextStyle: .footnote)
	}

	static var callout: Font {
		.preferredFont(forTextStyle: .callout)
	}

	static var body: Font {
		.preferredFont(forTextStyle: .body)
	}

	static var subheadline: Font {
		.preferredFont(forTextStyle: .subheadline)
	}

	static var headline: Font {
		.preferredFont(forTextStyle: .headline)
	}

	static var title3: Font {
		.preferredFont(forTextStyle: .title3)
	}

	static var title2: Font {
		.preferredFont(forTextStyle: .title2)
	}

	static var title1: Font {
		.preferredFont(forTextStyle: .title1)
	}

	static var largeTitle: Font {
		.preferredFont(forTextStyle: .largeTitle)
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

	// 2022-11-17 - Added by Isaac Halvorson
	func boldAndItalic() -> Font {
		let descriptor = fontDescriptor.withSymbolicTraits([.bold, .italic])
		return Font(descriptor: descriptor, size: 0)!
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
