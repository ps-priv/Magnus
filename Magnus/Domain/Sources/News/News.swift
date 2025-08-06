public struct News: Identifiable, Hashable, Decodable {
    public let id: String
    public let publish_date: String
    public let title: String
    public let author: Author
    public let read_count: Int
    public let reactions_count: Int
    public let comments_count: Int
    public let image: String

    public init(id: String, publish_date: String, title: String, author: Author, read_count: Int, reactions_count: Int, comments_count: Int, image: String) {
        self.id = id
        self.publish_date = publish_date
        self.title = title
        self.author = author
        self.read_count = read_count
        self.reactions_count = reactions_count
        self.comments_count = comments_count
        self.image = image
    }
}