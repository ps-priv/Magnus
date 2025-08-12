// public struct Comment: Identifiable, Hashable, Decodable {
//     public let id: String
//     public let message: String
//     public let created_at: String    
//     public let author: Author

//     public init(id: String, message: String, created_at: String, author: Author) {
//         self.id = id
//         self.message = message
//         self.created_at = created_at
//         self.author = author
//     }
// }

public struct Comment: Hashable, Decodable {
    public let message: String
    public let created_at: String    
    public let author: Author

    public init(message: String, created_at: String, author: Author) {
        self.message = message
        self.created_at = created_at
        self.author = author
    }
}