public struct Comment: Identifiable, Hashable, Decodable {
    public let id: String
    public let message: String
    public let created_at: String    
    public let author: Author
}