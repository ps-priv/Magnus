import SwiftUI

struct EventDetailsNotFound: View {
 
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
          
            // Icon
            FAIcon(.newspaper, type: .light, size: 80, color: .novoNordiskBlue)
                .opacity(0.6)
            
            VStack(spacing: 12) {
                Text(LocalizedStrings.eventDetailsNotFoundTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStrings.eventDetailsNotFoundMessage)
                    .font(.body)
                    .foregroundColor(.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // // Retry button
            // NovoNordiskButton(
            //     title: LocalizedStrings.noInternetConnectionRetryButton,
            //     style: .primary
            // ) {
            //     onRetry()
            // }
            // .padding(.horizontal, 32)
            // .padding(.bottom, 32)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview("EventDetailsNotFound") {
    EventDetailsNotFound()
}