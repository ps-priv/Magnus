public struct UpdateNewsRequest: Hashable, Encodable, Decodable {
    public let id: String
    public let title: String
    public let message: String
    public let image: String
    public let tags: [String]
    public let user_groups: [String]
    public let attachments: [NewsAttachment]

    public init(id: String, title: String, message: String, image: String, tags: [String], user_groups: [String], attachments: [NewsAttachment]) {
        self.id = id
        self.title = title
        self.message = message
        self.image = image
        self.tags = tags
        self.user_groups = user_groups
        self.attachments = attachments
    }   
}

public extension UpdateNewsRequest {
    func isValid() -> Bool {
        return !id.isEmpty && !title.isEmpty && !message.isEmpty && !image.isEmpty 
    }
}
    