import SwiftUI
import MagnusDomain
import MagnusFeatures

struct LinkAttachmentSheet: View {
    var onAdd: (NewsAttachment) -> Void
    @State private var title: String = ""
    @State private var link: String = ""
    @Environment(\.dismiss) private var dismiss

    private var canAdd: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        link.isValidUrl
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title field
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.attachmentTitle)
                    .font(.headline)
                TextField(LocalizedStrings.attachmentTitlePlaceholder, text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.sentences)
            }

            // Link field
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStrings.attachmentLink)
                    .font(.headline)
                TextField(LocalizedStrings.attachmentLinkPlaceholder, text: $link)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }

            Button(action: handleAdd) {
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
    }

    private func handleAdd() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLink = link.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSharepoint = trimmedLink.range(of: "sharepoint", options: .caseInsensitive) != nil
        let attachment: NewsAttachment
        if isSharepoint {
            attachment = NewsAttachment.fromSharepoint(title: trimmedTitle, url: trimmedLink)
        } else {
            attachment = NewsAttachment.fromLink(title: trimmedTitle, url: trimmedLink)
        }
        onAdd(attachment)
        dismiss()
    }
}

#Preview {
    LinkAttachmentSheet(onAdd: { _ in })
}
