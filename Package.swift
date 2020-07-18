// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "srglogger-apple",
    products: [
        .library(
            name: "SRGLogger",
            targets: ["SRGLogger"]
        )
    ],
    targets: [
        .target(
            name: "SRGLogger"
        ),
        .testTarget(
            name: "SRGLogger-tests",
            dependencies: ["SRGLogger"])
    ]
)
