// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Systemator",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "systemator", targets: ["Systemator"]),
        .library(name: "SystemController", targets: ["SystemController"]),
        .library(name: "SystemManager", targets: ["SystemManager"]),
        .library(name: "SystemClient", targets: ["SystemClient"]),
        .library(name: "SystemModel", targets: ["SystemModel"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.1.5"),
        .package(url: "https://github.com/Einstore/ShellKit.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0-alpha.1")
    ],
    targets: [
        .target(
            name: "SystemModel",
            dependencies: []
        ),
        .target(
            name: "SystemController",
            dependencies: [
                "SystemManager",
                "Vapor"
            ]
        ),
        .target(
            name: "SystemClient",
            dependencies: [
                "AsyncHTTPClient",
                "SystemModel"
            ]
        ),
        .target(
            name: "SystemManager",
            dependencies: [
                "CommandKit",
                "SystemModel"
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


