public protocol AcademyServiceProtocol {
    func getAcademyCategories(categoryType: AcademyCategoryType) async throws -> GetAcademyCategoriesResponse
    func getArticlesInAcademyCategory(categoryId: String) async throws -> GetArticlesInAcademyCategoryResponse
}