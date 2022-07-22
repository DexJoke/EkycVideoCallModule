// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EkycVideoCallModule",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EkycVideoCallModule",
            type: .static,
            targets: ["EkycVideoCallModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cbajapan/fcsdk-ios.git", from: "4.0.1")
    ],
    targets: [
        .target(
            name: "EkycVideoCallModule",
            dependencies: [
                .product(name: "FCSDKiOS", package: "fcsdk-ios")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "EkycVideoCallModuleTests",
            dependencies: ["EkycVideoCallModule"]),
    ]
)
