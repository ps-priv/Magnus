import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AcademyMaterialRowItem: View {
    let material: AcademyCategoryArticle

    var body: some View {
        HStack(alignment: .top) {
            Button(action: { 
                MaterialNavigatorHelper.navigateToMaterialUrl(link: material.link, fileType: material.file_type)
            }) {
                FAIcon(
                    ConferenceMaterialTypeConverter.getIcon(from: material.file_type),
                    type: .thin,
                    size: 21,
                    color: Color.novoNordiskTextGrey
                )
                .padding(.top, 5)
                .frame(width: 30)

                VStack(alignment: .leading, spacing: 4) {
                    Text(material.name)
                        .font(.novoNordiskBody)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    Text(
                        PublishedDateHelper.formatDateForEvent(
                            material.publication_date, LocalizedStrings.months)
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.novoNordiskBlue)
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AcademyMaterialRowItem(
        material: AcademyCategoryArticle(
            id: "1", name: "Material 1", file_type: .pdf, link: "https://example.com/material1.pdf",
            publication_date: "2021-01-01"))
}
