import Foundation
import MagnusDomain

public class AcademyCategoryMock {
    public static func generateMockCategories() -> [AcademyCategory] {
        return [
            AcademyCategory(name: "Diabetologia", subcategories: [
                AcademyCategory(name: "Diabetes typu 1", subcategories: [
                    AcademyCategory(name: "Podstawy"),
                    AcademyCategory(name: "Leczenie"),
                    AcademyCategory(name: "Komplikacje"),
                ]),
                AcademyCategory(name: "Diabetes typu 2", subcategories: [
                    AcademyCategory(name: "Diagnostyka"),
                    AcademyCategory(name: "Terapia"),
                ]),
            ]),
            AcademyCategory(name: "Kardiologia", subcategories: [
                AcademyCategory(name: "Choroby serca", subcategories: [
                    AcademyCategory(name: "Niewydolność serca"),
                    AcademyCategory(name: "Arytmie"),
                ]),
                AcademyCategory(name: "Profilaktyka"),
            ]),
            AcademyCategory(name: "Endokrynologia", subcategories: [
                AcademyCategory(name: "Hormony", subcategories: [
                    AcademyCategory(name: "Insulina"),
                    AcademyCategory(name: "Glukagon"),
                ]),
            ]),
            AcademyCategory(name: "Pediatria"),
        ]
    }
}
