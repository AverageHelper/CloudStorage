// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CloudStorage",
    products: [
        .library(
            name: "CloudStorage",
            targets: ["CloudStorage"]
        ),
    ],
    dependencies: [
        // .package(url: /* url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CloudStorage",
            dependencies: []
        ),
        .testTarget(
            name: "CloudStorageTests",
            dependencies: [
                "CloudStorage",
            ]
        ),
    ]
)
