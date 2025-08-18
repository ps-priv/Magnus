import Foundation
import MagnusFeatures
import MagnusDomain
import MagnusApplication
import SwiftUI

struct MaterialItemComponent: View {
    let file_type: FileTypeEnum
    let name: String
    let publication_date: String

    var body: some View {
        HStack(alignment: .top) {
            FAIcon(
                FileTypeConverter.getIcon(from: file_type),
                type: .thin,
                size: 21,
                color: Color.novoNordiskTextGrey
            )
            .padding(.top, 5)
            .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.novoNordiskBody)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                VStack {
                    Text(
                        PublishedDateHelper.formatDateForEvent(
                            publication_date, LocalizedStrings.months)
                    )
                    .font(.system(size: 14))
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
