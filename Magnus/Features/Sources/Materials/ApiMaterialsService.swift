import Foundation
import Combine
import MagnusDomain

public class ApiMaterialsService: MaterialsServiceProtocol {
    private let materialsNetworkService: MaterialsNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(materialsNetworkService: MaterialsNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.materialsNetworkService = materialsNetworkService
        self.authStorageService = authStorageService
    }

    public func getMaterialsList() async throws -> GetMaterialsListResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let materialsList = try await withCheckedThrowingContinuation { continuation in
            materialsNetworkService.getMaterialsList(token: token)
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

        return materialsList
    }

}