import Foundation

public protocol EventsServiceProtocol {
    func getEvents() async throws -> GetEventsListResponse
    func getEventDetails(id: String) async throws -> ConferenceEventDetails
    func getEventGallery(id: String) async throws -> GetEventGalleryResponse
    func uploadEventPhoto(eventId: String, image: Data) async throws -> Void
    func deleteEventPhoto(photoId: String) async throws -> Void
}