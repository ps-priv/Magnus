import  SwiftUI
import MagnusDomain

public struct AttachmentsManager : View {

    @State private var showDeviceSheet = false
    @Binding var attachments: [NewsAttachment]

    public init(attachments: Binding<[NewsAttachment]>) {
        self._attachments = attachments
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                AttachmentFromDevice(action: {
                    showDeviceSheet = true
                })
                AttachmentFromLink(action: {
                    print("AttachmentFromLink Tapped")
                })
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.novoNordiskBackgroundGrey)
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
        .sheet(isPresented: $showDeviceSheet) {
            if #available(iOS 16.0, *) {
                DeviceAttachmentSheet(onAdd: { newAttachment in
                    attachments.append(newAttachment)
                })
                .presentationDetents([.fraction(1.0/3.0)])
                .presentationDragIndicator(.visible)
                .background(Color.white)
            } else {
                DeviceAttachmentSheet(onAdd: { newAttachment in
                    attachments.append(newAttachment)
                })
                .background(Color.white)
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
