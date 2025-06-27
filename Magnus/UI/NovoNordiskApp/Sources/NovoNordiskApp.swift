import SwiftUI
import MagnusFeatures
import MagnusCore

@main
struct NovoNordiskApp: App {
    
    init() {
        // Initialize DI Container with NovoNordisk configuration
        DIContainer.shared.configure(with: .novonordisk)
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .novoNordiskTypography()
        }
    }
} 
