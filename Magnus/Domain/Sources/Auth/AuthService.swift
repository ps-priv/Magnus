import Foundation

// MARK: - Auth Models

public struct LoginCredentials {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct AuthResponse {
    public let token: String
    public let refreshToken: String?
    public let user: AuthUser

    public init(token: String, refreshToken: String? = nil, user: AuthUser) {
        self.token = token
        self.refreshToken = refreshToken
        self.user = user
    }
}

public struct UserPermissions {
    public let id: String
    public let admin: Int
    public let news_editor: Int
    public let photo_booths_editor: Int

    public init(id: String, admin: Int, news_editor: Int, photo_booths_editor: Int) {
        self.id = id
        self.admin = admin
        self.news_editor = news_editor
        self.photo_booths_editor = photo_booths_editor
    }

    public func canAddNews() -> Bool {
        return admin == 1 || news_editor == 1
    }

    public func canEditNews(newsAuthorId: String) -> Bool {

        if admin == 1 {
            return true
        }

        if news_editor == 1 {
            return true
        }

        if newsAuthorId == id {
            return true
        }

        return false
    }

    public func canDeletePhotos(newsAuthorId: String) -> Bool {
        return admin == 1 || photo_booths_editor == 1
    }
}

public struct AuthUser: Codable {
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let role: CurrentUserTypeEnum
    public let admin: Int
    public let news_editor: Int
    public let photo_booths_editor: Int

    public init(
        id: String, email: String, firstName: String, lastName: String,
        role: CurrentUserTypeEnum = .uczestnik,
        admin: Int,
        news_editor: Int,
        photo_booths_editor: Int
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.admin = admin
        self.news_editor = news_editor
        self.photo_booths_editor = photo_booths_editor
    }

    public var fullName: String {
        let first = firstName ?? ""
        let last = lastName ?? ""
        return "\(first) \(last)".trimmingCharacters(in: .whitespaces)
    }

    public var roleName: String {
        switch role {
        case .uczestnik:
            return "Uczestnik wydarzenia"
        case .przedstawiciel:
            return "Przedstawiciel firmy"
        }
    }

    public func getUserPermissions() -> UserPermissions {
        return UserPermissions(
            id: self.id,
            admin: self.admin,
            news_editor: self.news_editor,
            photo_booths_editor: self.photo_booths_editor
        )
    }
}

// MARK: - Auth Errors

public enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case networkError(String)
    case invalidEmail
    case passwordTooShort
    case invalidCurrentPassword
    case userNotFound
    case serverError(Int)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError(let message):
            return NSLocalizedString("Network error: \(message)", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email format", comment: "")
        case .passwordTooShort:
            return NSLocalizedString("Password must be at least 6 characters", comment: "")
        case .invalidCurrentPassword:
            return NSLocalizedString("Aktualne hasło jest nieprawidłowe", comment: "")
        case .userNotFound:
            return NSLocalizedString("User not found", comment: "")
        case .serverError(let code):
            return NSLocalizedString("Server error: \(code)", comment: "")
        case .unknown:
            return NSLocalizedString("An unknown error occurred", comment: "")
        }
    }
}

// MARK: - AuthService Protocol

public protocol AuthService {
    /// Authenticates user with email and password
    /// - Parameter credentials: User's login credentials
    /// - Returns: Authentication response with token and user data
    /// - Throws: AuthError if authentication fails
    func login(credentials: LoginCredentials) async throws -> AuthResponse

    /// Logs out current user
    /// - Throws: AuthError if logout fails
    func logout() async throws

    /// Refreshes authentication token
    /// - Parameter refreshToken: Current refresh token
    /// - Returns: New authentication response
    /// - Throws: AuthError if refresh fails
    //func refreshToken(_ refreshToken: String) async throws -> AuthResponse

    /// Validates if email format is correct
    /// - Parameter email: Email to validate
    /// - Returns: True if email is valid
    func isValidEmail(_ email: String) -> Bool

    /// Validates if password meets requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if password is valid
    func isValidPassword(_ password: String) -> Bool

    /// Checks if user is currently authenticated
    /// - Returns: True if user has valid session
    func isAuthenticated() -> Bool

    /// Gets current authentication token
    /// - Returns: Current token if available
    func getCurrentToken() -> String?

    /// Gets current authenticated user
    /// - Returns: Current user if authenticated
    func getCurrentUser() -> AuthUser?

    /// Gets current authenticated user profile
    /// - Returns: Current user profile if authenticated
    func getUserProfile() async throws -> UserProfileResponse

    /// Updates current authenticated user profile
    /// - Parameter request: User profile update request
    /// - Throws: AuthError if update fails
    func updateUserProfile(request: UserProfileUpdateRequest) async throws
    
    /// Changes user password
    /// - Parameters:
    ///   - currentPassword: Current password
    ///   - newPassword: New password
    /// - Throws: AuthError if password change fails
    func changePassword(currentPassword: String, newPassword: String) async throws
}
