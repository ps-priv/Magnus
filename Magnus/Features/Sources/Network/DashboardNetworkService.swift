import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol DashboardNetworkServiceProtocol {
    func getDashboardData(token: String) -> AnyPublisher<DashboardResponse, Error>
}

public class DashboardNetworkService: DashboardNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getDashboardData(token: String) -> AnyPublisher<DashboardResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/dashboard",
            method: .get,
            responseType: DashboardResponse.self,
            bearerToken: token
        )
    }
}
