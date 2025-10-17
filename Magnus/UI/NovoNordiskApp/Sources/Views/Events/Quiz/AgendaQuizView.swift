import MagnusFeatures
import MagnusDomain
import SwiftUI

struct AgendaQuizView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: AgendaQuizViewModel
    // @State private var currentAnswer: SurveyAnswerData?
    @State private var showValidationError: Bool = false
    @State private var validationErrorMessage: String = ""
    let agendaId: String

    init(agendaId: String) {
        self.agendaId = agendaId
        _viewModel = StateObject(wrappedValue: AgendaQuizViewModel(agendaId: agendaId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                quizSection
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }

    @ViewBuilder
    private var quizSection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                quizTitle
                //quizContent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private var quizTitle: some View {
        HStack {
            HStack {
                Text(LocalizedStrings.eventQuizScreenTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Spacer()
        }
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}