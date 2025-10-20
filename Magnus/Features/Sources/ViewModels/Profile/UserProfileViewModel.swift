import Combine
import Foundation
import MagnusDomain
import SwiftUI

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

@MainActor
public class UserProfileViewModel: ObservableObject {
    @Published public var user: UserProfileResponse?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var hasError: Bool = false
    @Published public var isAuthenticated: Bool = false
    @Published public var shouldLogout: Bool = false

    @Published public var isEmailValid: Bool = false
    @Published public var isProfilePanelValid: Bool = false
    @Published public var isPasswordPanelValid: Bool = false

    private let authService: AuthService
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(
        authService: AuthService = DIContainer.shared.authService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.authService = authService
        self.authStorageService = authStorageService
    }

    public func getUserProfile() async {

        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
            shouldLogout = false
            user = nil
        }

        do {
            let userProfile = try await authService.getUserProfile()

            self.user = userProfile

            await MainActor.run {
                isLoading = false
                hasError = false
                errorMessage = ""
            }

        } catch let error {
            SentryHelper.capture(error: error, action: "UserProfileViewModel.getUserProfile")
            //await handleError(error)

            await MainActor.run {
                hasError = true
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func logout() {
        do {
            try authStorageService.clearAllAuthData()
            isAuthenticated = false
            shouldLogout = true
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
        } catch {
            errorMessage = "Failed to clear authentication data: \(error.localizedDescription)"
        }
    }

    public func updateUser() async {
        
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }
        
        do {
            let request = UserProfileUpdateRequest(
                email: user?.email ?? "",
                firstName: user?.firstName ?? "",
                lastName: user?.lasName ?? ""
            )
            
            print("Request: \(request)")
            
            try await authService.updateUserProfile(request: request)
            
            // Refresh user profile after successful update
            await getUserProfile()
            
            await MainActor.run {
                isLoading = false
                hasError = false
                errorMessage = ""
            }
            
        } catch let error {
            print("Update user error: \(error)")
            SentryHelper.capture(error: error, action: "UserProfileViewModel.updateUser")
            
            await MainActor.run {
                hasError = true
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    public func changePassword(currentPassword: String, newPassword: String) async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }
        
        do {
            try await authService.changePassword(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
            
            await MainActor.run {
                isLoading = false
                hasError = false
                errorMessage = ""
            }
            
        } catch let error {
            print("Change password error: \(error)")
            SentryHelper.capture(error: error, action: "UserProfileViewModel.changePassword")
            
            await MainActor.run {
                hasError = true
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
