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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.2.1-rc6.zip",
            checksum: "5bcafbb708da29d564f67e3e709cc369dbcefe64f7a652ad224c632b23fcfc1f"
        ),
    ]
)
