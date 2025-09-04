import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

public struct AcademyCategoryMaterialsView: View {
    let categoryId: String
    let categoryName: String
    let action: () -> Void

    @StateObject private var viewModel: AcademyCategoryMaterialsViewModel

    public init(categoryId: String, categoryName: String, action: @escaping () -> Void) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.action = action
        _viewModel = StateObject(wrappedValue: AcademyCategoryMaterialsViewModel(selectedCategory: categoryId))
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                titleSection
                if viewModel.materials.isEmpty {
                    AcademyEmptyMaterialsListPanel()
                } else {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.materials, id: \.id) { material in
                            AcademyMaterialRowItem(material: material)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            Button(action: action) {
                FAIcon(
                    FontAwesome.Icon.circle_arrow_left,
                    type: .regular,
                    size: 24,
                    color: Color.novoNordiskBlue
                )
                Text(categoryName)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}

#Preview {
    VStack {
        AcademyCategoryMaterialsView(categoryId: "Diabetologia", categoryName: "Diabetologia", action: {})
    }
    .background(Color.novoNordiskBackgroundGrey)
    .padding(20)
}
