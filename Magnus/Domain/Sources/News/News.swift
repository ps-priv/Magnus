public struct News: Codable {
    public let id: String
    public let publish_date: String
    public let title: String
    public let author: Author
    public let read_count: Int
    public let reactions_count: Int
    public let comments_count: Int
    public let image: String
}