import Foundation

// Swift 6 tightens rules about extending types from imported modules with conformances
// to other imported protocols. Instead, we'll create a helper function to create URLs from strings.
extension URL {
	static func fromString(_ value: String) -> URL {
		guard let url = URL(string: value) else {
			preconditionFailure("Invalid URL string: \(value)")
		}
		return url
	}

	static func fromStaticString(_ value: StaticString) -> URL {
		guard let url = URL(string: "\(value)") else {
			preconditionFailure("Invalid URL string literal: \(value)")
		}
		return url
	}
}
