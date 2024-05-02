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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_1.0.0.zip",
            checksum: "d3f67f9587724a84c17cc5bd395b04f94740a626b07d0daabcfe414793fdab66"
        ),
    ]
)