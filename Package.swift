// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftUtilityKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(name: "SwiftUtilityKit", targets: ["SwiftUtilityKit"])
    ],
    targets: [
        .target(
            name: "SwiftUtilityKit",
            path: "Sources/SwiftUtilityKit"
        ),
        .testTarget(
            name: "SwiftUtilityKitTests",
            dependencies: ["SwiftUtilityKit"],
            path: "Tests/SwiftUtilityKitTests"
        )
    ]
)
