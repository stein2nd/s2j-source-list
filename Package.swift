// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "s2j-source-list",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "S2JSourceList",
            targets: ["S2JSourceList"]
        ),
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "S2JSourceList",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "S2JSourceListTests",
            dependencies: ["S2JSourceList"]
        ),
    ]
)
