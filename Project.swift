import ProjectDescription

let packages: [Package] = [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1")
]

let project = Project(
    name: "Magnus",
    packages: packages,
    targets: [
        .target(
            name: "MagnusDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "pl.mz.magnus.MagnusDomain",
            infoPlist: .default,
            sources: ["Magnus/Domain/Sources/**"],
            resources: ["Magnus/Domain/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "MagnusCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "pl.mz.magnus.MagnusCore",
            infoPlist: .default,
            sources: ["Magnus/Core/Sources/**"],
            resources: ["Magnus/Core/Resources/**"],
            dependencies: [.target(name: "MagnusDomain")],
        ),
        .target(
            name: "MagnusFeatures",
            destinations: .iOS,
            product: .framework,
            bundleId: "pl.mz.magnus.MagnusFeatures",
            infoPlist: .default,
            sources: ["Magnus/Features/Sources/**"],
            resources: ["Magnus/Features/Resources/**"],
            dependencies: [
                .target(name: "MagnusDomain"), 
                .target(name: "MagnusCore"),
                .package(product: "Swinject")],
        ),
        .target(
            name: "NovoNordiskApp",
            destinations: .iOS,
            product: .app,
            bundleId: "pl.mz.magnus.NovoNordiskApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIAppFonts": [
                        "FontAwesome6Brands-Regular-400.otf",
                        "FontAwesome6Pro-Light-300.otf", 
                        "FontAwesome6Pro-Regular-400.otf",
                        "FontAwesome6Pro-Solid-900.otf",
                        "FontAwesome6Pro-Thin-100.otf",
                        "OpenSans-Light.ttf",
                        "OpenSans-Regular.ttf",
                        "OpenSans-Bold.ttf"
                    ],
                    "CFBundleLocalizations": ["en", "pl"],
                    "CFBundleDevelopmentRegion": "en"
                ]
            ),
            sources: ["Magnus/UI/NovoNordiskApp/Sources/**"],
            resources: ["Magnus/UI/NovoNordiskApp/Resources/**"],
            dependencies: [
                .target(name: "MagnusCore"), 
                .target(name: "MagnusDomain"), 
                .target(name: "MagnusFeatures"),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "NovoNordiskAppIcon",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "Apple Development: Pawel Salek (WP36EZATFS)",
                    "CODE_SIGN_IDENTITY": "iPhone Developer"
                ],
                configurations: [
                    .debug(name: .debug, settings: [
                        "CODE_SIGN_IDENTITY": "iPhone Developer",
                        "PROVISIONING_PROFILE_SPECIFIER": "" // Automatyczne
                    ]),
                    .release(name: .release, settings: [
                        "CODE_SIGN_IDENTITY": "iPhone Distribution",
                        "PROVISIONING_PROFILE_SPECIFIER": "" // Automatyczne
                    ])
                ]
            )
        ),
        .target(
            name: "ChMApp",
            destinations: .iOS,
            product: .app,
            bundleId: "pl.mz.magnust.ChMApp",
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
            dependencies: [.target(name: "MagnusCore"), .target(name: "MagnusDomain"), .target(name: "MagnusFeatures")],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconChMApp",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "Apple Development: Pawel Salek (WP36EZATFS)",
                    "CODE_SIGN_IDENTITY": "iPhone Developer"
                ],
                configurations: [
                    .debug(name: .debug, settings: [
                        "CODE_SIGN_IDENTITY": "iPhone Developer",
                        "PROVISIONING_PROFILE_SPECIFIER": ""
                    ]),
                    .release(name: .release, settings: [
                        "CODE_SIGN_IDENTITY": "iPhone Distribution",
                        "PROVISIONING_PROFILE_SPECIFIER": ""
                    ])
                ]
            )
        )
    ]
)
