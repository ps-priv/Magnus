import Foundation
import MagnusDomain

public struct NewsDetailCardViewDto: Identifiable, Hashable, Decodable {
    public let id: String
    public let publish_date: String
    public let title: String
    public let description: String
    public let isBookmarked: Bool
    public let author: Author
    public let read_count: Int
    public let reactions_count: Int
    public let comments_count: Int
    public let image: String
    public let tags: String
    public let comments: [Comment]
    public var reactions: [Reaction]
    public let read: [ReadBy]
    public let attachments: [NewsMaterial]

    public init(id: String, publish_date: String, title: String, description: String, isBookmarked: Bool, author: Author, 
                read_count: Int, reactions_count: Int, comments_count: Int, image: String, tags: String, comments: [Comment], reactions: [Reaction], read: [ReadBy], attachments: [NewsMaterial]) {
        self.id = id
        self.publish_date = publish_date
        self.title = title
        self.description = description
        self.isBookmarked = isBookmarked
        self.author = author
        self.read_count = read_count
        self.reactions_count = reactions_count
        self.comments_count = comments_count
        self.image = image
        self.tags = tags
        self.comments = comments
        self.reactions = reactions
        self.read = read
        self.attachments = attachments
    }

    public static func fromNewsDetails(newsDetails: NewsDetails) -> NewsDetailCardViewDto {

        let tags = newsDetails.tags.joined(separator: ", ")

        return NewsDetailCardViewDto(
            id: newsDetails.id,
            publish_date: newsDetails.publish_date,
            title: newsDetails.title,
            description: newsDetails.description,
            isBookmarked: newsDetails.isBookmarked ?? false,
            author: newsDetails.author,
            read_count: newsDetails.read_count,
            reactions_count: newsDetails.reactions_count,
            comments_count: newsDetails.comments_count,
            image: newsDetails.image,
            tags: tags,
            comments: newsDetails.comments,            
            reactions: newsDetails.reactions,
            read: newsDetails.read,
            attachments: newsDetails.attachments
        )
    }
}