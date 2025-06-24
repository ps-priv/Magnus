import ProjectDescription

let project = Project(
    name: "Magnus",
    targets: [
        .target(
            name: "MagnusDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.MagnusDomain",
            infoPlist: .default,
            sources: ["Magnus/Domain/Sources/**"],
            resources: ["Magnus/Domain/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "MagnusCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.MagnusCore",
            infoPlist: .default,
            sources: ["Magnus/Core/Sources/**"],
            resources: ["Magnus/Core/Resources/**"],
            dependencies: [.target(name: "MagnusDomain")]
        ),
        .target(
            name: "MagnusFeatures",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.MagnusFeatures",
            infoPlist: .default,
            sources: ["Magnus/Features/Sources/**"],
            resources: ["Magnus/Features/Resources/**"],
            dependencies: [.target(name: "MagnusDomain"), .target(name: "MagnusCore")]
        ),
        .target(
            name: "NovoNordiskApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.NovoNordiskApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Magnus/UI/NovoNordiskApp/Sources/**"],
            resources: ["Magnus/UI/NovoNordiskApp/Resources/**"],
            dependencies: [.target(name: "MagnusCore"), .target(name: "MagnusDomain"), .target(name: "MagnusFeatures")]
        ),
        .target(
            name: "ChMApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ChMApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Magnus/UI/ChMApp/Sources/**"],
            resources: ["Magnus/UI/ChMApp/Resources/**"],
            dependencies: [.target(name: "MagnusCore"), .target(name: "MagnusDomain"), .target(name: "MagnusFeatures")]
        )
    ]
)
