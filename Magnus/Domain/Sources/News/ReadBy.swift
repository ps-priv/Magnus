import Foundation

public struct ReadBy : Hashable, Decodable {
    public let author: Author

    public init(author: Author) {
        self.author = author
    }
}
