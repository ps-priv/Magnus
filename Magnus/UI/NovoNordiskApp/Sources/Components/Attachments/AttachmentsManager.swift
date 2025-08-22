import  SwiftUI
import MagnusDomain

public struct AttachmentsManager : View {

    @Binding var attachments: [NewsAttachment]

    public init(attachments: Binding<[NewsAttachment]>) {
        self._attachments = attachments
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(attachments, id: \.self) { attachment in
                    AttachmentRowItem(
                        onDelete: {
                            if let idx = attachments.firstIndex(of: attachment) {
                                attachments.remove(at: idx)
                            }
                        },
                        attachment: attachment
                    )
                }
            }
        }
    }
}

#Preview {

    @State @Previewable var attachments: [NewsAttachment] = [
        NewsAttachment(title: "Attachment Pdf", type: FileTypeEnum.pdf, content: "", url: ""),
        NewsAttachment(title: "Attachment Word", type: FileTypeEnum.docx, content: "", url: ""),
        NewsAttachment(title: "Attachment Link", type: FileTypeEnum.link, content: "", url: ""),
        NewsAttachment(title: "Attachment Sharepoint", type: FileTypeEnum.sharepoint, content: "", url: ""),
    ]
    VStack {
        AttachmentsManager(attachments: $attachments)
    }.padding()
}
