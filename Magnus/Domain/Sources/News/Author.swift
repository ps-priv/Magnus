public struct Author: Identifiable, Hashable, Decodable {
    public let id: String
    public let name: String
    public let groups: String

    public init(id: String, name: String, groups: String) {
        self.id = id
        self.name = name
        self.groups = groups
    }
}