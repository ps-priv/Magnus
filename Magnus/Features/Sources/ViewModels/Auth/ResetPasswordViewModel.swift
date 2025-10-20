import Foundation
import SwiftUI
import Combine
import MagnusDomain
import MagnusApplication


@MainActor
public class ResetPasswordViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var verificationCode: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isEmailValid: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var isPasswordValid: Bool = false
    @Published public var isConfirmPasswordValid: Bool = false
    @Published public var canResetPasswordFlag: Bool = false
    @Published public var passwordResetSuccessfully: Bool = false

    private var cancellables = Set<AnyCancellable>()

    private let authService: AuthService

    public var canResetPassword: Bool {
        return isFormValid && !isLoading
    }

    public var isFormValid: Bool {
        return isEmailValid && !email.isEmpty 
        && isPasswordValid && !password.isEmpty
        && isConfirmPasswordValid && !confirmPassword.isEmpty 
        && !verificationCode.isEmpty
        && password == confirmPassword
    }

    public init(authService: AuthService = DIContainer.shared.authService) {
        self.authService = authService
        setupValidation()
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
                PasswordValidator.isValid(password)
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        // Confirm password validation
        $confirmPassword
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { confirmPassword in
                confirmPassword == self.password && !confirmPassword.isEmpty
            }
            .assign(to: \.isConfirmPasswordValid, on: self)
            .store(in: &cancellables)
    
    }

    public func clearError() {
        errorMessage = ""
    }
    
    public func clearForm() {
        email = ""
        errorMessage = ""
    }

    public func resetPassword() async {
        guard isFormValid else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
            passwordResetSuccessfully = false
        }
        
        do {
            // Call the reset password API
            try await authService.resetPassword(
                email: email,
                code: verificationCode,
                password: password,
                passwordConfirmation: confirmPassword
            )
            
            await MainActor.run {
                passwordResetSuccessfully = true
                isLoading = false
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                switch error {
                case .invalidEmail:
                    errorMessage = FeaturesLocalizedStrings.invalidEmail
                case .passwordTooShort:
                    errorMessage = "Hasło jest za krótkie"
                case .networkError(let message):
                    errorMessage = "Błąd sieci: \(message)"
                case .invalidCredentials:
                    errorMessage = "Nieprawidłowy kod weryfikacyjny"
                default:
                    errorMessage = "Wystąpił błąd podczas resetowania hasła"
                }
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Wystąpił błąd podczas resetowania hasła"
                isLoading = false
            }
        }
    }
    
    private func handleGenericError(_ error: Error) async {
        await MainActor.run {
            errorMessage = "Wystąpił nieoczekiwany błąd"
            isLoading = false
        }
    }
}