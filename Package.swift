// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Systemator",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "Systemator", targets: ["Systemator"]),
        .library(name: "SystemController", targets: ["SystemController"]),
        .library(name: "SystemManager", targets: ["SystemManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.1.5"),
        .package(url: "https://github.com/Einstore/ShellKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SystemController",
            dependencies: [
                "SystemManager",
                "Vapor"
            ]
        ),
        .target(
            name: "SystemManager",
            dependencies: [
                "ShellKit"
            ]
        ),
        .testTarget(
            name: "SystemManagerTests",
            dependencies: ["SystemManager"]
        ),
        .target(
            name: "Systemator",
            dependencies: [
                "Vapor",
                "SystemController"
            ]
        )
    ]
)


