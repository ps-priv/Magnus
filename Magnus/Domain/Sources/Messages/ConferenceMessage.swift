public struct ConferenceMessage {
    public let id: String
    public let title: String
    public let date: String
    public let content: String
    public let image: String
    public let isRead: Bool

    public init(id: String, title: String, date: String, content: String, image: String, isRead: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.content = content
        self.image = image
        self.isRead = isRead
    }
}