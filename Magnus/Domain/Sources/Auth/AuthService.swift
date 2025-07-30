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

public struct AuthUser: Codable {
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let role: CurrentUserTypeEnum

    public init(
        id: String, email: String, firstName: String, lastName: String,
        role: CurrentUserTypeEnum = .uczestnik
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
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
}

// MARK: - Auth Errors

public enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case networkError(String)
    case invalidEmail
    case passwordTooShort
    case userNotFound
    case serverError(Int)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidEmail:
            return "Invalid email format"
        case .passwordTooShort:
            return "Password must be at least 6 characters"
        case .userNotFound:
            return "User not found"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown:
            return "An unknown error occurred"
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
}
