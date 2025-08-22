import MagnusDomain
import SwiftUI

public struct AttachmentRowItem: View {
    let onDelete: () -> Void
    let attachment: NewsAttachment

    public init(onDelete: @escaping () -> Void, attachment: NewsAttachment) {
        self.onDelete = onDelete
        self.attachment = attachment
    }

    public var body: some View {
        HStack {
            FAIcon(
                FileTypeConverter.getIcon(from: attachment.type),
                type: .thin,
                size: 16,
                color: Color.novoNordiskTextGrey
            )
            Text(attachment.title)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .lineLimit(1)
            Spacer()
            Button(action: onDelete) {
                FAIcon(.delete, size: 16, color: Color.novoNordiskLightBlue)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color.novoNordiskLightBlue.opacity(0.1))
        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
        .roundedCorners(12, corners: .all)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.novoNordiskLightBlue, lineWidth: 1)
        )
    }
}

#Preview {
    HStack {
        AttachmentRowItem(
            onDelete: {},
            attachment: NewsAttachment(title: "Attachment", type: .pdf, content: "", url: ""))
    }
    .padding(30)
}
