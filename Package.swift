// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import PackageDescription

// MARK: - Package

let package = Package(
    name: "REPLACE_ME",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "REPLACE_ME",
            targets: ["REPLACE_ME"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "REPLACE_ME"),
        .testTarget(
            name: "REPLACE_METests",
            dependencies: ["REPLACE_ME"]
        ),
    ]
)

// MARK: - Common target settings

// Sets values that are common for every target.
for target in package.targets {

    // MARK: Plugins

    let plugins = target.plugins ?? []
    target.plugins = plugins + [
        .plugin(name: "LintBuildPlugin", package: "swift-format-plugin")
    ]

    // MARK: Swift compliler settings

    let swiftSettings = target.swiftSettings ?? []
    target.swiftSettings = swiftSettings + [
        // Optional: Set defaultIsolation to `MainActor` if desired.
        // Probably only useful in a UI heavy package.
        // .defaultIsolation(MainActor.self),

        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]
}
