// import Alamofire
// import Combine
// import Foundation
// import MagnusDomain

// public protocol AcademyNetworkServiceProtocol {
//     func fetchCategories() -> AnyPublisher<[AcademyCategory], Error>
//     func fetchMaterials(for categoryId: String) -> AnyPublisher<[ConferenceMaterial], Error>
// }

// public class AcademyNetworkService: AcademyNetworkServiceProtocol {
//     private let networkService: NetworkServiceProtocol

//     public init(networkService: NetworkServiceProtocol) {
//         self.networkService = networkService
//     }

//     public func fetchCategories() -> AnyPublisher<[AcademyCategory], Error> {
//         return networkService.request(
//             endpoint: "/api/academy/categories",
//             method: .get,
//             parameters: nil,
//             encoding: URLEncoding.default,
//             responseType: [AcademyCategory].self
//         )
//     }

//     public func fetchMaterials(for categoryId: String) -> AnyPublisher<[ConferenceMaterial], Error>
//     {
//         return networkService.request(
//             endpoint: "/api/academy/categories/\(categoryId)/materials",
//             method: .get,
//             parameters: nil,
//             encoding: URLEncoding.default,
//             responseType: [ConferenceMaterial].self
//         )
//     }
// }
