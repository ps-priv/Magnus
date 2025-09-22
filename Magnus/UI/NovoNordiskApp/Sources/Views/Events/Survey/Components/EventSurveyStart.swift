import MagnusApplication
import SwiftUI

struct EventSurveyStart: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStrings.surveyStartTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .padding(.bottom, 10)

            Text(LocalizedStrings.surveyStartDescription)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)
                .padding(.bottom, 10)

            Text(LocalizedStrings.surveyTimeInfo)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)

            Text(LocalizedStrings.surveyTime)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        EventSurveyStart()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
