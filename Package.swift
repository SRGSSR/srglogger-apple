// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "srglogger-apple",
    platforms: [
        .iOS(.v9),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "SRGLogger",
            targets: ["SRGLogger"]
        ),
        .library(
            name: "SRGLogger-Swift",
            targets: ["SRGLogger-Swift"]
        )
    ],
    targets: [
        .target(
            name: "SRGLogger"
        ),
        .target(
            name: "SRGLogger-Swift",
            dependencies: ["SRGLogger"]
        ),
        .testTarget(
            name: "SRGLogger-tests",
            dependencies: ["SRGLogger"]
        ),
        .testTarget(
            name: "SRGLogger-Swift-tests",
            dependencies: ["SRGLogger-Swift"]
        )
    ]
)
