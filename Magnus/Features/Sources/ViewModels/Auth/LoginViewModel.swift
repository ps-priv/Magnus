import Foundation
import SwiftUI
import Combine
import MagnusDomain
import MagnusApplication

@MainActor
public class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var isAuthenticated: Bool = false
    
    // MARK: - Validation Properties
    
    @Published public var isEmailValid: Bool = false
    @Published public var isPasswordValid: Bool = false
    
    // MARK: - Dependencies
    
    private let authService: AuthService
    private let authStorageService: AuthStorageService
    
    // MARK: - Computed Properties
    
    public var isFormValid: Bool {
        return isEmailValid && isPasswordValid && !email.isEmpty && !password.isEmpty
    }
    
    public var canLogin: Bool {
        return isFormValid && !isLoading
    }
    
    // MARK: - Cancellables
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init(
        authService: AuthService = DIContainer.shared.authService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.authService = authService
        self.authStorageService = authStorageService
        
        setupValidation()
        checkExistingAuthentication()
    }
    
    // MARK: - Setup
    
    private func setupValidation() {
        // Email validation
        $email
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { email in
                EmailValidator.isValid(email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)
        
        // Password validation
        $password
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { password in
                PasswordValidator.hasValidLength(password, minLength: 6)
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)
    }
    
    private func checkExistingAuthentication() {
        do {
            isAuthenticated = try authStorageService.isAuthenticated()
        } catch {
            print("Error checking authentication: \(error)")
            isAuthenticated = false
        }
    }
    
    // MARK: - Public Methods
    
    public func login() async {
        guard canLogin else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            let credentials = LoginCredentials(
                email: email.normalizedEmail,
                password: password
            )
            
            let authResponse = try await authService.login(credentials: credentials)
            
            // Save authentication data
            try await saveAuthenticationData(authResponse)
            
            await MainActor.run {
                isAuthenticated = true
                isLoading = false
                clearForm()
            }
            
        } catch let error as AuthError {
            await handleAuthError(error)
        } catch {
            await handleGenericError(error)
        }
    }
    
    public func logout() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            try await authService.logout()
            try authStorageService.clearAllAuthData()
            
            await MainActor.run {
                isAuthenticated = false
                isLoading = false
                clearForm()
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Logout failed: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    public func clearError() {
        errorMessage = ""
    }
    
    public func clearForm() {
        email = ""
        password = ""
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    
    private func saveAuthenticationData(_ authResponse: AuthResponse) async throws {
        // Calculate token expiration (assume 1 hour if not provided)
        let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        try authStorageService.saveAuthSession(
            token: authResponse.token,
            refreshToken: authResponse.refreshToken,
            user: authResponse.user,
            expirationDate: expirationDate
        )
    }
    
    private func handleAuthError(_ error: AuthError) async {
        let message: String
        
        switch error {
        case .invalidCredentials:
            message = "Niepoprawny email lub hasło"
        case .invalidEmail:
            message = "Niepoprawny format adresu email"
        case .passwordTooShort:
            message = "Hasło musi mieć co najmniej 6 znaków"
        case .networkError(let details):
            message = "Błąd połączenia: \(details)"
        case .userNotFound:
            message = "Nie znaleziono użytkownika"
        case .serverError(let code):
            message = "Błąd serwera (\(code))"
        case .unknown:
            message = "Wystąpił nieznany błąd"
        }
        
        await MainActor.run {
            errorMessage = message
            isLoading = false
        }
    }
    
    private func handleGenericError(_ error: Error) async {
        await MainActor.run {
            errorMessage = "Błąd logowania: \(error.localizedDescription)"
            isLoading = false
        }
    }
}

// MARK: - Public Extensions

public extension LoginViewModel {
    
    /// Returns current user data if authenticated
    var currentUser: AuthUser? {
        do {
            return try authStorageService.getUserData()
        } catch {
            return nil
        }
    }
    
    /// Returns current access token if available
    var currentToken: String? {
        do {
            return try authStorageService.getAccessToken()
        } catch {
            return nil
        }
    }
    
    /// Checks if current session is expired
    var isSessionExpired: Bool {
        return authStorageService.isTokenExpired()
    }
    
    /// Refreshes token if refresh token is available
    func refreshTokenIfNeeded() async {
        guard isSessionExpired else { return }
        
        do {
            guard let refreshToken = try authStorageService.getRefreshToken() else {
                await logout()
                return
            }
            
            let authResponse = try await authService.refreshToken(refreshToken)
            try await saveAuthenticationData(authResponse)
            
        } catch {
            await logout()
        }
    }
} 