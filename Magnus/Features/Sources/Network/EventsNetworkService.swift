// import Alamofire
// import Combine
// import Foundation
// import MagnusDomain

// public protocol EventsNetworkServiceProtocol {
//     func fetchEvents() -> AnyPublisher<[ConferenceEvent], Error>
//     func fetchEventDetails(eventId: String) -> AnyPublisher<ConferenceEvent, Error>
//     func registerForEvent(eventId: String) -> AnyPublisher<Void, Error>
// }

// public class EventsNetworkService: EventsNetworkServiceProtocol {
//     private let networkService: NetworkServiceProtocol

//     public init(networkService: NetworkServiceProtocol) {
//         self.networkService = networkService
//     }

//     public func fetchEvents() -> AnyPublisher<[ConferenceEvent], Error> {
//         return networkService.request(
//             endpoint: "/api/events",
//             method: .get,
//             parameters: nil,
//             encoding: URLEncoding.default,
//             responseType: [ConferenceEvent].self
//         )
//     }

//     public func fetchEventDetails(eventId: String) -> AnyPublisher<ConferenceEvent, Error> {
//         return networkService.request(
//             endpoint: "/api/events/\(eventId)",
//             method: .get,
//             parameters: nil,
//             encoding: URLEncoding.default,
//             responseType: ConferenceEvent.self
//         )
//     }

//     public func registerForEvent(eventId: String) -> AnyPublisher<Void, Error> {
//         return networkService.request(
//             endpoint: "/api/events/\(eventId)/register",
//             method: .post,
//             parameters: nil,
//             encoding: URLEncoding.default
//         )
//     }
// }
