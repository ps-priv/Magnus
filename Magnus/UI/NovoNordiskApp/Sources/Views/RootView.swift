import MagnusFeatures
import SwiftUI


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
    @StateObject private var networkStatusViewModel: NetworkStatusViewModel


    init() {
        let networkMonitor = DIContainer.shared.resolve(NetworkMonitorProtocol.self)!
        self._networkStatusViewModel = StateObject(
            wrappedValue: NetworkStatusViewModel(networkMonitor: networkMonitor))
    }

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

            // Overlay dla braku połączenia internetowego
            if networkStatusViewModel.showNoInternetView {
                NoInternetConnectionView {
                    networkStatusViewModel.retryConnection()
                }
                .transition(.opacity)
                .zIndex(1000)  // Zawsze na wierzchu
            }
        }
        .background(Color.white)
        .animation(.easeInOut(duration: 0.5), value: appState)
        .animation(.easeInOut(duration: 0.3), value: networkStatusViewModel.showNoInternetView)
        .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                appState = .unauthenticated
            }
        }
    }

    private func checkAuthenticationStatus() {
        // Add small delay to ensure DI is properly initialized
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                let authStorageService = DIContainer.shared.authStorageService
                let isAuthenticated = try authStorageService.isAuthenticated()
                let isTokenExpired = authStorageService.isTokenExpired()
                let expirationDate = try authStorageService.getTokenExpirationDate()

                print("isAuthenticated:", isAuthenticated)
                print("isTokenExpired:", isTokenExpired)
                print("expirationDate:", expirationDate ?? "No expiration date found")

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
