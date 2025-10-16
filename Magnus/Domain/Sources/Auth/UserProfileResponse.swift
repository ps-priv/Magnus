public struct UserProfileResponse: Decodable, Encodable {
    public let id: String
    public let email: String
    public let firstName: String
    public let lasName: String
    public let role: CurrentUserTypeEnum
    public let groups: String

    public init(id: String, email: String, firstName: String, lasName: String, role: CurrentUserTypeEnum, groups: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lasName = lasName
        self.role = role
        self.groups = groups
    }
}
