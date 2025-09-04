import Combine
import Foundation
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AcademyCategoryView: View {
    @State private var categories: [AcademyCategory] = []
    @State private var parentCategory: AcademyCategory? = nil
    @State private var selectedCategory: AcademyCategory? = nil
    @State private var currentCategories: [AcademyCategory] = []
    @State private var navigationHistory: [AcademyCategory] = []
    @State private var showBackButton: Bool = false
    @State private var showMaterials: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    @StateObject private var viewModel: AcademyCategoryViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    init(categoryId: String) {
        var categoryType: AcademyCategoryType

        if categoryId == "doctor" {
            categoryType = .doctor
        } else {
            categoryType = .patient
        }

        _viewModel = StateObject(wrappedValue: AcademyCategoryViewModel(selectedCategory: categoryType))
    }


    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                if !showMaterials {
                    if showBackButton {
                        AcademyCategoryBackButton(action: navigateBack)
                            .padding(.horizontal, 20)
                            .padding(.top, 5)
                    }
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.academyCategories.enumerated()), id: \.offset) {
                            itemIndex, category in
                            Button(action: {
                                if category.hasSubcategories {
                                    navigateToSubcategories(category)
                                } else {
                                    selectedCategory = category
                                    showMaterials = true
                                }
                            }) {
                                AcademyCategoryItemView(title: category.name)
                            }
                            .buttonStyle(PressedButtonStyle())
                            .padding(.horizontal, 20)
                            .padding(.top, 5)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                            .animation(.easeInOut(duration: 0.5), value: currentCategories)
                        }
                    }
                } else {
                    AcademyCategoryMaterialsView(
                        categoryId: selectedCategory?.id ?? "",
                        categoryName: selectedCategory?.name ?? "",
                        action: {
                            showMaterials = false
                        }
                    )
                    .animation(.easeInOut(duration: 0.5), value: showMaterials)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                }
            }
        }

        .background(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 20)
    }

    private func navigateToSubcategories(_ category: AcademyCategory) {
        navigationHistory.append(category)
        showBackButton = true
        //currentCategories = category.subcategories
    }

    private func navigateBack() {
        guard !navigationHistory.isEmpty else {
            // If no history, go back to root categories
            showBackButton = false
            currentCategories = categories
            return
        }

        // Remove the current category from history
        navigationHistory.removeLast()

        if navigationHistory.isEmpty {
            // Back to root categories
            showBackButton = false
            currentCategories = categories
        } else {
            // Back to previous category level
            let previousCategory = navigationHistory.last!
            //currentCategories = previousCategory.subcategories
        }
    }

    private func findCategory(withPath path: [String], in categories: [AcademyCategory])
        -> AcademyCategory?
    {
        guard !path.isEmpty else { return nil }

        let categoryName = path[0]
        guard let category = categories.first(where: { $0.name == categoryName }) else {
            return nil
        }

        return category

        // if path.count == 1 {
        //     return category
        // }
        // } else {
        //     let remainingPath = Array(path.dropFirst())
        //     return findCategory(withPath: remainingPath, in: categories)
        // }
    }
}

struct AcademyCategoryBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: { action() }) {
            HStack {
                FAIcon(.circle_arrow_left, size: 24, color: Color.novoNordiskBlue)
                Text(LocalizedStrings.back)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
    }
}

#Preview {
    AcademyCategoryView(categoryId: "doctor")
}

#Preview("AcademyCategoryBackButton") {
    AcademyCategoryBackButton(action: {})
}

struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.5), value: configuration.isPressed)
    }
}
