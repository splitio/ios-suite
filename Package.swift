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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_1.0.0-rc7.zip",
            checksum: "6f34656fa11f7f9d59bc8986ac2544536de34bb5656dcfafd9053617d9fbf7e1"
        ),
    ]
)