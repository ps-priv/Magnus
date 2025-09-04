import Foundation
import Combine
import MagnusDomain

@MainActor
public class AcademyCategoryViewModel: ObservableObject {

    @Published public var academyCategories: [AcademyCategory] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false

    @Published public var selectedCategory: AcademyCategoryType = .doctor

    private let academyService: ApiAcademyService

    public init(
        selectedCategory: AcademyCategoryType = .doctor,
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

        print("selectedCategory: \(selectedCategory)")
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetAcademyCategoriesResponse = try await academyService.getAcademyCategories(categoryType: selectedCategory)

            await MainActor.run {
                print("academyCategories: \(data.categories)")
                academyCategories = data.categories
                isLoading = false
            }
        } catch let error {
            print("Error loading academy categories: \(error)")
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            showToast = true
        }
    }
}