// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CloudStorage",
    platforms: [.iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macOS(.v10_15)],
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
