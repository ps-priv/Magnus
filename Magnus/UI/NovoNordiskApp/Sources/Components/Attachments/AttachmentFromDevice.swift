import SwiftUI

struct AttachmentFromDevice: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                FAIcon(.paperclip, type: .light, size: 15, color: .white)
                Text(LocalizedStrings.attachmentFromDevice)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .frame(height:  40)
            .background(Color.novoNordiskBlue)
            .cornerRadius(8)
        }
    }
}
