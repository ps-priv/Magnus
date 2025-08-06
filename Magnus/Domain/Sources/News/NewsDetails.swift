public struct NewsDetails : Identifiable, Hashable, Decodable {
    public let id: String
    public let publish_date: String 
    public let title: String
    public let image: String
    public let highlight_entry: Int
    public let block_comments: Int
    public let block_reactions: Int
    public let author: Author
    public let isBookmarked: Bool
    public let read_count: Int
    public let reactions_count: Int
    public let comments_count: Int

    //     "comments": [],
    // "reactions": [],
    // "read": [],
    // "attachments": [],
    // "tags": [],
    // "groups": []

    public init(id: String, publish_date: String, title: String, image: String, highlight_entry: Int, block_comments: Int, block_reactions: Int, author: Author, isBookmarked: Bool, read_count: Int, reactions_count: Int, comments_count: Int) {
        self.id = id
        self.publish_date = publish_date
        self.title = title
        self.image = image
        self.highlight_entry = highlight_entry
        self.block_comments = block_comments
        self.block_reactions = block_reactions
        self.author = author
        self.isBookmarked = isBookmarked
        self.read_count = read_count
        self.reactions_count = reactions_count
        self.comments_count = comments_count
    }
}