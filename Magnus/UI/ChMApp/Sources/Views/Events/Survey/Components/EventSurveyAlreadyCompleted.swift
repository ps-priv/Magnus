import MagnusApplication
import SwiftUI

struct EventSurveyAlreadyCompleted: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {

            Text(LocalizedStrings.surveyAlreadyCompletedTitle)
                .font(.novoNordiskHeadline)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            FAIcon(.circle_check, type: .light, size: 140, color: .novoNordiskBlue)
            
            Text(LocalizedStrings.surveyAlreadyCompletedDescription)
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
    EventSurveyAlreadyCompleted()
}
