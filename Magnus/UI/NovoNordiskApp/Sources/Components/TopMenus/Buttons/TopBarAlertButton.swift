import SwiftUI

struct TopBarAlertButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            FAIcon(
                .bell,
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
        Text("TopBarAlertButton Preview")
            .font(.title2)
            .fontWeight(.bold)
        
    
        TopBarAlertButton{
            
        }
        .background(Color.gray)
    }
}

#Preview("TopBar") {
    VStack {
        RoundedTopBar(title: "Sample Title")
        Spacer()
    }
}
