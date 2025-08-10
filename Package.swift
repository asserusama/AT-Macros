// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ATMacros",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "ATMacros",
            targets: ["ATMacros"]
        ),
        .executable(
            name: "ATMacrosClient",
            targets: ["ATMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
    ],
    targets: [
        .macro(
            name: "ATMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            swiftSettings: [
                .enableExperimentalFeature("Macros")
            ]
        ),
        .target(name: "ATMacros", dependencies: ["ATMacrosMacros"]),
        .executableTarget(name: "ATMacrosClient", dependencies: ["ATMacros"]),
    ]
)
