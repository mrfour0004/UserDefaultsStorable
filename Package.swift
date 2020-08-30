// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDefaultsStorable",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "UserDefaultsStorable", targets: ["UserDefaultsStorable"]),
    ],

    targets: [
        .target(name: "UserDefaultsStorable", path: "Sources"),
        .testTarget(name: "UserDefaultsStorableTests", dependencies: ["UserDefaultsStorable"]),
    ]
)
