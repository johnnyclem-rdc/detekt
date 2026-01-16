// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDetekt",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "swiftdetekt", targets: ["SwiftDetektCLI"]),
        .library(name: "SwiftDetektCore", targets: ["SwiftDetektCore"]),
        .library(name: "SwiftDetektAPI", targets: ["SwiftDetektAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.0"),
    ],
    targets: [
        // Core API interfaces (Rule, Finding, Config)
        .target(
            name: "SwiftDetektAPI",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        
        // Core Logic (File processing, Configuration loading)
        .target(
            name: "SwiftDetektCore",
            dependencies: [
                "SwiftDetektAPI",
                "SwiftDetektRules",
                "SwiftDetektReport",
                .product(name: "Yams", package: "Yams"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        
        // Rules Implementation
        .target(
            name: "SwiftDetektRules",
            dependencies: [
                "SwiftDetektAPI",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        
        // Reporting Logic
        .target(
            name: "SwiftDetektReport",
            dependencies: [
                "SwiftDetektAPI"
            ]
        ),

        // CLI Entry Point
        .executableTarget(
            name: "SwiftDetektCLI",
            dependencies: [
                "SwiftDetektCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        
        // Tests
        .testTarget(
            name: "SwiftDetektTests",
            dependencies: ["SwiftDetektCore", "SwiftDetektRules"]
        ),
    ]
)
