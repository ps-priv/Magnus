import SwiftUI

struct EventPhotosNotFound: View {
 
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
          
            // Icon
            FAIcon(.image, type: .light, size: 80, color: .novoNordiskBlue)
                .opacity(0.6)
            
            VStack(spacing: 12) {
                Text(LocalizedStrings.eventPhotosNotFoundTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStrings.eventPhotosNotFoundMessage)
                    .font(.body)
                    .foregroundColor(.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview("EventPhotosNotFound") {
    EventPhotosNotFound()
}