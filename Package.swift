// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BMMapView",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "BMMapView",
            targets: ["BMMapView"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BMMapView",
            dependencies: []),
        .testTarget(
            name: "BMMapViewTests",
            dependencies: ["BMMapView"]),
    ]
)
