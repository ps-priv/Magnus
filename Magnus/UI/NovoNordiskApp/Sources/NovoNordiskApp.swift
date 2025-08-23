import MagnusFeatures
import Sentry
import SwiftUI
import OneSignalFramework


@main
struct NovoNordiskApp: App {
    private let notificationClickHandler = NotificationClickHandler()

    init() {
        SentrySDK.start { options in
            options.dsn =
                "https://24c2a5beaab248e4e676e3aa6d888851@o4509733545115648.ingest.de.sentry.io/4509750748119120"
            options.debug = false  // Enabling debug when first installing is always helpful

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true
        }
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        // OneSignal Push Notifications initialization
        // App ID configured for NovoNordisk app
        OneSignal.initialize("fdc9099d-cf34-484d-8030-ecdbb4f2be91", withLaunchOptions: nil)
        // Configure OneSignal notification handlers
        //OneSignalService.configureHandlers()
        // Prompt for push permission (non-blocking). Customize as needed.
        OneSignal.Notifications.requestPermission({ accepted in
            print("OneSignal permission accepted: \(accepted)")
        }, fallbackToSettings: true)


        OneSignal.Notifications.addClickListener(notificationClickHandler)


        // Initialize DI Container with NovoNordisk configuration
        DIContainer.shared.configure(
            with: .novonordisk,
            apiBaseURL: "https://nncv2-dev.serwik.pl"  // Configure your API base URL here
        )

    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .novoNordiskTypography()
        }
    }
}

