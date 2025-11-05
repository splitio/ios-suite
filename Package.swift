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
            targets: ["SplitSuiteWrapper"]
        ),
        .library(name: "Split", targets: ["Split"]),
    ],
    dependencies: [
        .package(url: "https://github.com/splitio/ios-client.git", from: "3.4.2"),
        .package(url: "https://github.com/splitio/ios-rum", from: "0.4.0"),
    ],
    targets: [
        .binaryTarget(
            name: "iOSSplitSuite",
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.3.2.zip",
            checksum: "ce1d87c6e05ef82c41469837ff5936bbc681e2c7e15e41844ebd8ec803dbe2fc"
        ),
        .target(
            name: "SplitSuiteWrapper",
            dependencies: [
                "iOSSplitSuite",
                "Split",
                "ios-rum"
            ],
            path: "Sources/SplitSuiteWrapper"
        )
    ]
)
