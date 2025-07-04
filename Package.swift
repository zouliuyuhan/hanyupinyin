// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hanyupinyin",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "hanyupinyin",
            targets: ["hanyupinyin"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "hanyupinyin",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "hanyupinyinTests",
            dependencies: ["hanyupinyin"]
        ),
    ]
) 