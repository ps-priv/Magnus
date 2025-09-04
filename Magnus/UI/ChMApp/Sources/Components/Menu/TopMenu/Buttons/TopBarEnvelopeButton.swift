import SwiftUI

struct TopBarEnvelopeButton: View {
    let action: () -> Void
    let isActive: Bool
    
    init(action: @escaping () -> Void, isActive: Bool = false) {
        self.action = action
        self.isActive = isActive
    }

    var body: some View {
        Button(action: action) {
            FAIcon(
                .email,
                type: .light,
                size: 18,
                color: Color.novoNordiskTextGrey
            )
            .frame(width: 30, height: 30)
        }
        .background(Color.novoNordiskGreyButton)
        .clipShape(Circle())
        .overlay(
            isActive ? Circle()
                .stroke(Color.novoNordiskLightBlue, lineWidth: 1)
                : nil
        )
        .frame(width: 40, height: 40)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("TopBarEnvelopeButton Preview")
            .font(.title2)
            .fontWeight(.bold)
        
    
        TopBarEnvelopeButton(action: {}, isActive: false)
        
        TopBarEnvelopeButton(action: {}, isActive: true)
        .background(Color.gray)
    }
}
