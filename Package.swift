// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Decore",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v15),
        .watchOS(.v7),
        .tvOS(.v14),
    ],
    products: [
        .library(name: "Decore", targets: ["Decore"]),
        .library(name: "DependencyAutoGraph", targets: ["DependencyAutoGraph"]),
        .library(name: "DependencyContainer", targets: ["DependencyContainer"]),
        .library(name: "EffectBus", targets: ["EffectBus"]),
        .library(name: "ObservableStorage", targets: ["ObservableStorage"]),
    ],
    dependencies: [
    ],
    targets: [
        // Decore -
        .target(
            name: "Decore",
            dependencies: ["DependencyAutoGraph",],
            path: "Decore/Sources"
        ),
        .testTarget(
            name: "Decore-Tests",
            dependencies: ["Decore"],
            path: "Decore/Tests"
        ),
        // DependencyAutoGraph -
        .target(
            name: "DependencyAutoGraph",
            dependencies: [],
            path: "DependencyAutoGraph/Sources"
        ),
        .testTarget(
            name: "DependencyAutoGraph-Tests",
            dependencies: ["DependencyAutoGraph"],
            path: "DependencyAutoGraph/Tests"
        ),
        // DependencyContainer -
        .target(
            name: "DependencyContainer",
            dependencies: [],
            path: "DependencyContainer/Sources"
        ),
        .testTarget(
            name: "DependencyContainer-Tests",
            dependencies: ["DependencyContainer"],
            path: "DependencyContainer/Tests"
        ),
        // EffectBus -
        .target(
            name: "EffectBus",
            dependencies: [],
            path: "EffectBus/Sources"
        ),
        .testTarget(
            name: "EffectBus-Tests",
            dependencies: ["EffectBus"],
            path: "EffectBus/Tests"
        ),
        // ObservableStorage -
        .target(
            name: "ObservableStorage",
            dependencies: [],
            path: "ObservableStorage/Sources"
        ),
        .testTarget(
            name: "ObservableStorage-Tests",
            dependencies: ["ObservableStorage"],
            path: "ObservableStorage/Tests"
        ),
    ]
)
