import Foundation
import MagnusDomain

public struct GetEventsListResponse: Decodable {
    public let events: [ConferenceEvent]
}