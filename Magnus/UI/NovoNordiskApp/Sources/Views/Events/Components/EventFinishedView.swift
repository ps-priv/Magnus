import SwiftUI

struct EventFinishedView: View {
    var body: some View {
        HStack {
            Text(LocalizedStrings.eventFinished)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
        }
        .background(Color.novoNordiskBlue)
        .cornerRadius(10)
    }
}