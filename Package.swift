// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Decore",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v12),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "Decore",
            targets: ["Decore"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Decore",
            dependencies: []),
        .testTarget(
            name: "DecoreTests",
            dependencies: ["Decore"]),
    ]
)
