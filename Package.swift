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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_1.2.1b2.zip",
            checksum: "a6b8c572a7b59c6156cbf774a0972a9657be26eae0c53ca206c7023fa95c70fe"
        ),
    ]
)
