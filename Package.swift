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
            url: "https://cdn.split.io/ios-suite/iOSSplitSuite_2.4.1.zip",
            checksum: "f06d9d654b8c8dc67364bef50938cf5eef93ad2a4e9e1471de3f15cfeca53a47"
        ),
    ]
)
