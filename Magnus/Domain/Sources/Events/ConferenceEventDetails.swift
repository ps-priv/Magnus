public struct ConferenceEventDetails : Hashable, Decodable {
    public let title: String
    public let date_from: String //yyyy-MM-dd
    public let date_to: String //yyyy-MM-dd
    public let image: String
    public let name: String
    public let description: String
    public let location: ConferenceEventLocation
    public let agenda: [ConferenceEventAgenda]
    public let dinner: ConferenceEventDinner
    public let materials: [ConferenceEventMaterial]
    public let photo_booth: [ConferenceEventPhotoBooth]
}
    