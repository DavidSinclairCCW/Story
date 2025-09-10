// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClarityExpress",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "ClarityExpress", targets: ["ClarityExpress"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ClarityExpress",
            path: ".",
            exclude: ["README.md"]
        )
    ]
)
