public struct ConferenceEventAgendaContent : Hashable, Decodable, Encodable {
    public let time_from: String //HH:mm:ss
    public let time_to: String //HH:mm:ss
    public let place: String
    public let title: String
    public let speakers: String
    public let presenters: String
    public let description: String
    public let is_quiz: Int
    public let is_online: Int

    public init(
        time_from: String, time_to: String, place: String, title: String, speakers: String, presenters: String,
        description: String, is_quiz: Int, is_online: Int
    ) {
        self.time_from = time_from
        self.time_to = time_to
        self.place = place
        self.title = title
        self.speakers = speakers
        self.presenters = presenters
        self.description = description
        self.is_quiz = is_quiz
        self.is_online = is_online
    }
}