import Foundation

public struct NewsDetails : Identifiable, Hashable, Decodable {
    public let id: String
    public let publish_date: String 
    public let title: String
    public let description: String
    public let image: String
    public let highlight_entry: Int
    public let block_comments: Int
    public let block_reactions: Int
    public let author: Author
    public let tags: [String]
    public let groups: [Group]
    public let isBookmarked: Bool
    public let read_count: Int
    public let reactions_count: Int
    public let comments_count: Int
    public let comments: [Comment]
    public let reactions: [Reaction]
    public let read: [ReadBy]
    public let attachments: [NewsMaterial]

    public init(id: String, publish_date: String, title: String, description: String, image: String, highlight_entry: Int, block_comments: Int, 
                block_reactions: Int, author: Author, tags: [String], groups: [Group], isBookmarked: Bool, 
                read_count: Int, reactions_count: Int, comments_count: Int, 
                comments: [Comment], reactions: [Reaction], read: [ReadBy], attachments: [NewsMaterial]
    ) {
        self.id = id
        self.publish_date = publish_date
        self.title = title
        self.description = description
        self.image = image
        self.highlight_entry = highlight_entry
        self.block_comments = block_comments
        self.block_reactions = block_reactions
        self.author = author
        self.tags = tags
        self.groups = groups
        self.isBookmarked = isBookmarked
        self.read_count = read_count
        self.reactions_count = reactions_count
        self.comments_count = comments_count
        self.comments = comments
        self.reactions = reactions
        self.read = read
        self.attachments = attachments
    }
}