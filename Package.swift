// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Downpour",
    products: [.library(name: "Downpour", targets: ["Downpour"])],
    targets: [
        .target(name: "Downpour", path: "Sources"),
        .testTarget(
            name: "DownpourTests",
            dependencies: ["Downpour"],
            path: "Tests/DownpourTests"
        ),
    ]
)
