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

        let headers = JwtHeaderHelper.getJwtHeader(token: token)

        return networkService.request(
            endpoint: "/api/dashboard",
            method: .get,
            headers: headers,
            parameters: nil,
            encoding: URLEncoding.default,
            responseType: DashboardResponse.self
        )
    }

}
