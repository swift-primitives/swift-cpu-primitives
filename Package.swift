// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-cpu-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "CPU Primitives",
            targets: ["CPU Primitives"]
        )
    ],
    dependencies: [
        .package(path: "../swift-binary-primitives"),
        .package(path: "../swift-bit-primitives"),
        .package(path: "../swift-dimension-primitives"),
    ],
    targets: [
        .target(
            name: "CCPUShim",
            dependencies: []
        ),
        .target(
            name: "CPU Primitives",
            dependencies: [
                .target(name: "CCPUShim"),
                .product(name: "Binary Primitives", package: "swift-binary-primitives"),
                .product(name: "Bit Primitives", package: "swift-bit-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
            ]
        ),
        .testTarget(
            name: "CPU Primitives Tests",
            dependencies: [
                "CPU Primitives",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
