import MagnusFeatures
import Sentry
import SwiftUI

#if DEBUG
    import Inject
#endif

@main
struct NovoNordiskApp: App {
    init() {
        SentrySDK.start { options in
            options.dsn =
                "https://24c2a5beaab248e4e676e3aa6d888851@o4509733545115648.ingest.de.sentry.io/4509750748119120"
            options.debug = true  // Enabling debug when first installing is always helpful

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true
        }

        // Initialize DI Container with NovoNordisk configuration
        DIContainer.shared.configure(
            with: .novonordisk,
            apiBaseURL: "https://api.magnus.com"  // Configure your API base URL here
        )

        #if DEBUG
            // Load InjectionIII Bundle for hot reload
            Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?
                .load()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .novoNordiskTypography()
                #if DEBUG
                    .enableInjection()
                #endif
        }
    }
}
