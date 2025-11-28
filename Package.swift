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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.4.0-rc1.zip",
            checksum: "3a1ce1ffad883b8f2ab02c3ac410cf86ebadd52f0c6de2e5522455c6d92af6e5"
        ),
    ]
)
