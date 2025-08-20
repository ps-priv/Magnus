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
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
            }
            .padding(.horizontal, 20)
            .background(Color.novoNordiskBlue)
            .frame(height: 27)
            .cornerRadius(4)
        }
    }
}