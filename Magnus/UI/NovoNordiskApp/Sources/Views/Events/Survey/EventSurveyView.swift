import MagnusFeatures
import SwiftUI

struct EventSurveyView: View {

    @StateObject private var viewModel: EventSurveyViewModel
    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventSurveyViewModel(eventId: eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                surveySection
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }

    @ViewBuilder
    private var surveySection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                surveyTitle
                surveyContent
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
    private var surveyTitle: some View {
        HStack {
            HStack {
                Text(LocalizedStrings.eventSurveyScreenTitle)
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

    @ViewBuilder
    private var surveyContent: some View {
        VStack(alignment: .leading) {
            switch viewModel.currentQuestionNumber {
            case 0:
                EventSurveyStart()
            default:
                EmptyView()
            }
            Spacer()
            NovoNordiskButton(
                title: viewModel.buttonTitle,
                style: .primary,
            ) {
                Task {
                    await viewModel.nextQuestion()
                }
            }
            //.disabled(!viewModel.canLogin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
