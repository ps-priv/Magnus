public protocol EventsServiceProtocol {
    func getEvents() async throws -> GetEventsListResponse
}