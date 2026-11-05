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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.7.0.zip",
            checksum: "d6b7ba8dc6f6ec6cb38964b40ecd0206d642eca31ffec23b7e6aa76f16b8eb63"
        ),
    ]
)
