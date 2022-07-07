// swift-tools-version:5.3

import PackageDescription

struct ProjectSettings {
    static let marketingVersion: String = "3.0.3"
}

let package = Package(
    name: "SRGLogger",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "SRGLogger",
            targets: ["SRGLogger"]
        ),
        .library(
            name: "SRGLoggerSwift",
            targets: ["SRGLoggerSwift"]
        )
    ],
    targets: [
        .target(
            name: "SRGLogger",
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\""),
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .target(
            name: "SRGLoggerSwift",
            dependencies: ["SRGLogger"]
        ),
        .testTarget(
            name: "SRGLoggerTests",
            dependencies: ["SRGLogger"]
        ),
        .testTarget(
            name: "SRGLoggerSwiftTests",
            dependencies: ["SRGLoggerSwift"]
        )
    ]
)
