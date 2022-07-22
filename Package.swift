// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EkycVideoCallModule",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EkycVideoCallModule",
            type: .static,
            targets: ["EkycVideoCallModule"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EkycVideoCallModule",
            dependencies: [
                "FCSDKiOS",
                "CBARealTime"
            ],
            path: "Sources",
            resources: [
                .process("Resource/Assets/Image")
            ]
        ),
        .testTarget(
            name: "EkycVideoCallModuleTests",
            dependencies: ["EkycVideoCallModule"]),
        .binaryTarget(name: "FCSDKiOS", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.0.1.xcframework.zip", checksum: "671482c898f37e66afd20e0a110cbb5dbec5f6e358f8ae9cacde2e56fa2a3ee1"),
        .binaryTarget(name: "CBARealTime", url: "https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/CBARealTime-m95-1.0.1.xcframework.zip", checksum: "b40b7d5b08dbe11f18d60779ffb0cd6576e8e45069d22d81b016a23db88a9633")
    ]
)
