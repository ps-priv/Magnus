import SwiftUI

struct FinishedEventIndicatorView: View {
    var body: some View {
        HStack {
            Text(LocalizedStrings.finishedEvent)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
        }
        .background(Color.novoNordiskBlue)
        .cornerRadius(10)
    }
}
