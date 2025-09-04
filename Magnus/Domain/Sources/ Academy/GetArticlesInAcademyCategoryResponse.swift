public struct GetArticlesInAcademyCategoryResponse: Hashable, Decodable {
    public let academy_materials: [AcademyCategoryArticle]

    public init(academy_materials: [AcademyCategoryArticle]) {
        self.academy_materials = academy_materials
    }
}