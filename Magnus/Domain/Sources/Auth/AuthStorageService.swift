import Foundation


// MARK: - AuthStorageService Protocol

public protocol AuthStorageService {
    
    // MARK: - Token Management
    
    /// Saves access token securely in Keychain
    /// - Parameter token: Access token to save
    /// - Throws: AuthStorageError if save fails
    func saveAccessToken(_ token: String) throws
    
    /// Retrieves access token from Keychain
    /// - Returns: Access token if exists
    /// - Throws: AuthStorageError if retrieval fails
    func getAccessToken() throws -> String?
    
    /// Saves refresh token securely in Keychain
    /// - Parameter token: Refresh token to save
    /// - Throws: AuthStorageError if save fails
    func saveRefreshToken(_ token: String) throws
    
    /// Retrieves refresh token from Keychain
    /// - Returns: Refresh token if exists
    /// - Throws: AuthStorageError if retrieval fails
    func getRefreshToken() throws -> String?
    
    /// Sets token expiration date
    /// - Parameter date: Expiration date
    /// - Throws: AuthStorageError if save fails
    func setTokenExpirationDate(_ date: Date) throws
    
    /// Gets token expiration date
    /// - Returns: Expiration date if exists
    /// - Throws: AuthStorageError if retrieval fails
    func getTokenExpirationDate() throws -> Date?
    
    // MARK: - User Data Management
    
    /// Saves user data in UserDefaults
    /// - Parameter user: AuthUser to save
    /// - Throws: AuthStorageError if save fails
    func saveUserData(_ user: AuthUser) throws
    
    /// Retrieves user data from UserDefaults
    /// - Returns: AuthUser if exists
    /// - Throws: AuthStorageError if retrieval fails
    func getUserData() throws -> AuthUser?
    

    /// Checks if user is authenticated
    /// - Returns: Authentication status
    /// - Throws: AuthStorageError if retrieval fails
    func isAuthenticated() throws -> Bool
    
    /// Checks if current token is expired
    /// - Returns: True if token is expired
    func isTokenExpired() -> Bool
    
    // MARK: - Clear Data
    
    /// Removes access token from Keychain
    /// - Throws: AuthStorageError if removal fails
    func removeAccessToken() throws
    
    /// Removes refresh token from Keychain
    /// - Throws: AuthStorageError if removal fails
    func removeRefreshToken() throws
    
    /// Removes user data from UserDefaults
    /// - Throws: AuthStorageError if removal fails
    func removeUserData() throws
    
    /// Clears all authentication data (tokens and user data)
    /// - Throws: AuthStorageError if clearing fails
    func clearAllAuthData() throws
    
    // MARK: - Batch Operations
    
    /// Saves complete authentication session
    /// - Parameters:
    ///   - token: Access token
    ///   - refreshToken: Refresh token (optional)
    ///   - user: User data
    ///   - expirationDate: Token expiration date (optional)
    /// - Throws: AuthStorageError if save fails
    func saveAuthSession(
        token: String,
        refreshToken: String?,
        user: AuthUser,
        expirationDate: Date?
    ) throws
    
    /// Retrieves complete authentication session
    /// - Returns: Tuple with all auth data if available
    /// - Throws: AuthStorageError if retrieval fails
    func getAuthSession() throws -> (
        token: String?,
        refreshToken: String?,
        user: AuthUser?,
        expirationDate: Date?
    )
} 