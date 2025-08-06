import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol NewsNetworkServiceProtocol {
    func getNews(token: String) -> AnyPublisher<GetNewsResponse, Error>
    func getNewsById(token: String, id: String) -> AnyPublisher<NewsDetails, Error>
}

public class NewsNetworkService: NewsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getNews(token: String) -> AnyPublisher<GetNewsResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news",
            method: .get,
            responseType: GetNewsResponse.self,
            bearerToken: token
        )
    }

    public func getNewsById(token: String, id: String) -> AnyPublisher<NewsDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)",
            method: .get,
            responseType: NewsDetails.self,
            bearerToken: token
        )
    }
}