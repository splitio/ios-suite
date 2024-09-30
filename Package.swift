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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_1.4.0-rc1.zip",
            checksum: "d8dafe35a1ff1ab1adf3995fe20ef93a69831cb3d06a2f59b63d8788ef63b9ab" 
        ),
    ]
)
