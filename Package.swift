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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.5.0.zip",
            checksum: "d86c3a5bfaadbcc987d37e2c7e65292900f008b4e3d6b0d4b04bdf7a0ce8eddd"
        ),
    ]
)
