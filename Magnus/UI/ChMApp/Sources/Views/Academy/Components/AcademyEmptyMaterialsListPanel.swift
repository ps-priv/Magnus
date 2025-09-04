import SwiftUI

struct AcademyEmptyMaterialsListPanel: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
          
            // Icon
            FAIcon(.file, type: .light, size: 80, color: .novoNordiskBlue)
                .opacity(0.6)
            
            VStack(spacing: 12) {
                Text(LocalizedStrings.academyEmptyMaterialsListTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStrings.academyEmptyMaterialsListDescription)
                    .font(.body)
                    .foregroundColor(.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}