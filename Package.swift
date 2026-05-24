// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Elephant",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "Elephant", targets: ["Elephant"]),
    ],
    targets: [
        .target(name: "Elephant"),
        .testTarget(name: "ElephantTests", dependencies: ["Elephant"]),
    ],
    swiftLanguageModes: [.v5]
)
