public struct GetGroupsResponse: Hashable, Decodable {
    public let groups: [NewsGroup]

    public init(groups: [NewsGroup]) {
        self.groups = groups
    }
}