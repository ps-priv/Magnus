import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol MessagesNetworkServiceProtocol {
    func getMessagesList(token: String) -> AnyPublisher<GetMessagesListResponse, Error>
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
}