import SwiftUI

struct TopBarSearchButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            FAIcon(
                .search,
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
        Text("TopBarSearchButton Preview")
            .font(.title2)
            .fontWeight(.bold)
        
    
        TopBarSearchButton{
            
        }
        .background(Color.gray)
    }
}
