public struct Reaction: Hashable, Decodable {
    public var reaction: ReactionEnum
    public let author: Author

    public init(reaction: ReactionEnum, author: Author) {
        self.reaction = reaction
        self.author = author
    }

    public func copy(reaction: ReactionEnum) -> Reaction {
        return Reaction(reaction: reaction, author: author)
    }
}