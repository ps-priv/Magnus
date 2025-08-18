public struct ConferenceEventAgenda : Identifiable, Hashable, Decodable, Encodable {
    public let id: String
    public let date: String //yyyy-MM-dd
    public let day: Int
    public let content: [ConferenceEventAgendaContent]

    public init(
        id: String, date: String, day: Int, content: [ConferenceEventAgendaContent]
    ) {
        self.id = id
        self.date = date
        self.day = day
        self.content = content
    }
}