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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.3.0-rc2.zip",
            checksum: "18e9d6398b6ef55f591e0622482fa48dacbc2359e65c976c78faf1b48f61bf2f"
        ),
    ]
)
