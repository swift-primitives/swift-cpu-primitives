// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-cpu-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "CPU Primitives",
            targets: ["CPU Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-binary-primitives"),
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
            ]
        ),
        .testTarget(
            name: "CPU Primitives Tests",
            dependencies: [
                "CPU Primitives",
            ],
            path: "Tests/CPU Primitives Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
