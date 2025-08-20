import SwiftUI

struct WhiteButton: View {
    var action: () -> Void
    var title: String
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(title)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            .background(Color.white)
            .frame(height: 27)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.novoNordiskTextGrey, lineWidth: 1)
            )

            .cornerRadius(4)
        }
    }
}