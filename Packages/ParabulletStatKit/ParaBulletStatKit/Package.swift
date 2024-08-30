// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ParaBulletStatKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ParaBulletStatKit",
            targets: ["ParaBulletStatKit"]),
    ],
    dependencies: [
        // Here you add the dependencies your package depends on.
//        .package(url: "https://github.com/JimmyMAndersson/StatKit.git", .upToNextMajor(from: "0.6.1"))
        .package(url: "https://github.com/CoreOffice/CoreXLSX", from: "0.14.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ParaBulletStatKit",
            dependencies: ["CoreXLSX"]),
        .testTarget(
            name: "ParaBulletStatKitTests",
            dependencies: ["ParaBulletStatKit"]),
    ]
)
