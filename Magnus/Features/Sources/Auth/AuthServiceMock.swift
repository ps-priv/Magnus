import Foundation
import MagnusApplication
import MagnusDomain

public class AuthServiceMock: AuthService {
    // MARK: - Mock Data

    private let mockUser = AuthUser(
        id: "3F7A9B2E-8C45-4D91-B6E3-7F2A5C8E9D14",
        email: "user1@test.pl",
        firstName: "Jan",
        lastName: "Kowalski",
        admin: 0,
        news_editor: 0,
        photo_booths_editor: 1
    )

    private let mockToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token_data"
    private let mockRefreshToken = "refresh_token_abc123"

    private var currentUser: AuthUser?
    private var currentToken: String?
    private var isUserAuthenticated: Bool = false

    // MARK: - Valid Test Credentials

    private let validCredentials = [
        "user1@test.pl": "test123",
        "user2@test.pl": "test123",
        "user3@test.pl": "test123",
        "przedstawiciel@test.pl": "test123",
    ]

    // MARK: - AuthService Implementation

    public init() {}

    public func login(credentials: LoginCredentials) async throws -> AuthResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // Validate email format

        guard isValidPassword(credentials.password) else {
            throw AuthError.passwordTooShort
        }

        // Check credentials against mock data
        guard let expectedPassword = validCredentials[credentials.email],
              expectedPassword == credentials.password
        else {
            throw AuthError.invalidCredentials
        }

        // Create mock user based on email
        let user = createMockUser(for: credentials.email)

        // Update internal state
        currentUser = user
        currentToken = mockToken
        isUserAuthenticated = true

        // Return successful response
        return AuthResponse(
            token: mockToken,
            refreshToken: mockRefreshToken,
            user: user
        )
    }

    public func logout() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Clear internal state
        currentUser = nil
        currentToken = nil
        isUserAuthenticated = false
    }

    public func refreshToken(_ refreshToken: String) async throws -> AuthResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        guard refreshToken == mockRefreshToken else {
            throw AuthError.invalidCredentials
        }

        guard let user = currentUser else {
            throw AuthError.userNotFound
        }

        // Generate new mock token
        let newToken = "refreshed_\(mockToken)_\(Date().timeIntervalSince1970)"
        currentToken = newToken

        return AuthResponse(
            token: newToken,
            refreshToken: mockRefreshToken,
            user: user
        )
    }

    public func isValidEmail(_ email: String) -> Bool {
        return EmailValidator.isValid(email)
    }

    public func isValidPassword(_ password: String) -> Bool {
        return PasswordValidator.isValid(password)
    }

    public func isAuthenticated() -> Bool {
        return currentToken != nil && currentUser != nil
    }

    public func getCurrentToken() -> String? {
        return currentToken
    }

    public func getCurrentUser() -> AuthUser? {
        return currentUser
    }

    public func getUserProfile() async throws -> UserProfileResponse {
        return UserProfileResponse(
            id: "3F7A9B2E-8C45-4D91-B6E3-7F2A5C8E9D14",
            email: "user1@test.pl",
            firstName: "Jan",
            lasName: "Kowalski",
            role: CurrentUserTypeEnum.uczestnik,
            groups: "Kardiologia"
        )
    }

    public func updateUserProfile(request: UserProfileUpdateRequest) async throws {

        let user = getCurrentUser()
        guard let user = user else {
            throw AuthError.userNotFound
        }

        currentUser = user
    }
    
    public func changePassword(currentPassword: String, newPassword: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        guard isAuthenticated() else {
            throw AuthError.userNotFound
        }
        
        // In a real implementation, we would validate the current password
        // For mock purposes, we just simulate success
        guard isValidPassword(newPassword) else {
            throw AuthError.passwordTooShort
        }
    }
    
    public func forgetPassword(email: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Validate email format
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        // For mock purposes, just simulate success
        // In a real implementation, this would send a password reset email
    }

    // MARK: - Private Helpers

    private func createMockUser(for email: String) -> AuthUser {
        switch email {
        case "user1@test.pl":
            return AuthUser(
                id: "3F7A9B2E-8C45-4D91-B6E3-7F2A5C8E9D14",
                email: email,
                firstName: "Jan",
                lastName: "Kowalski",
                role: .uczestnik,
                admin: 0,
                news_editor: 0,
                photo_booths_editor: 0
            )
        case "user2@test.pl":
            return AuthUser(
                id: "A8D6F3B1-2E7C-4598-9A42-6B8E3F5D7C91",
                email: email,
                firstName: "Jan",
                lastName: "Nowak",
                role: .uczestnik,
                admin: 0,
                news_editor: 0,
                photo_booths_editor: 0
            )
        case "user3@test.pl":
            return AuthUser(
                id: "5C9E2A47-B3D8-4F61-8E29-4A7B6C9F2E85",
                email: email,
                firstName: "Anna",
                lastName: "Kowalska",
                role: .uczestnik,
                admin: 0,
                news_editor: 0,
                photo_booths_editor: 0
            )
        case "przedstawiciel@test.pl":
            return AuthUser(
                id: "F2B8D4A6-7E51-49C3-A296-8D5F1B7E4A92",
                email: email,
                firstName: "Józef",
                lastName: "Kowalski",
                role: .przedstawiciel,
                admin: 0,
                news_editor: 0,
                photo_booths_editor: 1
            )
        default:
            return AuthUser(
                id: "F2B8D4A6-7E51-49C3-A296-8D5F1B7E4A92",
                email: email,
                firstName: "Nieznany",
                lastName: "User",
                role: .uczestnik,
                admin: 0,
                news_editor: 0,
                photo_booths_editor: 0
            )
        }
    }
}

// MARK: - Mock Extensions for Testing

public extension AuthServiceMock {
    /// Returns all valid test credentials for UI testing
    static var testCredentials: [(email: String, password: String)] {
        return [
            ("user1@test.pl", "test123"),
            ("user2@test.pl", "test123"),
            ("user3@test.pl", "test123"),
            ("przedstawiciel@test.pl", "test123"),
        ]
    }

    /// Resets mock to initial state
    func reset() {
        currentUser = nil
        currentToken = nil
        isUserAuthenticated = false
    }

    /// Forces authentication state for testing
    func forceAuthenticate(as user: AuthUser) {
        currentUser = user
        currentToken = mockToken
        isUserAuthenticated = true
    }
}
