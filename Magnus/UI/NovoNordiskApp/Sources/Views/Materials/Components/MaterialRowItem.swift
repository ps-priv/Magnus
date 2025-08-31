import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct MaterialRowItem: View {

    let material: ConferenceMaterialListItem

    init(material: ConferenceMaterialListItem) {
        self.material = material
    }

    var body: some View {
        Button(action: {
            MaterialNavigatorHelper.navigateToMaterial(material: material)
        }) {
            HStack(alignment: .top) {
                FAIcon(
                    FileTypeConverter.getIcon(from: material.file_type),
                    type: .thin,
                    size: 21,
                    color: Color.novoNordiskTextGrey
                )
                .padding(.top, 5)
                .frame(width: 30)

                VStack(alignment: .leading, spacing: 0) {
                    Text(material.name)
                        .font(.novoNordiskBody)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    VStack {
                        Text(
                            PublishedDateHelper.formatDateForEvent(
                                material.publication_date, LocalizedStrings.months)
                        )
                        .font(.novoNordiskSmallText)
                        .foregroundColor(.novoNordiskBlue)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
