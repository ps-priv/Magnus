import Alamofire 
import Combine
import Foundation
import MagnusDomain      

public protocol AcademyNetworkServiceProtocol {
    func getAcademyCategories(token: String, categoryType: AcademyCategoryType) -> AnyPublisher<GetAcademyCategoriesResponse, Error>
    func getArticlesInAcademyCategory(token: String, categoryId: String) -> AnyPublisher<GetArticlesInAcademyCategoryResponse, Error>
}

public class AcademyNetworkService: AcademyNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getAcademyCategories(token: String, categoryType: AcademyCategoryType) -> AnyPublisher<GetAcademyCategoriesResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/academy/categories/\(categoryType.rawValue)",
            method: .get,
            responseType: GetAcademyCategoriesResponse.self,
            bearerToken: token
        )
    }

    public func getArticlesInAcademyCategory(token: String, categoryId: String) -> AnyPublisher<GetArticlesInAcademyCategoryResponse, Error>
    {
        return networkService.requestWithBearerToken(
            endpoint: "/api/academy/materials/\(categoryId)",
            method: .get,
            responseType: GetArticlesInAcademyCategoryResponse.self,
            bearerToken: token
        )
    }
}
