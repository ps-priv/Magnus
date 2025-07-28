import SwiftUI

struct EventInProgressView: View {
    var body: some View {
        HStack {
            Text(LocalizedStrings.eventInProgress)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
        }
        .background(Color.novoNordiskLightBlue)
        .cornerRadius(10)
    }
}
