import SwiftUI

struct CreateCommentForNewsView: View {
    let onSendTap: (String) -> Void
    let onCancelTap: () -> Void
    @State private var commentText: String = ""
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.novoNordiskLightBlue)
                .frame(height: 2)
                .padding(.bottom, 10)

            NovoNordiskTextArea(
                placeholder: LocalizedStrings.createCommentForNewsPlaceholder,
                text: $commentText
            )
            NovoNordiskButton(
                title: LocalizedStrings.addCommentButton,
                style: commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .disabled : .primary,
                isEnabled: !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            ) {
                guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                onSendTap(commentText)
                commentText = ""
            }
            //.disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .frame(maxHeight: 150)
        .keyboardResponsive()
    }
    
    var body1: some View {
        VStack(spacing: 0) {

            Rectangle()
                .fill(Color.novoNordiskLightBlue)
                .frame(height: 2)
                .padding(.bottom, 10)

            HStack(spacing: 12) {
            
//                TextField(LocalizedStrings.createCommentForNewsPlaceholder, text: $commentText, axis: .vertical)
//                    .textFieldStyle(.plain)
//                    //.lineLimit(1)
//                    .font(.body)
//                    .foregroundColor(Color.novoNordiskTextGrey)

                // // Emoji button
                // Button(action: { /* could open emoji picker later */ }) {
                //     Image(systemName: "face.smiling")
                //         .font(.system(size: 20, weight: .regular))
                //         .foregroundStyle(.secondary)
                //         .frame(width: 24, height: 24)
                //         .contentShape(Rectangle())
                // }
                // .buttonStyle(.plain)

                Button(action: {
                    guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    onSendTap(commentText)
                    commentText = ""
                }) {
                    FontAwesome.icon(.circle_arrow_up, type: .regular, size: 24)
                        .foregroundStyle(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.novoNordiskTextGrey : Color.novoNordiskLightBlue)
                }
                .buttonStyle(.plain)
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    VStack {
        CreateCommentForNewsView(onSendTap: { _ in }, onCancelTap: {})
    }
    .padding(10)
}


