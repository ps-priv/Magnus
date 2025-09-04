
import SwiftUI

struct EventDetailErrorMessageView: View {
    let errorMessage: String
    let errorTitle: String

    init(errorMessage: String, errorTitle: String) {
        self.errorMessage = errorMessage
        self.errorTitle = errorTitle
    }
 
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
          
            // Icon
            FAIcon(.newspaper, type: .light, size: 80, color: .novoNordiskBlue)
                .opacity(0.6)
            
            VStack(spacing: 12) {
                Text(errorTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(errorMessage)
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