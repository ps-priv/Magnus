import SwiftUI

struct PrivacyPolicyView: View {    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Privacy Policy")
                .font(.system(size: 24))
                .foregroundColor(Color.novoNordiskTextGrey)

            Text(LargeTextMock.getText())
                .font(.system(size: 14))
                .foregroundColor(Color.novoNordiskTextGrey)
                .opacity(0.6)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.novoNordiskLighGreyForPanelBackground)

    }   
}

