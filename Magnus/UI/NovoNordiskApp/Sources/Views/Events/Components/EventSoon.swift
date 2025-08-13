import SwiftUI

struct EventSoonView: View {
    var body: some View {
        HStack {
            Text(LocalizedStrings.eventSoon)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
        }
        .background(Color.novoNordiskOrangeRed)
        .cornerRadius(10)
    }
}