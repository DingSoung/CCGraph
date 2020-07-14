// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Graph",
    platforms: [
        .iOS(.v8),
//        .macOS(.v10_10),
//        .tvOS(.v9),
//        .watchOS(.v2)
    ],
    products: [
        .library(name: "Graph", targets: ["Graph"])
    ],
    dependencies: [
        .package(url: "https://github.com/DingSoung/Extension", .branch("master")),
    ],
    targets: [
        .target(name: "Graph", dependencies: ["Extension"] ,path: "Sources")
    ],
    swiftLanguageVersions: [
        .version("5")
    ]
)
