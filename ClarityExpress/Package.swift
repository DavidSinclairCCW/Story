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
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.15.0")
    ],
    targets: [
        .executableTarget(
            name: "ClarityExpress",
            dependencies: [
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ],
            path: "."
        )
    ]
)
