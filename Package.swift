// swift-tools-version:5.3
import PackageDescription


let package = Package(
    name: "SplitSuite",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SplitSuite",
            targets: ["iOSSplitSuite"])
    ],
    targets: [
        .binaryTarget(
            name: "iOSSplitSuite",
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.6.2-rc9.zip",
            checksum: "562d87874606c08d6c3c3fd3ce4e3ed61388e66a5c5782194532682851f24c93"
        ),
    ]
)
