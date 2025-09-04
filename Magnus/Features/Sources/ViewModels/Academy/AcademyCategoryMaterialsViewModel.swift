import Foundation
import Combine
import MagnusDomain

@MainActor
public class AcademyCategoryMaterialsViewModel: ObservableObject {

    @Published public var materials: [AcademyCategoryArticle] = []
    @Published public var selectedCategory: String = ""   

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false

    private let academyService: ApiAcademyService

    public init(
        selectedCategory: String,
        academyService: ApiAcademyService = DIContainer.shared.academyService) {
        self.selectedCategory = selectedCategory
        self.academyService = academyService

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
            let data: GetArticlesInAcademyCategoryResponse = try await academyService.getArticlesInAcademyCategory(categoryId: selectedCategory)

            await MainActor.run {
                materials = data.academy_materials
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