// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(name: "DecoreStorage",
                 url: "git@github.com:MaximBazarov/DecoreStorage.git",
                 .exactItem("0.1.0"))

    ],
    targets: [
        .target(
            name: "Decore",
            dependencies: ["DecoreStorage"]),
        .testTarget(
            name: "DecoreTests",
            dependencies: ["Decore", "DecoreStorage"]),
    ]
)
