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
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
		<html>
		<body>
		func sup() {
			return
		}
		</body>
		"""

		let cleaned = try LilTidy.clean(html, options: [
			"indent": "no",
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
