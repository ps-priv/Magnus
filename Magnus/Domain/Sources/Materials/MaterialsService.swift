import Foundation

public protocol MaterialsServiceProtocol {
    func getMaterialsList() async throws -> GetMaterialsListResponse
}