public enum AuthStorageKey: String, CaseIterable {
    case accessToken = "auth_access_token"
    case refreshToken = "auth_refresh_token"
    case userData = "auth_user_data"
    case isAuthenticated = "auth_is_authenticated"
    case tokenExpirationDate = "auth_token_expiration"
    
    public var keychain: String {
        return "pl.mz.magnus.\(self.rawValue)"
    }
}