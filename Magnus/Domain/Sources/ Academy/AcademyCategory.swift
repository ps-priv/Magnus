import Foundation

public struct AcademyCategory {
    public let name: String
    public let subcategories: [AcademyCategory]

    public init(name: String, subcategories: [AcademyCategory] = []) {
        self.name = name
        self.subcategories = subcategories
    }

    public var hasSubcategories: Bool {
        return !subcategories.isEmpty
    }
}
