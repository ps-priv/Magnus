import MagnusApplication
import MagnusDomain
import SwiftUI

struct EventSurveyStart: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @State private var surveyStatus: SurveyStatusEnum

    init(surveyStatus: SurveyStatusEnum) {
        _surveyStatus = State(initialValue: surveyStatus)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if surveyStatus == .in_progress {
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
            else if surveyStatus == .before {
                EventSurveyBefore()
            } 
            else if surveyStatus == .completed {
                EventSurveyAlreadyCompleted()
            }
            else {
                EventSurveyAfter()
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        EventSurveyStart(surveyStatus: .before)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
