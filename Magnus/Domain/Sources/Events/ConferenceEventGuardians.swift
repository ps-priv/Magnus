public struct ConferenceEventGuardians : Hashable, Decodable, Encodable {
    public let name: String
    public let email: String
    public let phone: String

    public init(name: String, email: String, phone: String) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}