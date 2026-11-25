import SwiftUI

struct DeleteButton: View {
    var action: () -> Void
    
    var body: some View {
        HStack {    
            Text(LocalizedStrings.deleteButton)
                .font(.novoNordiskMiddleText)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
        }
        .background(Color.novoNordiskOrangeRed)
        .frame(height: 27)
        .cornerRadius(4)
        .onTapGesture {
            action()
        }
        // Button(action: {
        //     action()
        // }) {
        //     HStack {
        //         Text(LocalizedStrings.deleteButton)
        //             .font(.novoNordiskMiddleText)
        //             .foregroundColor(.white)
        //             .padding(.horizontal, 15)
        //             .padding(.vertical, 5)
        //     }
        //     .background(Color.novoNordiskOrangeRed)
        //     .frame(height: 27)
        //     .cornerRadius(4)
        // }
    }
}