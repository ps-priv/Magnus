public struct ConferenceMessage {
    public let title: String
    public let date: String
    public let content: String
    public let image: String
    public let isRead: Bool

    public init(title: String, date: String, content: String, image: String, isRead: Bool) {
        self.title = title
        self.date = date
        self.content = content
        self.image = image
        self.isRead = isRead
    }
}