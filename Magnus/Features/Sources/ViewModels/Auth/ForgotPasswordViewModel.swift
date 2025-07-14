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
        }
        
        // do {
        //     // let credentials = LoginCredentials(
        //     //     email: email.normalizedEmail,
        //     //     password: password
        //     // )
            
        //     // let authResponse = try await authService.login(credentials: credentials)
            
        //     // // Save authentication data
        //     // try await saveAuthenticationData(authResponse)
            
        //     // await MainActor.run {
        //     //     isAuthenticated = true
        //     //     isLoading = false
        //     //     clearForm()
        //     // }
            
        // } catch {
        //     await handleGenericError(error)
        // }
    }
}