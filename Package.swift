// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "spatialVideoSplitter",
    platforms: [
        .macOS("14")
    ],
    dependencies: [
        // 👇 Add the ArgumentParser package
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "spatialVideoSplitter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)
