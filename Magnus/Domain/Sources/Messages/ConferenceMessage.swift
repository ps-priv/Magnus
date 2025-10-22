public struct ConferenceMessage: Identifiable, Hashable, Decodable {
    public let id: String
    public let publish_date: String
    public let publish_time: String
    public let title: String
    public let picture: String?
    public let is_read: Bool

    public init(id: String, title: String, publish_date: String, publish_time: String, picture: String?, is_read: Bool) {
        self.id = id
        self.title = title
        self.publish_date = publish_date
        self.publish_time = publish_time
        self.picture = picture
        self.is_read = is_read
    }
}