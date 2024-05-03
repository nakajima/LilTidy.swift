import XCTest
import LilTidy

final class LilTidyTests: XCTestCase {
    func testExample() throws {
			let cleaned = try LilTidy.clean("<dIV>sup</Div>", options: [
				"output-html": "yes",
				"doctype": "omit",
				"show-body-only": "yes",
				"vertical-space": "auto"
			])
			XCTAssertEqual("<div>sup</div>\n", cleaned)
    }

	func testCode() throws {
		let html = """
		func sup() {
			return
		}
		"""

		let cleaned = try LilTidy.clean(html, options: [
			"output-html": "yes",
			"doctype": "omit",
			"show-body-only": "yes",
			"vertical-space": "auto"
		])

		XCTAssertEqual("""
		func sup() {
			return
		}
		""", cleaned)
	}
}
