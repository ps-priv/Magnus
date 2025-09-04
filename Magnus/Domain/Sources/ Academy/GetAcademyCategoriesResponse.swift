public struct GetAcademyCategoriesResponse: Hashable, Decodable {
    public let categories: [AcademyCategory]

    public init(categories: [AcademyCategory]) {
        self.categories = categories
    }
}