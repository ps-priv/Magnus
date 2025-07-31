import ProjectDescription

let packages: [Package] = [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
    .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.5.2"),
    .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.53.2"),
    .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0"),
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
            name: "MagnusApplication",
            destinations: .iOS,
            product: .framework,
            bundleId: "pl.mz.magnus.MagnusApplication",
            infoPlist: .default,
            sources: ["Magnus/Application/Sources/**"],
            resources: ["Magnus/Application/Resources/**"],
            dependencies: [.target(name: "MagnusDomain")],
        ),
        .target(
            name: "MagnusFeatures",
            destinations: .iOS,
            product: .framework,
            bundleId: "pl.mz.magnus.MagnusFeatures",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleLocalizations": ["en", "pl"],
                    "CFBundleDevelopmentRegion": "en",
                ]
            ),
            sources: ["Magnus/Features/Sources/**"],
            resources: ["Magnus/Features/Resources/**"],
            dependencies: [
                .target(name: "MagnusDomain"),
                .target(name: "MagnusApplication"),
                .package(product: "Swinject"),
                .package(product: "Alamofire"),
                .package(product: "Sentry"),
            ],
        ),
        .target(
            name: "NovoNordiskApp",
            destinations: .iOS,
            product: .app,
            bundleId: "pl.mz.NovoNordiskApp",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "5",
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
                        "OpenSans-Bold.ttf",
                    ],
                    "CFBundleLocalizations": ["en", "pl"],
                    "CFBundleDevelopmentRegion": "en",
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                ]
            ),
            sources: ["Magnus/UI/NovoNordiskApp/Sources/**"],
            resources: ["Magnus/UI/NovoNordiskApp/Resources/**"],
            dependencies: [
                .target(name: "MagnusApplication"),
                .target(name: "MagnusDomain"),
                .target(name: "MagnusFeatures"),
                .package(product: "Inject"),
                .package(product: "Sentry"),
                .package(product: "Pow"),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "NovoNordiskAppIcon",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "MULTIZONE IT Sp. z o.o.",
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Developer",
                            "PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                            "OTHER_LDFLAGS": ["-Xlinker", "-interposable"],
                            "EMIT_FRONTEND_COMMAND_LINES": "YES",
                        ]),
                    .release(
                        name: .release,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Distribution",
                            "PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                        ]),
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
                    ]
                ]
            ),
            sources: ["Magnus/UI/ChMApp/Sources/**"],
            resources: ["Magnus/UI/ChMApp/Resources/**"],
            dependencies: [
                .target(name: "MagnusApplication"), .target(name: "MagnusDomain"),
                .target(name: "MagnusFeatures"),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconChMApp",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "Apple Development: Pawel Salek (WP36EZATFS)",
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Developer",
                            "PROVISIONING_PROFILE_SPECIFIER": "",
                        ]),
                    .release(
                        name: .release,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Distribution",
                            "PROVISIONING_PROFILE_SPECIFIER": "",
                        ]),
                ]
            )
        ),
    ]
)
