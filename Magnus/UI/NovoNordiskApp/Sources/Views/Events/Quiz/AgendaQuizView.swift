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
    
    private var validAnswers: [QuizAnswer] {
        (questionDetails.answers ?? []).filter { 
            $0.answer != nil && !($0.answer?.isEmpty ?? true)
        }
    }
    
    var body: some View {
        let _ = print("[QuizQuestionView] Rendering question: \(questionDetails.query_id), text: \(questionDetails.query_text)")
        let _ = print("[QuizQuestionView] Question type: \(questionDetails.query_type), answers count: \(questionDetails.answers?.count ?? 0)")
        
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
        if !validAnswers.isEmpty {
            ForEach(validAnswers, id: \.id) { answer in
                Button(action: {
                    selectedAnswers = [answer.id]
                }) {
                    HStack {
                        Image(systemName: selectedAnswers.contains(answer.id) ? "circle.fill" : "circle")
                            .foregroundColor(Color.novoNordiskBlue)
                        
                        Text(answer.answer ?? "")
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
        }
        
        if questionDetails.query_type == .radio_text {
            textAnswerField
        }
    }
    
    @ViewBuilder
    private var checkboxAnswers: some View {
        if !validAnswers.isEmpty {
            ForEach(validAnswers, id: \.id) { answer in
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
                        
                        Text(answer.answer ?? "")
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
        }
        
        if questionDetails.query_type == .checkbox_text {
            textAnswerField
        }
    }
    
    @ViewBuilder
    private var textAnswerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(textFieldLabel)
                .font(.novoNordiskCaption)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            TextEditor(text: $textAnswer)
                .frame(minHeight: 100)
                .padding(12)
                .background(Color(uiColor: .white))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var textFieldLabel: String {
        switch questionDetails.query_type {
        case .radio_text, .checkbox_text:
            return LocalizedStrings.quizJustificationRequired
        case .text:
            return LocalizedStrings.quizYourAnswer
        default:
            return LocalizedStrings.quizYourAnswer
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
    @State private var remainingTime: Int = 0
    @State private var timer: Timer?
    @State private var showSummary: Bool = false
    let agendaId: String

    init(agendaId: String) {
        self.agendaId = agendaId
        _viewModel = StateObject(wrappedValue: AgendaQuizViewModel(agendaId: agendaId))
    }

    var body: some View {
        let _ = print("[AgendaQuizView] body - currentQuestion: \(viewModel.currentQuestionNumber), questionId: \(viewModel.currentQuestionDetails?.query_id ?? "nil"), isLoading: \(viewModel.isLoading), isQuizCompleted: \(viewModel.isQuizCompleted)")
        
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                quizSection
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
        .keyboardAdaptiveMedium()
        .dismissKeyboardOnTap()
        .alert(isPresented: $showValidationError) {
            Alert(
                title: Text(LocalizedStrings.error),
                message: Text(validationErrorMessage),
                dismissButton: .default(Text(LocalizedStrings.ok))
            )
        }
        .onChange(of: viewModel.currentQuestionDetails?.query_id) { _ in
            // Start timer when question changes
            if viewModel.currentQuestionNumber > 0 && !showSummary {
                startTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }

    @ViewBuilder
    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                quizTitle
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if showSummary {
                            let _ = print("[QuizView] Rendering SUMMARY screen - percentage: \(viewModel.quizPercentage)")
                            // Show completion screen
                            QuizSummaryView(
                                percentage: viewModel.quizPercentage,
                                questionsWithAnswers: viewModel.getAllQuestionsWithAnswers(),
                                onClose: {
                                    navigationManager.goBack()
                                }
                            )
                        } else if viewModel.currentQuestionNumber == 0 {
                            let _ = print("[QuizView] Rendering START screen")
                            // Show start screen
                            QuizStartView(totalQuestions: viewModel.totalQuestions)
                        } else if let questionDetails = viewModel.currentQuestionDetails {
                            let _ = print("[QuizView] Rendering QUESTION screen - question \(viewModel.currentQuestionNumber)")
                            // Show current question
                            QuizQuestionView(
                                questionDetails: questionDetails,
                                currentQuestionNumber: viewModel.currentQuestionNumber,
                                totalQuestions: viewModel.totalQuestions,
                                selectedAnswers: $selectedAnswers,
                                textAnswer: $textAnswer
                            )
                            .id(viewModel.currentQuestionNumber)
                        } else {
                            let _ = print("[QuizView] Rendering NOTHING - no condition matched")
                        }
                    }
                    .padding(.vertical, 20)
                }
                
                if !showSummary {
                    // Question counter (only show when on a question, not on start screen)
                    if viewModel.currentQuestionNumber > 0 {
                        questionCounter
                    }
                    
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
            Text(LocalizedStrings.eventQuizScreenTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
            
            Spacer()
            
            // Show timer only when on a question (not start screen or completion)
            if viewModel.currentQuestionNumber > 0 && !viewModel.isQuizCompleted {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(remainingTime <= 10 ? .red : Color.novoNordiskBlue)
                    Text(formatTime(remainingTime))
                        .font(.novoNordiskBody)
                        .fontWeight(.semibold)
                        .foregroundColor(remainingTime <= 10 ? .red : Color.novoNordiskBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    @ViewBuilder
    private var questionCounter: some View {
        HStack {
            Spacer()
            Text("\(viewModel.currentQuestionNumber)/\(viewModel.totalQuestions)")
                .font(.novoNordiskBody)
                .fontWeight(.semibold)
                .foregroundColor(Color.novoNordiskTextGrey)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private var actionButton: some View {
        let isButtonDisabled = viewModel.isLoading || !isValidToSubmit
        
        Button(action: {
            handleNextButtonTap()
        }) {
            Text(viewModel.buttonTitle)
                .font(.novoNordiskBody)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isButtonDisabled ? Color.gray : Color.novoNordiskBlue)
                .cornerRadius(12)
        }
        .disabled(isButtonDisabled)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var isValidToSubmit: Bool {
        // For start screen (question 0), always allow
        if viewModel.currentQuestionNumber == 0 {
            return true
        }
        
        // For questions, check validation
        return viewModel.canProceedToNext(selectedAnswers: selectedAnswers, textAnswer: textAnswer)
    }
    
    private func startTimer() {
        stopTimer()
        
        guard let questionDetails = viewModel.currentQuestionDetails,
              let timeString = questionDetails.query_time else {
            return
        }
        
        // Parse time string (format: "HH:MM:SS" or "MM:SS" or "SS")
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        
        if components.count == 3 {
            // HH:MM:SS
            remainingTime = components[0] * 3600 + components[1] * 60 + components[2]
        } else if components.count == 2 {
            // MM:SS
            remainingTime = components[0] * 60 + components[1]
        } else if components.count == 1 {
            // SS
            remainingTime = components[0]
        } else {
            remainingTime = 0
        }
        
        print("[QuizView] Starting timer with \(remainingTime) seconds")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                print("[QuizView] Timer expired - auto-advancing to next question")
                stopTimer()
                handleTimeExpired()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func handleTimeExpired() {
        // Auto-submit empty answer and move to next question
        Task {
            await viewModel.handleNextButton()
            selectedAnswers.removeAll()
            textAnswer = ""
        }
    }
    
    private func handleNextButtonTap() {
        print("[QuizView] handleNextButtonTap - currentQuestion: \(viewModel.currentQuestionNumber)")
        
        stopTimer()
        
        // If we're on a question (not start screen), validate and save answer
        if viewModel.currentQuestionNumber > 0 {
            // Check if answer is valid
            if !viewModel.canProceedToNext(selectedAnswers: selectedAnswers, textAnswer: textAnswer) {
                print("[QuizView] Validation failed - no answer selected")
                showValidationError = true
                validationErrorMessage = LocalizedStrings.surveyValidationNoAnswer
                startTimer() // Restart timer if validation fails
                return
            }
            
            print("[QuizView] Submitting answer and moving to next")
            print("[QuizView] Current question: \(viewModel.currentQuestionNumber)/\(viewModel.totalQuestions)")
            // Save answer and proceed
            Task {
                let success = await viewModel.submitAnswer(selectedAnswers: selectedAnswers, textAnswer: textAnswer)
                
                if success {
                    print("[QuizView] Answer submitted successfully")
                    print("[QuizView] isQuizCompleted: \(viewModel.isQuizCompleted)")
                    
                    // Clear current answers
                    selectedAnswers.removeAll()
                    textAnswer = ""
                    
                    // If not completed (not last question), move to next question
                    if !viewModel.isQuizCompleted {
                        print("[QuizView] Moving to next question")
                        await viewModel.handleNextButton()
                    } else {
                        print("[QuizView] Quiz completed - showing summary")
                        showSummary = true
                        print("[QuizView] showSummary set to true")
                    }
                } else {
                    print("[QuizView] Answer submission failed")
                    showValidationError = true
                    validationErrorMessage = viewModel.errorMessage
                    startTimer() // Restart timer if submission fails
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