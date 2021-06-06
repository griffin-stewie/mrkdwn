// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mrkdwn",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "mrkdwn", targets: ["mrkdwn"]),
        .library(name: "mrkdwnCore", targets: ["mrkdwnCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.3")),
        .package(url: "https://github.com/mxcl/Path.swift", .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/johnxnguyen/Down", .upToNextMinor(from: "0.11.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "mrkdwn",
            dependencies: [
                "mrkdwnCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
                .product(name: "Down", package: "Down"),
			]),
        .target(
            name: "mrkdwnCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Down", package: "Down"),
            ]),
        .testTarget(
            name: "mrkdwnTests",
            dependencies: ["mrkdwn"]),
    ]
)
