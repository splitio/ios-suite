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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.4.2-rc1.zip",
            checksum: "c8063ff3037ff407f7a46b4b70f9aa5e75f6cc8fcb7b47e7d34f2d65bff3aa16"
        ),
    ]
)
