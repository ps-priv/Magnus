import MagnusFeatures
import MagnusDomain
import SwiftUI

// MARK: - Quiz Question Component
private struct QuizQuestionView: View {
    let questionDetails: QuizQueryAnswerResponse
    let currentQuestionNumber: Int
    let totalQuestions: Int
    @Binding var selectedAnswers: Set<String>
    @Binding var textAnswer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {            
            // Question text
            Text(questionDetails.query_text)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.novoNordiskBlue)
                .padding(.horizontal, 20)
            
            // Answer options based on question type
            ScrollView {
                VStack(spacing: 12) {
                    switch questionDetails.query_type {
                    case .radio, .radio_text:
                        radioAnswers
                    case .checkbox, .checkbox_text:
                        checkboxAnswers
                    case .text:
                        textAnswerField
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    private var radioAnswers: some View {
        ForEach(questionDetails.answers, id: \.id) { answer in
            Button(action: {
                selectedAnswers = [answer.id]
            }) {
                HStack {
                    Image(systemName: selectedAnswers.contains(answer.id) ? "circle.fill" : "circle")
                        .foregroundColor(Color.novoNordiskBlue)
                    
                    Text(answer.answer)
                        .font(.novoNordiskBody)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedAnswers.contains(answer.id) ? Color.novoNordiskBlue.opacity(0.1) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedAnswers.contains(answer.id) ? Color.novoNordiskBlue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        
        if questionDetails.query_type == .radio_text {
            textAnswerField
        }
    }
    
    @ViewBuilder
    private var checkboxAnswers: some View {
        ForEach(questionDetails.answers, id: \.id) { answer in
            Button(action: {
                if selectedAnswers.contains(answer.id) {
                    selectedAnswers.remove(answer.id)
                } else {
                    selectedAnswers.insert(answer.id)
                }
            }) {
                HStack {
                    Image(systemName: selectedAnswers.contains(answer.id) ? "checkmark.square.fill" : "square")
                        .foregroundColor(Color.novoNordiskBlue)
                    
                    Text(answer.answer)
                        .font(.novoNordiskBody)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedAnswers.contains(answer.id) ? Color.novoNordiskBlue.opacity(0.1) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedAnswers.contains(answer.id) ? Color.novoNordiskBlue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        
        if questionDetails.query_type == .checkbox_text {
            textAnswerField
        }
    }
    
    @ViewBuilder
    private var textAnswerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.quizYourAnswer)
                .font(.novoNordiskCaption)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            TextEditor(text: $textAnswer)
                .frame(minHeight: 100)
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Main Quiz View
struct AgendaQuizView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: AgendaQuizViewModel
    @State private var selectedAnswers: Set<String> = []
    @State private var textAnswer: String = ""
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
        .alert(isPresented: $showValidationError) {
            Alert(
                title: Text(LocalizedStrings.error),
                message: Text(validationErrorMessage),
                dismissButton: .default(Text(LocalizedStrings.ok))
            )
        }
    }

    @ViewBuilder
    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                quizTitle
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if viewModel.currentQuestionNumber == 0 {
                            // Show start screen
                            QuizStartView(totalQuestions: viewModel.totalQuestions)
                        } else if viewModel.isQuizCompleted {
                            // Show completion screen
                            QuizSummaryView()
                        } else if let questionDetails = viewModel.currentQuestionDetails {
                            // Show current question
                            QuizQuestionView(
                                questionDetails: questionDetails,
                                currentQuestionNumber: viewModel.currentQuestionNumber,
                                totalQuestions: viewModel.totalQuestions,
                                selectedAnswers: $selectedAnswers,
                                textAnswer: $textAnswer
                            )
                        }
                    }
                    .padding(.vertical, 20)
                }
                
                if !viewModel.isQuizCompleted {
                    actionButton
                }
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
    
    @ViewBuilder
    private var actionButton: some View {
        Button(action: {
            handleNextButtonTap()
        }) {
            Text(viewModel.buttonTitle)
                .font(.novoNordiskBody)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.novoNordiskBlue)
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func handleNextButtonTap() {
        print("[QuizView] handleNextButtonTap - currentQuestion: \(viewModel.currentQuestionNumber)")
        
        // If we're on a question (not start screen), validate and save answer
        if viewModel.currentQuestionNumber > 0 {
            // Check if answer is valid
            if !viewModel.canProceedToNext(selectedAnswers: selectedAnswers, textAnswer: textAnswer) {
                print("[QuizView] Validation failed - no answer selected")
                showValidationError = true
                validationErrorMessage = LocalizedStrings.surveyValidationNoAnswer
                return
            }
            
            print("[QuizView] Submitting answer and moving to next")
            // Save answer and proceed
            Task {
                let success = await viewModel.submitAnswer(selectedAnswers: selectedAnswers, textAnswer: textAnswer)
                
                if success {
                    print("[QuizView] Answer submitted successfully")
                    // Clear current answers for next question
                    selectedAnswers.removeAll()
                    textAnswer = ""
                    
                    // Move to next question
                    await viewModel.handleNextButton()
                } else {
                    print("[QuizView] Answer submission failed")
                    showValidationError = true
                    validationErrorMessage = viewModel.errorMessage
                }
            }
        } else {
            print("[QuizView] Starting quiz")
            // Just start the quiz
            Task {
                await viewModel.handleNextButton()
            }
        }
    }
}