// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextRecognizer",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "recognize-text", targets: ["TextRecognizer"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .executableTarget(name: "TextRecognizer", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
    ]
)