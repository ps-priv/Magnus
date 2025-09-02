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
        }
        
        do {
            // TODO: Implement actual password reset API call
            // For now, simulate API call
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            // Simulate success or error based on email format
            if email.contains("@") && email.contains(".") {
                await MainActor.run {

                    isLoading = false
                }
            } else {
                await MainActor.run {
                    errorMessage = FeaturesLocalizedStrings.invalidEmail
                    isLoading = false
                }
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Wystąpił błąd podczas wysyłania emaila"
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