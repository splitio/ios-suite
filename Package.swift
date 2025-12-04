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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.4.0-rc2.zip",
            checksum: "ccad9e3bef657ee13e2bebbc5f509aa4d06fcb23e53b26a7f6fea4847f93ffa4"
        ),
    ]
)
