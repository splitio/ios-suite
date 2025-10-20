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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.3.2-rc1.zip",
            checksum: "84abbdaf9dc9a54eac51762e45f50a0d3ea2b953f2cc7d6459cd7adc0aa868ef"
        ),
    ]
)
