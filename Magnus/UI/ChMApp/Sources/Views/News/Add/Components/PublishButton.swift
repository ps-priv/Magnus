import SwiftUI

struct PublishButton: View {
    var action: () -> Void
    var isDisabled: Bool = false

    init(action: @escaping () -> Void, isDisabled: Bool = false) {
        self.action = action
        self.isDisabled = isDisabled
    }
    
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
            .background(isDisabled ? Color.gray : Color.novoNordiskLightBlue)
            .frame(height: 27)
            .cornerRadius(4)
        }
        .disabled(isDisabled)
    }
}