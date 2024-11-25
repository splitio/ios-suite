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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.0.0.zip",
            checksum: "98e54b69ee4e33ab7d2215a8c85f6f93907b8ad5ce5246d8ab0f4153b278ff55"
        ),
    ]
)
