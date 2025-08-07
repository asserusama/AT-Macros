// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AT-Macros",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "AT-Macros",
            targets: ["AT-Macros"]
        ),
        .executable(
            name: "AT-MacrosClient",
            targets: ["AT-MacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
    ],
    targets: [
        .macro(
            name: "AT-MacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            swiftSettings: [
                .enableExperimentalFeature("Macros")
            ]
        ),
        .target(name: "AT-Macros", dependencies: ["AT-MacrosMacros"]),
        .executableTarget(name: "AT-MacrosClient", dependencies: ["AT-Macros"]),
    ]
)
