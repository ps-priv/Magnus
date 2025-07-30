import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AcademyMaterialRowItem: View {
    let material: ConferenceMaterial

    var body: some View {
        HStack(alignment: .top) {
            FAIcon(
                ConferenceMaterialTypeConverter.getIcon(from: material.type),
                type: .thin,
                size: 21,
                color: Color.primary
            )
            .padding(.top, 5)
            .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(material.title)
                    .font(.novoNordiskBody)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                Text(
                    PublishedDateHelper.formatDateForEvent(
                        material.publicationDate, LocalizedStrings.months)
                )
                .font(.system(size: 14))
                .foregroundColor(.novoNordiskBlue)

            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AcademyMaterialRowItem(
        material: ConferenceMaterial(
            id: "1", title: "Material 1", type: .pdf, publicationDate: "2021-01-01"))
}
