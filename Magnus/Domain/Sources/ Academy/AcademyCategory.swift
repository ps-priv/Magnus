import Foundation

public struct AcademyCategory: Identifiable, Equatable, Decodable, Hashable {
    public let id: String
    public let name: String
    public let subcategories: [AcademyCategory]

    public init(id: String, name: String, subcategories: [AcademyCategory] = []) {
        self.id = id
        self.name = name
        self.subcategories = subcategories
    }

    public var hasSubcategories: Bool {
        return !subcategories.isEmpty
    }
}
