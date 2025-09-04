public struct ConferenceMessageDetails: Identifiable, Hashable, Decodable {
    public let id: String
    public let title: String
    public let message: String
    public let publish_date: String
    public let publish_time: String
    public let picture: String
    public let event_id: String?
    public let material_id: String?
    public let academy_material_id: String?
    public let is_read: Bool

    public init(id: String, title: String, message: String, publish_date: String, publish_time: String, picture: String, event_id: String?, material_id: String?, academy_material_id: String?, is_read: Bool) {
        self.id = id
        self.title = title
        self.message = message
        self.publish_date = publish_date
        self.publish_time = publish_time
        self.picture = picture
        self.event_id = event_id
        self.material_id = material_id
        self.academy_material_id = academy_material_id
        self.is_read = is_read
    }
}