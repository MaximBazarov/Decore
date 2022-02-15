// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Decore",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "Decore",
            targets: ["Decore"]),
        .library(
            name: "DecoreTesting",
            targets: ["DecoreTesting"]),

    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Decore",
            dependencies: [],
            path: "Decore"
        ),
        .testTarget(
            name: "DecoreTests",
            dependencies: ["Decore", "DecoreTesting"],
            path: "Tests"
        ),
        .target(
            name: "DecoreTesting",
            dependencies: ["Decore"],
            path: "DecoreTesting"
        ),

    ]
)
