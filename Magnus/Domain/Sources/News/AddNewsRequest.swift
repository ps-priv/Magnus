public struct AddNewsRequest: Hashable, Encodable, Decodable {
    public let title: String
    public let message: String
    public let image: String
    public let tags: [String]
    public let user_groups: [String]
    public let attachments: [NewsAttachment]
    public let allow_comments: Bool


    public init(title: String, message: String, image: String, tags: [String], user_groups: [String], attachments: [NewsAttachment], allow_comments: Bool) {
        self.title = title
        self.message = message
        self.image = image
        self.tags = tags
        self.user_groups = user_groups
        self.attachments = attachments
        self.allow_comments = allow_comments    
    }   
}

public extension AddNewsRequest {
    func isValid() -> Bool {
        return !title.isEmpty && !message.isEmpty && !image.isEmpty 
    }
}
    
    
    
