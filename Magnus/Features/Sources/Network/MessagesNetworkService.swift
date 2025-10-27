import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol MessagesNetworkServiceProtocol {
    func getMessagesList(token: String) -> AnyPublisher<GetMessagesListResponse, Error>
    func getMessageDetails(token: String, id: String) -> AnyPublisher<ConferenceMessageDetails, Error>
    func getUnreadMessagesCount(token: String) -> AnyPublisher<GetUnreadMessagesResponse, Error>
}

public class MessagesNetworkService: MessagesNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getMessagesList(token: String) -> AnyPublisher<GetMessagesListResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/messages",
            method: .get,
            responseType: GetMessagesListResponse.self,
            bearerToken: token
        )
    }

    public func getMessageDetails(token: String, id: String) -> AnyPublisher<ConferenceMessageDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/messages/\(id)",
            method: .get,
            responseType: ConferenceMessageDetails.self,
            bearerToken: token
        )
    }

    public func getUnreadMessagesCount(token: String) -> AnyPublisher<GetUnreadMessagesResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/messages/count",
            method: .get,
            responseType: GetUnreadMessagesResponse.self,
            bearerToken: token
        )
    }
}