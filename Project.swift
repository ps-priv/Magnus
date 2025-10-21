import ProjectDescription

let packages: [Package] = [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
    .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.53.2"),
    .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.5"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.5.0"),
    .package(url: "https://github.com/exyte/PopupView.git", from: "4.1.11"),
    .package(url: "https://github.com/exyte/FloatingButton.git", from: "1.4.0"),
    .package(url: "https://github.com/OneSignal/OneSignal-iOS-SDK.git", from: "5.2.14")

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
            dependencies: [],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5"
                ]
            )
        ),
        .target(
            name: "OneSignalNotificationServiceExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "pl.mz.NovoNordiskApp.OneSignalNotificationServiceExtension",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "NovoNordiskApp",
                    "CFBundleVersion": "21",
                    "NSExtension": [
                        "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                        "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
                    ],
                ]
            ),
            sources: ["Magnus/OneSignalNotificationServiceExtension/Sources/**"],
            resources: [
                "Magnus/OneSignalNotificationServiceExtension/Resources/PrivacyInfo.xcprivacy"
            ],
            dependencies: [
                .package(product: "OneSignalExtension")
            ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5",
                    "CURRENT_PROJECT_VERSION": "12"
                ]
            )
        ),
        .target(
            name: "ChMOneSignalNotificationServiceExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "pl.serwik.chm.conference.OneSignalNotificationServiceExtension",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "ChMApp",
                    "CFBundleVersion": "17",
                    "NSExtension": [
                        "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                        "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
                    ],
                ]
            ),
            sources: ["Magnus/OneSignalNotificationServiceExtension/Sources/**"],
            resources: [
                "Magnus/OneSignalNotificationServiceExtension/Resources/PrivacyInfo.xcprivacy"
            ],
            dependencies: [
                .package(product: "OneSignalExtension")
            ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5",
                    "CURRENT_PROJECT_VERSION": "11"
                ]
            )
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
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5"
                ]
            )
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
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5"
                ]
            )
        ),
        .target(
            name: "NovoNordiskApp",
            destinations: .iOS,
            product: .app,
            bundleId: "pl.mz.NovoNordiskApp",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "21",
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
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    // Required by iOS when saving to the user's photo library
                    "NSPhotoLibraryAddUsageDescription": "Aplikacja potrzebuje dostępu do biblioteki zdjęć, aby zapisywać zdjęcia z fotobudki.",
                    "NSPhotoLibraryUsageDescription": "Aplikacja potrzebuje dostępu do biblioteki zdjęć, aby zapisywać zdjęcia z fotobudki.",
                    "NSCameraUsageDescription": "Aplikacja potrzebuje dostępu do kamery, aby zapisywać zdjęcia z fotobudki.",
                    "NSMicrophoneUsageDescription": "Aplikacja potrzebuje dostępu do mikrofonu, aby zapisywać zdjęcia z fotobudki.",
                ]
            ),
            sources: ["Magnus/UI/NovoNordiskApp/Sources/**"],
            resources: ["Magnus/UI/NovoNordiskApp/Resources/**"],
            dependencies: [
                .target(name: "MagnusApplication"),
                .target(name: "MagnusDomain"),
                .target(name: "MagnusFeatures"),
                .package(product: "Sentry"),
                .package(product: "Pow"),
                .package(product: "Kingfisher"),
                .package(product: "PopupView"),
                .package(product: "FloatingButton"),
                .package(product: "OneSignalFramework"),
                .target(name: "OneSignalNotificationServiceExtension"),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "NovoNordiskAppIcon",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "X5NVKUSVAE",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "CODE_SIGN_ENTITLEMENTS": "Magnus/UI/NovoNordiskApp/NovoNordiskApp.entitlements",
                    "TARGETED_DEVICE_FAMILY": "1",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5",
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "CODE_SIGN_IDENTITY": "Apple Development",
                            //"PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                            "OTHER_LDFLAGS": ["-Xlinker", "-interposable"],
                            "EMIT_FRONTEND_COMMAND_LINES": "YES",
                        ]),
                    .release(
                        name: .release,
                        settings: [
                            "CODE_SIGN_IDENTITY": "Apple Distribution",
                            //"PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                        ]),
                ]
            )
        ),
        .target(
            name: "ChM Academy",
            destinations: .iOS,
            product: .app,
            bundleId: "pl.serwik.chm.conference",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "2.03",
                    "CFBundleVersion": "17",
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
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    // Required by iOS when saving to the user's photo library
                    "NSPhotoLibraryAddUsageDescription": "Aplikacja potrzebuje dostępu do biblioteki zdjęć, aby zapisywać zdjęcia z fotobudki.",
                    "NSPhotoLibraryUsageDescription": "Aplikacja potrzebuje dostępu do biblioteki zdjęć, aby zapisywać zdjęcia z fotobudki.",
                    "NSCameraUsageDescription": "Aplikacja potrzebuje dostępu do kamery, aby zapisywać zdjęcia z fotobudki.",
                    "NSMicrophoneUsageDescription": "Aplikacja potrzebuje dostępu do mikrofonu, aby zapisywać zdjęcia z fotobudki.",
                    "NSLocationWhenInUseUsageDescription": "Aplikacja potrzebuje dostępu do lokalizacji, aby wyświetlić Twoją pozycję na mapie oraz miejsce wydarzenia.",

                ]
            ),
            sources: ["Magnus/UI/ChMApp/Sources/**"],
            resources: ["Magnus/UI/ChMApp/Resources/**"],
            dependencies: [
                .target(name: "MagnusApplication"),
                .target(name: "MagnusDomain"),
                .target(name: "MagnusFeatures"),
                .package(product: "Sentry"),
                .package(product: "Pow"),
                .package(product: "Kingfisher"),
                .package(product: "PopupView"),
                .package(product: "OneSignalFramework"),
                .target(name: "ChMOneSignalNotificationServiceExtension"),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "NovoNordiskAppIcon",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "69392QSC2U",
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "TARGETED_DEVICE_FAMILY": "1",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5",
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "CODE_SIGN_IDENTITY": "Apple Development",
                            //"PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                            "OTHER_LDFLAGS": ["-Xlinker", "-interposable"],
                            "EMIT_FRONTEND_COMMAND_LINES": "YES",
                        ]),
                    .release(
                        name: .release,
                        settings: [
                            "CODE_SIGN_IDENTITY": "Apple Distribution",
                            //"PROVISIONING_PROFILE_SPECIFIER": "",  // Automatyczne
                        ]),
                ]
            )
        ),
        .target(
            name: "MagnusTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "pl.mz.magnus.MagnusTests",
            infoPlist: .default,
            sources: ["Magnus/Tests/**"],
            dependencies: [
                .target(name: "MagnusDomain"),
                .target(name: "MagnusApplication"),
                .target(name: "MagnusFeatures"),
                .package(product: "Alamofire"),
                .package(product: "Sentry"),
            ],
            settings: .settings(
                base: [
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.5"
                ]
            )
        ),
    ]
)
