import SwiftUI
import MagnusFeatures

struct NoInternetConnectionView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon
            FAIcon(.wifi, type: .light, size: 80, color: .novoNordiskBlue)
                .opacity(0.6)
            
            // Title and message
            VStack(spacing: 12) {
                Text(LocalizedStrings.noInternetConnectionTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStrings.noInternetConnectionMessage)
                    .font(.body)
                    .foregroundColor(.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Retry button
            NovoNordiskButton(
                title: LocalizedStrings.noInternetConnectionRetryButton,
                style: .primary
            ) {
                onRetry()
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview {
    NoInternetConnectionView {
        print("Retry tapped")
    }
}