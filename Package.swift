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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.0.0-rc1.zip",
            checksum: "3534e6cda936d3934b6a8f880cde5befdf601e1a8f6fc3730edc095d5b982ad2"
        ),
    ]
)
