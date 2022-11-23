import Foundation

extension URL: ExpressibleByStringLiteral {
	// By using 'StaticString' we disable string interpolation, for safety
	// Source: https://www.swiftbysundell.com/tips/defining-static-urls-using-string-literals/
	public init(stringLiteral value: StaticString) {
		guard let url = URL(string: "\(value)") else {
			preconditionFailure("Invalid URL string literal: \(value)")
		}
		self = url
	}
}
