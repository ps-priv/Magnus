import SwiftUI
import MagnusDomain
import MagnusFeatures
import Combine

class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isCheckingAuthentication: Bool = true
    
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.authStorageService = DIContainer.shared.authStorageService
    }
    
    @MainActor
    func checkAuthenticationStatus() {
        isCheckingAuthentication = true
        
        // Add small delay to ensure DI is properly initialized
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                let isAuthenticated = try self.authStorageService.isAuthenticated()
                let isTokenExpired = self.authStorageService.isTokenExpired()
                
                if isAuthenticated && !isTokenExpired {
                    self.isAuthenticated = true
                } else {
                    // Clear expired session if needed
                    if isTokenExpired {
                        try? self.authStorageService.clearAllAuthData()
                    }
                    self.isAuthenticated = false
                }
                
            } catch {
                print("Error checking authentication: \(error)")
                // Default to unauthenticated on error
                self.isAuthenticated = false
            }
            
            self.isCheckingAuthentication = false
        }
    }
    
    @MainActor
    func setAuthenticated(_ authenticated: Bool) {
        isAuthenticated = authenticated
    }
    
    func logout() async {
        do {
            try authStorageService.clearAllAuthData()
            await MainActor.run {
                isAuthenticated = false
            }
        } catch {
            print("Error during logout: \(error)")
            await MainActor.run {
                isAuthenticated = false
            }
        }
    }
    
    var currentUser: AuthUser? {
        do {
            return try authStorageService.getUserData()
        } catch {
            return nil
        }
    }
}

// MARK: - Environment Key

struct AuthenticationStateManagerKey: EnvironmentKey {
    static let defaultValue = AuthenticationStateManager()
}

extension EnvironmentValues {
    var authenticationStateManager: AuthenticationStateManager {
        get { self[AuthenticationStateManagerKey.self] }
        set { self[AuthenticationStateManagerKey.self] = newValue }
    }
} 
