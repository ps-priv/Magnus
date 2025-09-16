import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsMaterialRowItem: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let material: NewsMaterial
    let isSelected: Bool

    init(material: NewsMaterial, isSelected: Bool = false) {
        self.material = material
        self.isSelected = isSelected
    }

    var body: some View {
        Button(action: {
            if !material.link.isEmpty {
                navigationManager.navigateToMaterialPreview(
                    materialUrl: material.link, fileType: material.file_type)
            }
        }) {
            HStack(alignment: .top) {
                FAIcon(
                    FileTypeConverter.getIcon(from: material.file_type),
                    type: .thin,
                    size: 16,
                    color: Color.novoNordiskTextGrey
                )
                .padding(.top, 2)
                .frame(width: 20)

                Text(material.title)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
