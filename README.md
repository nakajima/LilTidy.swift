# LilTidy

A tiny wrapper around tidy-html5 (the https://github.com/GerHobbelt/tidy-html5 fork which includes some fixes that aren't in the main repo).

## Usage

```swift
let cleaned = try LilTidy.clean("<dIV>sup</Div>", options: [
  "output-html": "yes",
  "doctype": "omit",
  "show-body-only": "yes",
  "vertical-space": "auto"
])

XCTAssertEqual("<div>sup</div>\n", cleaned) // Passes! Probably!
```
