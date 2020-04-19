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
