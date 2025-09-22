import SwiftUI
import MagnusApplication

struct EventSurveyBefore: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {

            Text(LocalizedStrings.surveyBeforeTitle)
                .font(.novoNordiskHeadline)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            FAIcon(.clock, type: .light, size: 140, color: .novoNordiskBlue)
            
            Text(LocalizedStrings.surveyBeforeDescription)
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
    EventSurveyBefore()
}