public struct GetUnreadMessagesResponse: Hashable, Decodable {
    public let unreadMessages: Int

    public init(unreadMessages: Int) {
        self.unreadMessages = unreadMessages
    }
}
