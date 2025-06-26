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
