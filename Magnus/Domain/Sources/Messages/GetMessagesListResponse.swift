public struct GetMessagesListResponse: Hashable, Decodable {
    public let messages: [ConferenceMessage]

    public init(messages: [ConferenceMessage]) {
        self.messages = messages
    }
}