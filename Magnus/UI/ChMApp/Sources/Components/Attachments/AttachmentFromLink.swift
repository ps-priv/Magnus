import SwiftUI

struct AttachmentFromLink: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                FAIcon(.link, type: .light, size: 15, color: .white)
                Text(LocalizedStrings.attachmentFromLink)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .frame(height: 40)
            .background(Color.novoNordiskBlue)
            .cornerRadius(8)
        }
    }
}