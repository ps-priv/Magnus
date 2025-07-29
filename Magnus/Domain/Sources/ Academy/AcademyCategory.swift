import Foundation

struct AcademyCategory {
    let name: String
    let subcategories: [AcademyCategory]

    init(name: String, subcategories: [AcademyCategory] = []) {
        self.name = name
        self.subcategories = subcategories
    }
    
    var hasSubcategories: Bool {
        return !subcategories.isEmpty
    }
}
