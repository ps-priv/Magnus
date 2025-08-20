import SwiftUI

struct PublishButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(LocalizedStrings.publishButton)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            .background(Color.novoNordiskLightBlue)
            .frame(height: 27)
            .cornerRadius(4)
        }
    }
}