import Foundation
import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(2.5)
                .tint(Color("NovoNordiskBlue"))
                .padding(.bottom, 20)
            Text(LocalizedStrings.loading)
                .font(.novoNordiskHeadline)
                .foregroundColor(Color.novoNordiskBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingIndicator()
}
