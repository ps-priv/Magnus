import Foundation
import Combine
import MagnusDomain

public class ApiAcademyService: AcademyServiceProtocol {
    private let academyNetworkService: AcademyNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(academyNetworkService: AcademyNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.academyNetworkService = academyNetworkService
        self.authStorageService = authStorageService
    }

    public func getAcademyCategories(categoryType: AcademyCategoryType) async throws -> GetAcademyCategoriesResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let academyCategories = try await withCheckedThrowingContinuation { continuation in
            academyNetworkService.getAcademyCategories(token: token, categoryType: categoryType) 
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }

        return academyCategories
    }

    public func getArticlesInAcademyCategory(categoryId: String) async throws -> GetArticlesInAcademyCategoryResponse {        
        let token = try authStorageService.getAccessToken() ?? ""   
        let articlesInAcademyCategory = try await withCheckedThrowingContinuation { continuation in    
            academyNetworkService.getArticlesInAcademyCategory(token: token, categoryId: categoryId)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }

        return articlesInAcademyCategory
    }   

}