import SwiftUI

struct TopBarEnvelopeButton: View {
    let action: () -> Void

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
        //.frame(width: 40, height: 40)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("TopBarEnvelopeButton Preview")
            .font(.title2)
            .fontWeight(.bold)
        
    
        TopBarEnvelopeButton{
            
        }
        .background(Color.gray)
    }
}
