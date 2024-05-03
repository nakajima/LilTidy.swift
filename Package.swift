// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// Get the values we need to populate the LIBTIDY_VERSION and RELEASE_DATE macros later.
func tidyVersion() -> [String] {
	let PWD = (#filePath as NSString).deletingLastPathComponent
	let VERSION_FILE = NSString.path(withComponents: [PWD, "Sources", "CLibTidy", "version.txt"])
	if let CONTENTS = try? String(contentsOfFile: VERSION_FILE).components(separatedBy: "\n") {
		return CONTENTS
	}

	return ["5.0.0", "2021/01/01"]
}

let package = Package(
	name: "LilTidy",
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "LilTidy",
			targets: ["LilTidy"]
		),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "LilTidy",
			dependencies: ["CLibTidy"]
		),
		.target(
			name: "CLibTidy",
			dependencies: [],
			path: "Sources/CLibTidy",
			exclude: [
				"CMakeLists.txt",
				"tidy.pc.cmake.in",
				"README.md",
				"version.txt",
				"build",
				"console",
				"experimental",
				"localize",
				"man",
				"README",
				"regression_testing",
				"include/buffio.h",
				"include/platform.h",
			],
			sources: ["src"],
			publicHeadersPath: "include",
			cSettings: [
				.define("LIBTIDY_VERSION", to: "\"\(tidyVersion()[0])\"", nil),
				.define("RELEASE_DATE", to: "\"\(tidyVersion()[1])\"", nil),
			]
		),

		.testTarget(
			name: "LilTidyTests",
			dependencies: ["LilTidy"]
		),
	],
	cLanguageStandard: CLanguageStandard.gnu89
)
