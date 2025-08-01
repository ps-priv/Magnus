// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Magnus",
    dependencies: [
        // Add your own dependencies here:
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.5.0"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.53.2")
        // You can read more about dependencies here: //https://docs.tuist.io/documentation/tuist/dependencies
    ]
)


