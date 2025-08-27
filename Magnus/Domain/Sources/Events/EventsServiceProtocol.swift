import Foundation

public protocol EventsServiceProtocol {
    func getEvents() async throws -> GetEventsListResponse
    func getEventDetails(id: String) async throws -> ConferenceEventDetails
    func uploadEventPhoto(eventId: String, image: Data) async throws -> Void
}