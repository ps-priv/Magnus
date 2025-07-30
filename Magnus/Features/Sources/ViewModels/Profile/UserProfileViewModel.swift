import Combine
import Foundation
import MagnusDomain
import SwiftUI

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

@MainActor
public class UserProfileViewModel: ObservableObject {
    @Published public var user: User?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isAuthenticated: Bool = false
    @Published public var shouldLogout: Bool = false

    @Published public var isEmailValid: Bool = false
    @Published public var isProfilePanelValid: Bool = false
    @Published public var isPasswordPanelValid: Bool = false

    private let authService: AuthService
    private let authStorageService: AuthStorageService

    public init(
        authService: AuthService = DIContainer.shared.authService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.authService = authService
        self.authStorageService = authStorageService
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

    public func updateUser() {
        isLoading = true
    }
}
