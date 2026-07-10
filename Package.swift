// swift-tools-version: 6.3.3

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
        ),
        .library(
            name: "CPU Primitives Test Support",
            targets: ["CPU Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-binary-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-binary-serializer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-bit-primitives.git", branch: "main"),
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
                .product(name: "Binary Serializable Primitives", package: "swift-binary-serializer-primitives"),
            ]
        ),
        .target(
            name: "CPU Primitives Test Support",
            dependencies: [
                "CPU Primitives",
                .product(name: "Bit Primitives Test Support", package: "swift-bit-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "CPU Primitives Tests",
            dependencies: [
                "CPU Primitives",
                "CPU Primitives Test Support",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
