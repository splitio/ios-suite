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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.2.2-rc1.zip",
            checksum: "0b0f6ebca375e9d709c32aa2da0a38ee0855ff1951e9582cb3992f63785ca172"
        ),
    ]
)
