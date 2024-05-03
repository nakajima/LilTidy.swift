// The Swift Programming Language
// https://docs.swift.org/swift-book

import CLibTidy

extension CLibTidy.Bool: ExpressibleByBooleanLiteral {
	public typealias BooleanLiteralType = Swift.Bool

	public init(booleanLiteral value: BooleanLiteralType) {
		self.init(rawValue: value ? 1 : 0)
	}
}

public enum LilTidy {
	public enum Error: Swift.Error {
		case couldNotCreateDocument, parseError(Int, String)
	}

	public static func clean(_ html: String, options: [String: String]) throws -> String {
		guard let document = tidyCreate() else {
			throw Error.couldNotCreateDocument
		}

		defer {
			tidyRelease(document)
		}

		tidyOptSetBool(document, TidyForceOutput, true)

		for (name, value) in options {
			tidyOptParseValue(document, name, value)
		}

		var errorBuffer = TidyBuffer()
		tidyBufInit(&errorBuffer)
		tidySetErrorBuffer(document, &errorBuffer)
		defer {
			tidyBufFree(&errorBuffer)
		}

		var outputBuffer = TidyBuffer()
		tidyBufInit(&outputBuffer)
		defer {
			tidyBufFree(&outputBuffer)
		}

		tidySetInCharEncoding(document, "utf-8")
		tidySetOutCharEncoding(document, "utf-8")

		var returnCode = tidyParseString(document, html)
		guard returnCode >= 0 else {
			throw Error.parseError(Int(returnCode), String(cString: errorBuffer.bp))
		}

		returnCode = tidyCleanAndRepair(document)
		guard returnCode >= 0 else {
			throw Error.parseError(Int(returnCode), String(cString: errorBuffer.bp))
		}

		tidySaveBuffer(document, &outputBuffer)

		document

		return String(cString: outputBuffer.bp)
	}
}
