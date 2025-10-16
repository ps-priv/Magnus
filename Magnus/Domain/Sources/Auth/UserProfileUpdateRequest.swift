public struct UserProfileUpdateRequest: Decodable, Encodable  {
    public let email: String
    public let firstName: String
    public let lastName: String

    public init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}