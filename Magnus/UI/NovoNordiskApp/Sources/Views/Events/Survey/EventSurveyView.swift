import MagnusFeatures
import MagnusDomain
import SwiftUI

struct EventSurveyView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: EventSurveyViewModel
    @State private var currentAnswer: SurveyAnswerData?
    @State private var showValidationError: Bool = false
    @State private var validationErrorMessage: String = ""
    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventSurveyViewModel(eventId: eventId))
    }
    
    private func validateCurrentAnswer() -> Bool {
        guard let questionDetails = viewModel.currentQuestionDetails else { return true }
        guard let answer = currentAnswer else {
            validationErrorMessage = LocalizedStrings.surveyValidationNoAnswer
            showValidationError = true
            return false
        }
        
        switch questionDetails.query_type {
        case .open:
            if answer.openAnswer?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false {
                validationErrorMessage = LocalizedStrings.surveyValidationEmptyAnswer
                showValidationError = true
                return false
            }
        case .single_choice, .multiple_choice:
            if answer.selectedAnswers.isEmpty {
                validationErrorMessage = LocalizedStrings.surveyValidationNoSelection
                showValidationError = true
                return false
            }
        }
        
        showValidationError = false
        return true
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
            if viewModel.hasError {
                EventSurveyError()
            } else if viewModel.isSurveyCompleted {
                EventSurveySummary()
            } else {
                switch viewModel.currentQuestionNumber {
                case 0:
                    EventSurveyStart(surveyStatus: viewModel.getSurveyStatus())
                default:
                    if let questionDetails = viewModel.currentQuestionDetails {
                        EventSurveyQuestion(questionDetails: questionDetails) { answerData in
                            currentAnswer = answerData
                            // Clear validation error when user provides an answer
                            if showValidationError {
                                showValidationError = false
                            }
                        }
                    }
                }
            }
            
            // Validation error message
            if showValidationError {
                Text(validationErrorMessage)
                    .font(.novoNordiskCaption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 0)
                    .padding(.top, 8)
            }
            
            Spacer()

            if viewModel.getSurveyStatus() == .before {
                NovoNordiskButton(
                    title: LocalizedStrings.surveyBackToEventButton,
                    style: .primary,
                ) {
                    navigationManager.navigateToEventDetail(eventId: viewModel.eventId) 
                }
            } else if viewModel.getSurveyStatus() == .after {
                NovoNordiskButton(
                    title: LocalizedStrings.surveyBackToEventButton,
                    style: .primary,
                ) {
                    navigationManager.navigateToEventDetail(eventId: viewModel.eventId) 
                }
            } 
            else if viewModel.getSurveyStatus() == .completed {
                NovoNordiskButton(
                    title: LocalizedStrings.surveyBackToEventButton,
                    style: .primary,
                ) {
                    navigationManager.navigateToEventDetail(eventId: viewModel.eventId) 
                }
            } 
            else
            if viewModel.hasError {
                NovoNordiskButton(
                    title: LocalizedStrings.tryAgainButton,
                    style: .primary,
                ) {
                    Task {
                        await viewModel.loadData()
                    }
                }
            } else if !viewModel.isSurveyCompleted {
                NovoNordiskButton(
                    title: viewModel.buttonTitle,
                    style: .primary,
                ) {
                    // For start screen, no validation needed
                    if viewModel.currentQuestionNumber == 0 {
                        Task {
                            await viewModel.nextQuestion()
                            currentAnswer = nil
                        }
                    } else {
                        // Validate answer before proceeding
                        if validateCurrentAnswer() {
                            Task {
                                let featuresAnswerData = currentAnswer.map { answer in
                                    MagnusFeatures.SurveyAnswerData(
                                        questionId: answer.questionId,
                                        questionType: answer.questionType,
                                        selectedAnswers: answer.selectedAnswers,
                                        openAnswer: answer.openAnswer
                                    )
                                }
                                await viewModel.nextQuestion(with: featuresAnswerData)
                                currentAnswer = nil // Clear the answer for the next question
                            }
                        }
                    }
                }
            } else {
                NovoNordiskButton(
                    title: LocalizedStrings.surveyCompleteButton,
                    style: .primary,
                ) {
                    navigationManager.navigateToEventDetail(eventId: viewModel.eventId) 
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
