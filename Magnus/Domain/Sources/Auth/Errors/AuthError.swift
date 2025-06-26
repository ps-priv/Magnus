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