import Foundation

public struct GetEventsListResponse: Decodable {
    public let events: [ConferenceEvent]
}