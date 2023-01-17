// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Elephant",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "Elephant", targets: ["Elephant"]),
    ],
    targets: [
        .target(name: "Elephant"),
        .testTarget(name: "ElephantTests", dependencies: ["Elephant"]),
    ]
)
