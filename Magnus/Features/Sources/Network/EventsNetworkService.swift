import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol EventsNetworkServiceProtocol {
    func getEvents(token: String) -> AnyPublisher<GetEventsListResponse, Error>
    func getEventDetails(token: String, id: String) -> AnyPublisher<ConferenceEventDetails, Error>
}

public class EventsNetworkService: EventsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getEvents(token: String) -> AnyPublisher<GetEventsListResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events",
            method: .get,
            responseType: GetEventsListResponse.self,
            bearerToken: token
        )
    }

    public func getEventDetails(token: String, id: String) -> AnyPublisher<ConferenceEventDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events/\(id)",
            method: .get,
            responseType: ConferenceEventDetails.self,
            bearerToken: token
        )
    }
}
