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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.6.0-rc1.zip",
            checksum: "90ea644925ddc523cca1d3d0e48d7e49858ce116ce11b37c64e13cddc57c805c"
        ),
    ]
)
