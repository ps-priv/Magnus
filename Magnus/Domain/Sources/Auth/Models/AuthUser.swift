public struct AuthUser {
    public let id: String
    public let email: String
    public let firstName: String?
    public let lastName: String?
    
    public init(id: String, email: String, firstName: String? = nil, lastName: String? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
