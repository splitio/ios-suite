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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_1.0.0-rc6.zip",
            checksum: "884d9b7a22b05d8f2fe32e1e4e9b3df7e25fd08febd0644ac51d1dc308aa8f48"
        ),
    ]
)