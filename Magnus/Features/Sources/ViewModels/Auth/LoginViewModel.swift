import Combine
import Foundation
import MagnusApplication
import MagnusDomain
import Sentry
import SwiftUI

@MainActor
public class LoginViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published public var email: String = "user1@test.pl"
    @Published public var password: String = "test123"
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var isAuthenticated: Bool = false
    @Published public var LoginAttempts: Int = 0

    @Published public var isEmailValid: Bool = false
    @Published public var isPasswordValid: Bool = false

    private let authService: AuthService
    private let authStorageService: AuthStorageService

    public var isFormValid: Bool {
        return isEmailValid && isPasswordValid && !email.isEmpty && !password.isEmpty
    }

    public var canLogin: Bool {
        return isFormValid && !isLoading
    }

    private var cancellables = Set<AnyCancellable>()

    public init(
        authService: AuthService = DIContainer.shared.authService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.authService = authService
        self.authStorageService = authStorageService

        setupValidation()
        checkExistingAuthentication()
    }

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
                LoginAttempts = 0
            }

        } catch let error as AuthError {
            SentryHelper.capture(error: error, action: "Login failed")
            LoginAttempts += 1
            await handleAuthError(error)
        } catch {
            SentryHelper.capture(error: error, action: "Login failed")
            LoginAttempts += 1
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
                errorMessage = FeaturesLocalizedStrings.logoutFailed
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
        let expirationDate = Calendar.current.date(byAdding: .hour, value: 10, to: Date())

        try authStorageService.saveAuthSession(
            token: authResponse.token,
            refreshToken: authResponse.refreshToken,
            user: authResponse.user,
            expirationDate: expirationDate
        )

        try authStorageService.saveUserData(authResponse.user)
    }

    private func handleAuthError(_ error: AuthError) async {
        let message: String

        switch error {
        case .invalidCredentials:
            message = FeaturesLocalizedStrings.invalidCredentials
        case .invalidEmail:
            message = FeaturesLocalizedStrings.invalidEmail
        case .passwordTooShort:
            message = FeaturesLocalizedStrings.passwordTooShort
        case .networkError(let details):
            message = FeaturesLocalizedStrings.networkError(details)
        case .userNotFound:
            message = FeaturesLocalizedStrings.userNotFound
        case .serverError(let code):
            message = FeaturesLocalizedStrings.serverError(code)
        case .unknown:
            message = FeaturesLocalizedStrings.unknownError
        }

        await MainActor.run {
            errorMessage = message
            isLoading = false
        }
    }

    private func handleGenericError(_ error: Error) async {
        await MainActor.run {
            errorMessage = FeaturesLocalizedStrings.loginFailed
            isLoading = false
        }
    }
}

// MARK: - Public Extensions

extension LoginViewModel {

    /// Returns current user data if authenticated
    public var currentUser: AuthUser? {
        do {
            return try authStorageService.getUserData()
        } catch {
            return nil
        }
    }

    /// Returns current access token if available
    public var currentToken: String? {
        do {
            return try authStorageService.getAccessToken()
        } catch {
            return nil
        }
    }

    /// Checks if current session is expired
    public var isSessionExpired: Bool {
        return authStorageService.isTokenExpired()
    }

    /// Refreshes token if refresh token is available
    // public func refreshTokenIfNeeded() async {
    //     guard isSessionExpired else { return }

    //     do {
    //         guard let refreshToken = try authStorageService.getRefreshToken() else {
    //             await logout()
    //             return
    //         }

    //         // let authResponse = try await authService.refreshToken(refreshToken)
    //         // try await saveAuthenticationData(authResponse)

    //     } catch {
    //         await logout()
    //     }
    // }
}
