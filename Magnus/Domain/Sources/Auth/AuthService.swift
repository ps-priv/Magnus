import Foundation

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
    func refreshToken(_ refreshToken: String) async throws -> AuthResponse
} 