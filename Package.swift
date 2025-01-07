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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.0.1-rc1.zip",
            checksum: "e2f97f9a8563bb75cf6271471a964a1c43d2711087dff2c6fe1bfb50a1e94094"
        ),
    ]
)
