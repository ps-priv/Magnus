import Foundation
import MagnusDomain

public class AcademyCategoryMock {
    public static func generateMockCategories() -> [AcademyCategory] {
        return [
            AcademyCategory(id: "1", name: "Diabetologia", subcategories: [
                AcademyCategory(id: "2", name: "Diabetes typu 1", subcategories: [
                    AcademyCategory(id: "3", name: "Podstawy"),
                    AcademyCategory(id: "4", name: "Leczenie"),
                    AcademyCategory(id: "5", name: "Komplikacje"),
                ]),
                AcademyCategory(id: "6", name: "Diabetes typu 2", subcategories: [
                    AcademyCategory(id: "7", name: "Diagnostyka"),
                    AcademyCategory(id: "8", name: "Terapia"),
                ]),
            ]),
            AcademyCategory(id: "9", name: "Kardiologia", subcategories: [
                AcademyCategory(id: "10", name: "Choroby serca", subcategories: [
                    AcademyCategory(id: "11", name: "Niewydolność serca"),
                    AcademyCategory(id: "12", name: "Arytmie"),
                ]),
                AcademyCategory(id: "13", name: "Profilaktyka"),
            ]),
            AcademyCategory(id: "14", name: "Endokrynologia", subcategories: [
                AcademyCategory(id: "15", name: "Hormony", subcategories: [
                    AcademyCategory(id: "16", name: "Insulina"),
                    AcademyCategory(id: "17", name: "Glukagon"),
                ]),
            ]),
            AcademyCategory(id: "18", name: "Pediatria"),
        ]
    }
}
