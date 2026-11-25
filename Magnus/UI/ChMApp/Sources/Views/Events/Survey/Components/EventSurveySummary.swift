import MagnusApplication
import SwiftUI

struct EventSurveySummary: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {

            Text(LocalizedStrings.surveyThankYouTitle)
                .font(.novoNordiskTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            Text(LocalizedStrings.surveyThankYouMessage)
                .font(.novoNordiskHeadline)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            FAIcon(.circle_check, type: .light, size: 140, color: .novoNordiskBlue)
            
            Text(LocalizedStrings.surveyCompletionInfo)
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
    VStack(alignment: .leading) {
        EventSurveySummary()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}