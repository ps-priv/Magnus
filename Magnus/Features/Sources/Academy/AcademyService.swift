// import Combine
// import Foundation
// import MagnusApplication
// import MagnusDomain

// public protocol AcademyServiceProtocol {
//     func fetchCategories() -> AnyPublisher<[AcademyCategory], Error>
//     func fetchMaterials(for categoryId: String) -> AnyPublisher<[ConferenceMaterial], Error>
// }

// public class AcademyService: AcademyServiceProtocol {
//     private let networkService: AcademyNetworkServiceProtocol

//     public init(networkService: AcademyNetworkServiceProtocol) {
//         self.networkService = networkService
//     }

//     public func fetchCategories() -> AnyPublisher<[AcademyCategory], Error> {
//         return networkService.fetchCategories()
//             .catch { error in
//                 // Fallback to mock data if network fails
//                 return Just(AcademyCategoryMock.generateMockCategories())
//                     .setFailureType(to: Error.self)
//             }
//             .eraseToAnyPublisher()
//     }

//     public func fetchMaterials(for categoryId: String) -> AnyPublisher<[ConferenceMaterial], Error>
//     {
//         return networkService.fetchMaterials(for: categoryId)
//             .catch { error in
//                 // Fallback to mock data if network fails
//                 return Just(ConferenceMaterialsMockGenerator.createRandomMany(count: 3))
//                     .setFailureType(to: Error.self)
//             }
//             .eraseToAnyPublisher()
//     }
// }
