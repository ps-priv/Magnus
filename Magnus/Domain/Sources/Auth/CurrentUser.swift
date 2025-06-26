import Foundation

public struct CurrentUser {
    public let id: String
    public let email: String
    public let firstname: String
    public let lastname: String
    public let postalCode: String
    public let role: CurrentUserTypeEnum

    public init(id: String, email: String, firstname: String, lastname: String, postalCode: String, role: CurrentUserTypeEnum) {
        self.id = id
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.postalCode = postalCode
        self.role = role
    }
}
