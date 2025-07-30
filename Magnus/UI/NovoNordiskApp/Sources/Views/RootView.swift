import SwiftUI
import MagnusFeatures
#if DEBUG
import Inject
#endif

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

enum AppState {
    case splash
    case authenticated
    case unauthenticated
}

struct RootView: View {
    @State private var appState: AppState = .splash
    @State private var authCheckCompleted = false
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
        ZStack {
            switch appState {
            case .splash:
                SplashView(onAnimationComplete: {
                    checkAuthenticationStatus()
                })
                
            case .authenticated:
                MainNavigationContainer()
                    .transition(.opacity)
                
            case .unauthenticated:
                LoginView(onAuthenticationSuccess: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .authenticated
                    }
                })
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState)
        .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                appState = .unauthenticated
            }
        }
        #if DEBUG
        .enableInjection()
        #endif
    }
    
    private func checkAuthenticationStatus() {
        // Add small delay to ensure DI is properly initialized
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                let authStorageService = DIContainer.shared.authStorageService
                let isAuthenticated = try authStorageService.isAuthenticated()
                let isTokenExpired = authStorageService.isTokenExpired()
                
                print("isAuthenticated:", isAuthenticated)
                print("isTokenExpired:", isTokenExpired)
                
                let user = try authStorageService.getUserData()
                print("User data:", user ?? "No user data found")
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    if isAuthenticated && !isTokenExpired {
                        appState = .authenticated
                    } else {
                        // Clear expired session if needed
                        if isTokenExpired {
                            try? authStorageService.clearAllAuthData()
                        }
                        appState = .unauthenticated
                    }
                }
                
            } catch {
                print("Error checking authentication: \(error)")
                // Default to unauthenticated on error
                withAnimation(.easeInOut(duration: 0.5)) {
                    appState = .unauthenticated
                }
            }
            
            authCheckCompleted = true
        }
    }
}

#Preview {
    RootView()
} 
