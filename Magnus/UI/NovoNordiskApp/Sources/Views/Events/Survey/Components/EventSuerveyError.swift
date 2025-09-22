import MagnusApplication
import SwiftUI

struct EventSurveyError: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {

            Text(LocalizedStrings.surveyErrorTitle)
                .font(.novoNordiskTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            FAIcon(.circle_error, type: .light, size: 140, color: .novoNordiskBlue)
            
            Text(LocalizedStrings.surveyErrorInfo)
                .font(.novoNordiskCaption)  
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    EventSurveyError()
}
