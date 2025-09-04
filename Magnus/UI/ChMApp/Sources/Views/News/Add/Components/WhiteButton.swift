import SwiftUI

struct WhiteButton: View {
    var action: () -> Void
    var title: String
    var isDisabled: Bool
    
    init(title: String, action: @escaping () -> Void, isDisabled: Bool = false) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
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
            .background(isDisabled ? Color.gray : Color.white)
            .frame(height: 27)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isDisabled ? Color.gray : Color.novoNordiskTextGrey, lineWidth: 1)
            )
            .cornerRadius(4)
            .disabled(isDisabled)
        }
    }
}