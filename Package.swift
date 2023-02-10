// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextRecognizerCLI",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "recognize-text", targets: ["TextRecognizerCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/pepebecker/text-recognizer-swift", from: "0.1.0")
    ],
    targets: [
        .executableTarget(name: "TextRecognizerCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "TextRecognizer", package: "text-recognizer-swift")
        ]),
    ]
)