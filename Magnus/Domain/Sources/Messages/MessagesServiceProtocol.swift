import Foundation

public protocol MessagesServiceProtocol {
    func getMessagesList() async throws -> GetMessagesListResponse
}