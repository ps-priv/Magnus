import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

public struct AcademyCategoryMaterialsView: View {
    let categoryId: String
    let action: () -> Void
    private var materials: [ConferenceMaterial] = ConferenceMaterialsMockGenerator.createRandomMany(
        count: 3)

    public init(categoryId: String, action: @escaping () -> Void) {
        self.categoryId = categoryId
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                titleSection
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(materials, id: \.id) { material in
                        AcademyMaterialRowItem(material: material)
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
                Text(categoryId)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
    }
}

#Preview {
    VStack {
        AcademyCategoryMaterialsView(categoryId: "Diabetologia", action: {})
    }
    .background(Color.novoNordiskBackgroundGrey)
    .padding(20)
}
