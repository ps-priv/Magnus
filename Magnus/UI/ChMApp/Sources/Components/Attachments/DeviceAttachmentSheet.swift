import SwiftUI
import UniformTypeIdentifiers
import MagnusDomain

struct DeviceAttachmentSheet: View {
    var onAdd: (NewsAttachment) -> Void
    @State private var title: String = ""
    @State private var pickedURL: URL? = nil
    @State private var fileTypeText: String = ""
    @State private var showImporter: Bool = false
    @Environment(\.dismiss) private var dismiss

    private var allowedTypes: [UTType] {
        var types: [UTType] = [.pdf]
        if let docx = UTType(filenameExtension: "docx") { types.append(docx) }
        return types
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title field
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.attachmentTitle)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.attachmentTitlePlaceholder,
                    text: $title
                )    
            }

            // File name label
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.attachmentFileName)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(pickedURL?.lastPathComponent ?? LocalizedStrings.attachmentFileNameNoFileSelected)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .lineLimit(2)
            }

            // File type label
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.attachmentFileType)
                    .font(.headline)
                Text(fileTypeText.isEmpty ? "—" : fileTypeText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            // Pick button
            Button(action: { showImporter = true }) {
                HStack {
                    FAIcon(.file, type: .light, size: 18, color: .white)
                    Text(LocalizedStrings.attachmentFilePickerButton)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.novoNordiskBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            // Add attachment button
            Button(action: addAttachment) {
                HStack {
                    FAIcon(.plus, type: .light, size: 18, color: .white)
                    Text(LocalizedStrings.attachmentAdd)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(canAdd ? Color.novoNordiskBlue : Color.novoNordiskBlue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(!canAdd)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .fileImporter(isPresented: $showImporter, allowedContentTypes: allowedTypes, allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                pickedURL = url
                updateTypeText(for: url)
            case .failure:
                break
            }
        }
    }

    private var canAdd: Bool {
        guard let url = pickedURL else { return false }
        let ext = url.pathExtension.lowercased()
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (ext == "pdf" || ext == "docx")
    }

    private func addAttachment() {
        guard let url = pickedURL else { return }
        let ext = url.pathExtension.lowercased()
        do {
            let data = try Data(contentsOf: url)
            let base64 = data.base64EncodedString()
            let attachment: NewsAttachment
            switch ext {
            case "pdf":
                attachment = NewsAttachment.fromPdf(title: title, content: base64)
            case "docx":
                attachment = NewsAttachment.fromDocx(title: title, content: base64)
            default:
                return
            }
            onAdd(attachment)
            dismiss()
        } catch {
            // optionally handle error (log, show alert)
        }
    }

    private func updateTypeText(for url: URL) {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf":
            fileTypeText = "pdf"
        case "docx":
            fileTypeText = "docx"
        default:
            fileTypeText = ext
        }
    }
}

#Preview {
    DeviceAttachmentSheet(onAdd: { _ in })
}
