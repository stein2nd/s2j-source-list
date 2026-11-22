// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "s2j-source-list",
    defaultLocalization: "en",
    platforms: [
        .macOS("14.6"),
        .iOS("17.6")
    ],
    products: [
        .library(
            name: "S2JSourceList",
            targets: ["S2JSourceList"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0")
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
            dependencies: [
                "S2JSourceList",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            exclude: ["__Snapshots__"]
        )
    ]
)
