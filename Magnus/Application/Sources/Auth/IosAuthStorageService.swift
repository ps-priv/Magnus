import Foundation
import Security
import MagnusDomain

public class IosAuthStorageService: AuthStorageService {
    
    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()
    }
    
    // MARK: - Token Management (Keychain)
    
    public func saveAccessToken(_ token: String) throws {
        try saveToKeychain(key: AuthStorageKey.accessToken.keychain, value: token)
    }
    
    public func getAccessToken() throws -> String? {
        return try getFromKeychain(key: AuthStorageKey.accessToken.keychain)
    }
    
    public func saveRefreshToken(_ token: String) throws {
        try saveToKeychain(key: AuthStorageKey.refreshToken.keychain, value: token)
    }
    
    public func getRefreshToken() throws -> String? {
        return try getFromKeychain(key: AuthStorageKey.refreshToken.keychain)
    }
    
    public func removeAccessToken() throws {
        try removeFromKeychain(key: AuthStorageKey.accessToken.keychain)
    }
    
    public func removeRefreshToken() throws {
        try removeFromKeychain(key: AuthStorageKey.refreshToken.keychain)
    }
    
    // MARK: - Token Expiration (UserDefaults)
    
    public func setTokenExpirationDate(_ date: Date) throws {
        userDefaults.set(date, forKey: AuthStorageKey.tokenExpirationDate.rawValue)
        guard userDefaults.synchronize() else {
            throw AuthStorageError.userDefaultsError
        }
    }
    
    public func getTokenExpirationDate() throws -> Date? {
        return userDefaults.object(forKey: AuthStorageKey.tokenExpirationDate.rawValue) as? Date
    }
    
    public func isTokenExpired() -> Bool {
        guard let expirationDate = try? getTokenExpirationDate() else {
            return true // If no expiration date, consider expired
        }
        return Date() >= expirationDate
    }
    
    // MARK: - User Data Management (UserDefaults)
    
    public func saveUserData(_ user: AuthUser) throws {
        do {
            let data = try jsonEncoder.encode(user)
            userDefaults.set(data, forKey: AuthStorageKey.userData.rawValue)
            guard userDefaults.synchronize() else {
                throw AuthStorageError.userDefaultsError
            }
        } catch {
            throw AuthStorageError.encodingFailed
        }
    }
    
    public func getUserData() throws -> AuthUser? {
        guard let data = userDefaults.data(forKey: AuthStorageKey.userData.rawValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(AuthUser.self, from: data)
        } catch {
            throw AuthStorageError.decodingFailed
        }
    }
    
    public func removeUserData() throws {
        userDefaults.removeObject(forKey: AuthStorageKey.userData.rawValue)
        guard userDefaults.synchronize() else {
            throw AuthStorageError.userDefaultsError
        }
    }
    
    // MARK: - Authentication State (UserDefaults)
    
    public func setAuthenticated(_ isAuthenticated: Bool) throws {
        userDefaults.set(isAuthenticated, forKey: AuthStorageKey.isAuthenticated.rawValue)
        guard userDefaults.synchronize() else {
            throw AuthStorageError.userDefaultsError
        }
    }
    
    public func isAuthenticated() throws -> Bool {
        return userDefaults.bool(forKey: AuthStorageKey.isAuthenticated.rawValue)
    }
    
    // MARK: - Clear Data
    
    public func clearAllAuthData() throws {
        // Remove tokens from Keychain
        try? removeAccessToken()
        try? removeRefreshToken()
        
        // Remove data from UserDefaults
        userDefaults.removeObject(forKey: AuthStorageKey.userData.rawValue)
        userDefaults.removeObject(forKey: AuthStorageKey.isAuthenticated.rawValue)
        userDefaults.removeObject(forKey: AuthStorageKey.tokenExpirationDate.rawValue)
        
        guard userDefaults.synchronize() else {
            throw AuthStorageError.userDefaultsError
        }
    }
    
    // MARK: - Batch Operations
    
    public func saveAuthSession(
        token: String,
        refreshToken: String?,
        user: AuthUser,
        expirationDate: Date?
    ) throws {
        // Save tokens to Keychain
        try saveAccessToken(token)
        if let refreshToken = refreshToken {
            try saveRefreshToken(refreshToken)
        }
        
        // Save user data and state to UserDefaults
        try saveUserData(user)
        try setAuthenticated(true)
        
        // Save expiration date if provided
        if let expirationDate = expirationDate {
            try setTokenExpirationDate(expirationDate)
        }
    }
    
    public func getAuthSession() throws -> (
        token: String?,
        refreshToken: String?,
        user: AuthUser?,
        expirationDate: Date?
    ) {
        let token = try? getAccessToken()
        let refreshToken = try? getRefreshToken()
        let user = try? getUserData()
        let expirationDate = try? getTokenExpirationDate()
        
        return (token, refreshToken, user, expirationDate)
    }
}

// MARK: - Private Keychain Methods

private extension IosAuthStorageService {
    
    func saveToKeychain(key: String, value: String) throws {
        // Delete existing item first
        try? removeFromKeychain(key: key)
        
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw AuthStorageError.keychainError(status)
        }
    }
    
    func getFromKeychain(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw AuthStorageError.keychainError(status)
        }
        
        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw AuthStorageError.invalidData
        }
        
        return string
    }
    
    func removeFromKeychain(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        // errSecItemNotFound is OK - means item was already deleted
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthStorageError.keychainError(status)
        }
    }
} 