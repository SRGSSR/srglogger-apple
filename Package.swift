// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SRGLogger",
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
            name: "SRGLoggerSwift",
            targets: ["SRGLoggerSwift"]
        )
    ],
    targets: [
        .target(
            name: "SRGLogger"
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
