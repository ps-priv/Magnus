import Foundation
import Combine
import MagnusDomain

@MainActor
public class MaterialsListViewModel: ObservableObject {

    @Published public var materials: [ConferenceMaterialListItem] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false

    private let materialsService: ApiMaterialsService

    public init(materialsService: ApiMaterialsService = DIContainer.shared.materialsService) {
        self.materialsService = materialsService

        Task {
            await loadData()
        }
    }

    // MARK: - Setup
    /// Load dashboard data
    public func loadData() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetMaterialsListResponse = try await materialsService.getMaterialsList()

            await MainActor.run {
                materials = data.materials
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            showToast = true
        }
    }
}