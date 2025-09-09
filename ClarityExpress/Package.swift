// swift-tools-version: 5.9
import PackageDescription

// Conditionally include Stripe only when UIKit is available so the package can
// still be resolved on platforms that lack Apple's UI frameworks (e.g. Linux).

var stripeDependency: [Package.Dependency] = []
var stripeProducts: [Target.Dependency] = []
#if canImport(UIKit)
stripeDependency.append(
    .package(url: "https://github.com/stripe/stripe-ios", from: "24.8.0")
)
stripeProducts.append(
    .product(name: "StripePaymentSheet", package: "stripe-ios")
)
stripeProducts.append(
    .product(name: "Stripe3DS2", package: "stripe-ios")
)
#endif

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
    ] + stripeDependency,
    targets: [
        .executableTarget(
            name: "ClarityExpress",
            dependencies: [
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ] + stripeProducts,
            path: ".",
            exclude: ["README.md"]
        )
    ]
)
