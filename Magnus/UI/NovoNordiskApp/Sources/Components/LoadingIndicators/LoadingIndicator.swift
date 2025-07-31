import Foundation
import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(2.5)
                .tint(Color("NovoNordiskBlue"))
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    LoadingIndicator()
}
