import SwiftUI
import MagnusFeatures
#if DEBUG
import Inject
#endif

@main
struct NovoNordiskApp: App {
    
    init() {
        // Initialize DI Container with NovoNordisk configuration
        DIContainer.shared.configure(with: .novonordisk)
        
        #if DEBUG
        // Load InjectionIII Bundle for hot reload
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
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
