import Foundation
import MagnusDomain

public class AuthStorageServiceMock: AuthStorageService {
    
    // MARK: - In-Memory Storage
    
    private var accessToken: String?
    private var refreshToken: String?
    private var userData: AuthUser?
    private var isUserAuthenticated: Bool = false
    private var tokenExpirationDate: Date?
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Token Management
    
    public func saveAccessToken(_ token: String) throws {
        accessToken = token
    }
    
    public func getAccessToken() throws -> String? {
        return accessToken
    }
    
    public func saveRefreshToken(_ token: String) throws {
        refreshToken = token
    }
    
    public func getRefreshToken() throws -> String? {
        return refreshToken
    }
    
    public func setTokenExpirationDate(_ date: Date) throws {
        tokenExpirationDate = date
    }
    
    public func getTokenExpirationDate() throws -> Date? {
        return tokenExpirationDate
    }
    
    // MARK: - User Data Management
    
    public func saveUserData(_ user: AuthUser) throws {
        userData = user
    }
    
    public func getUserData() throws -> AuthUser? {
        return userData
    }
    
    // MARK: - Authentication State
    
    public func setAuthenticated(_ isAuthenticated: Bool) throws {
        isUserAuthenticated = isAuthenticated
    }
    
    public func isAuthenticated() throws -> Bool {
        return isUserAuthenticated && accessToken != nil
    }
    
    public func isTokenExpired() -> Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false // If no expiration date, assume token is valid
        }
        return Date() > expirationDate
    }
    
    // MARK: - Clear Data
    
    public func removeAccessToken() throws {
        accessToken = nil
    }
    
    public func removeRefreshToken() throws {
        refreshToken = nil
    }
    
    public func removeUserData() throws {
        userData = nil
    }
    
    public func clearAllAuthData() throws {
        accessToken = nil
        refreshToken = nil
        userData = nil
        isUserAuthenticated = false
        tokenExpirationDate = nil
    }
    
    // MARK: - Batch Operations
    
    public func saveAuthSession(
        token: String,
        refreshToken: String?,
        user: AuthUser,
        expirationDate: Date?
    ) throws {
        try saveAccessToken(token)
        if let refreshToken = refreshToken {
            try saveRefreshToken(refreshToken)
        }
        try saveUserData(user)
        if let expirationDate = expirationDate {
            try setTokenExpirationDate(expirationDate)
        }
        try setAuthenticated(true)
    }
    
    public func getAuthSession() throws -> (
        token: String?,
        refreshToken: String?,
        user: AuthUser?,
        expirationDate: Date?
    ) {
        return (
            token: try getAccessToken(),
            refreshToken: try getRefreshToken(),
            user: try getUserData(),
            expirationDate: try getTokenExpirationDate()
        )
    }
}

// MARK: - Mock Extensions for Testing

public extension AuthStorageServiceMock {
    
    /// Resets all stored data
    func reset() {
        accessToken = nil
        refreshToken = nil
        userData = nil
        isUserAuthenticated = false
        tokenExpirationDate = nil
    }
    
    /// Checks if storage is empty
    var isEmpty: Bool {
        return accessToken == nil && 
               refreshToken == nil && 
               userData == nil && 
               !isUserAuthenticated
    }
    
    /// Returns summary of stored data for debugging
    var storageSummary: String {
        return """
        Storage Summary:
        - Access Token: \(accessToken != nil ? "Present" : "Nil")
        - Refresh Token: \(refreshToken != nil ? "Present" : "Nil") 
        - User Data: \(userData?.email ?? "Nil")
        - Authenticated: \(isUserAuthenticated)
        - Token Expired: \(isTokenExpired())
        """
    }
} 