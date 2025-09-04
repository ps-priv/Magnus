import Foundation

public protocol MessagesServiceProtocol {
    func getMessagesList() async throws -> GetMessagesListResponse
    func getMessageDetails(id: String) async throws -> ConferenceMessageDetails
}