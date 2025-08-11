public struct Reaction: Hashable, Decodable {
    public let reaction: ReactionEnum
    public let author: Author

    public init(reaction: ReactionEnum, author: Author) {
        self.reaction = reaction
        self.author = author
    }
}