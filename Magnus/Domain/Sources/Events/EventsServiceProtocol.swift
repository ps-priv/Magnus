public protocol EventsServiceProtocol {
    func getEvents() async throws -> GetEventsListResponse
    func getEventDetails(id: String) async throws -> ConferenceEventDetails
}