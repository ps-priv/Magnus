import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol MaterialsNetworkServiceProtocol {
    func getMaterialsList(token: String) -> AnyPublisher<GetMaterialsListResponse, Error>
}

public class MaterialsNetworkService: MaterialsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getMaterialsList(token: String) -> AnyPublisher<GetMaterialsListResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/materials",
            method: .get,
            responseType: GetMaterialsListResponse.self,
            bearerToken: token
        )
    }
}
