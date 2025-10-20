import Foundation
import SwiftUI
import Combine
import MagnusDomain
import MagnusApplication


@MainActor
public class ForgotPasswordViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isEmailValid: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var emailSentSuccessfully: Bool = false

    private var cancellables = Set<AnyCancellable>()

    private let authService: AuthService

    public var canSendResetPasswordEmail: Bool {
        return isFormValid && !isLoading
    }

    public var isFormValid: Bool {
        return isEmailValid && !email.isEmpty
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
    
    }

    public func clearError() {
        errorMessage = ""
    }
    
    public func clearForm() {
        email = ""
        errorMessage = ""
    }

    public func sendResetPasswordEmail() async {
        guard isFormValid else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
            emailSentSuccessfully = false
        }
        
        do {
            // Call the forget password API
            try await authService.forgetPassword(email: email)
            
            await MainActor.run {
                emailSentSuccessfully = true
                isLoading = false
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                switch error {
                case .invalidEmail:
                    errorMessage = FeaturesLocalizedStrings.invalidEmail
                case .networkError(let message):
                    errorMessage = "Błąd sieci: \(message)"
                case .userNotFound:
                    errorMessage = "Nie znaleziono użytkownika z tym adresem email"
                default:
                    errorMessage = "Wystąpił błąd podczas wysyłania emaila"
                }
                isLoading = false
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