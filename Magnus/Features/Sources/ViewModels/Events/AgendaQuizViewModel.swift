import MagnusDomain
import Foundation   
import Combine

@MainActor
public class AgendaQuizViewModel: ObservableObject {

    private let quizService: QuizService

    @Published public var agendaId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var quiz: QuizForEvent?
    
    @Published public var currentQuestionDetails: QuizQueryAnswerResponse?
    @Published public var currentQuestionNumber: Int = 0
    
    // Store all question details
    private var allQuestionDetails: [String: QuizQueryAnswerResponse] = [:] // [queryId: details]
    @Published public var isQuizCompleted: Bool = false
    @Published public var buttonTitle: String = FeaturesLocalizedStrings.quizStartButton
    
    // Store user answers: [queryId: [answerIds]]
    private var userAnswers: [String: [String]] = [:]
    // Store text answers: [queryId: textAnswer]
    private var userTextAnswers: [String: String] = [:]
    
    // Quiz statistics
    @Published public var totalCorrectAnswers: Int = 0
    @Published public var userCorrectAnswers: Int = 0
    @Published public var quizPercentage: Double = 0.0
    
    // Sequential quiz support
    @Published public var isWaitingForQuestion: Bool = false
    @Published public var isAllQuestionsAnswered: Bool = false
    private var pollingTimer: Timer?
    private var currentPollingQueryId: String?
    
    // Current answer tracking (for auto-submit on question change)
    private var currentSelectedAnswers: Set<String> = []
    private var currentTextAnswer: String = ""
    private var questionStartTime: Date?

    public init(agendaId: String, 
        quizService: QuizService = DIContainer.shared.quizService) {
        self.agendaId = agendaId
        self.quizService = quizService

        Task {
            await loadData()
        }
    }
    
    public func cleanup() {
        stopPolling()
    }
    
    public func loadData() async {
        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await quizService.getQuizForAgenda(agendaId: agendaId)

            await MainActor.run {
                quiz = data
                isLoading = false
            }
            
            // Check if all questions are already answered
            await checkIfAllQuestionsAnswered()
        } catch let error {
            await MainActor.run {
                errorMessage = error.localizedDescription
                hasError = true
                isLoading = false
            }
        }
    }
    
    private func checkIfAllQuestionsAnswered() async {
        guard let quiz = quiz else { return }
        
        print("[Quiz] Checking if all questions are answered...")
        
        // Load details for all questions
        var allAnswered = true
        for query in quiz.queries {
            if let details = await loadQuestionDetailsIfNeeded(queryId: query.id, forceReload: true) {
                print("[Quiz] Question \(query.id) status: \(details.status)")
                if details.status != .answered {
                    allAnswered = false
                }
            } else {
                // If we can't load details, assume not answered
                allAnswered = false
            }
        }
        
        await MainActor.run {
            isAllQuestionsAnswered = allAnswered
            print("[Quiz] All questions answered: \(allAnswered)")
        }
    }
    
    private func loadQuestionDetailsIfNeeded(queryId: String, forceReload: Bool = false) async -> QuizQueryAnswerResponse? {
        // Check if already loaded (skip cache for sequential quiz polling)
        if !forceReload, let cached = allQuestionDetails[queryId] {
            print("[Quiz] Using cached details for query: \(queryId)")
            return cached
        }
        
        // Load from service
        do {
            print("[Quiz] Loading details for query: \(queryId)")
            let details = try await quizService.getQuizQueryDetails(queryId: queryId)
            print("[Quiz] Loaded details: \(details.query_text), status: \(details.status)")
            print("[Quiz] Question type: \(details.query_type), answers count: \(details.answers?.count ?? 0)")
            allQuestionDetails[queryId] = details
            return details
        } catch {
            print("[Quiz] Failed to load details for query \(queryId): \(error.localizedDescription)")
            return nil
        }
    }
    
    private func startPolling(queryId: String) {
        print("[Quiz] Starting polling for query: \(queryId)")
        stopPolling()
        currentPollingQueryId = queryId
        
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.pollQuestionStatus()
            }
        }
    }
    
    private func stopPolling() {
        print("[Quiz] Stopping polling")
        pollingTimer?.invalidate()
        pollingTimer = nil
        currentPollingQueryId = nil
    }
    
    private func pollQuestionStatus() async {
        guard let queryId = currentPollingQueryId else { return }
        print("[Quiz] Polling status for query: \(queryId)")
        
        if let details = await loadQuestionDetailsIfNeeded(queryId: queryId, forceReload: true) {
            await handleQuestionStatus(details: details)
        }
    }
    
    private func handleQuestionStatus(details: QuizQueryAnswerResponse) async {
        print("[Quiz] Handling question status: \(details.status) for query: \(details.query_id)")
        
        switch details.status {
        case .before:
            // Status = 1: Wait for question
            await MainActor.run {
                isWaitingForQuestion = true
                currentQuestionDetails = details
            }
            // Continue polling
            
        case .active:
            // Status = 2: Show question and allow answering
            stopPolling()
            await MainActor.run {
                isWaitingForQuestion = false
                currentQuestionDetails = details
            }
            // Start timer when question becomes active
            startQuestionTimer()
            
        case .after, .answered:
            // Status = 3 or 4: Move to next question
            stopPolling()
            await MainActor.run {
                isWaitingForQuestion = false
            }
            await moveToNextQuestion()
        }
    }
    
    public func moveToNextQuestionAfterSubmit() async {
        // Move to next question without submitting (answer already submitted)
        await moveToNextQuestionInternal()
    }
    
    private func moveToNextQuestion() async {
        // Submit current answer before moving to next question
        await submitCurrentAnswerIfNeeded()
        await moveToNextQuestionInternal()
    }
    
    private func moveToNextQuestionInternal() async {
        
        guard let quiz = quiz else { return }
        let nextQuestionNumber = currentQuestionNumber + 1
        
        if nextQuestionNumber <= quiz.queries.count {
            let queryIndex = nextQuestionNumber - 1
            let query = quiz.queries[queryIndex]
            print("[Quiz] Moving to next question \(nextQuestionNumber), queryId: \(query.id)")
            
            await MainActor.run {
                currentQuestionNumber = nextQuestionNumber
                if currentQuestionNumber == quiz.queries.count {
                    buttonTitle = FeaturesLocalizedStrings.quizCompleteButton
                }
            }
            
            // Load next question and check its status
            await loadAndHandleQuestion(queryId: query.id)
        } else {
            // Complete quiz
            await MainActor.run {
                isQuizCompleted = true
            }
        }
    }
    
    public func submitCurrentAnswerIfNeeded() async {
        print("[Quiz] submitCurrentAnswerIfNeeded called")
        print("[Quiz] - currentQuestionDetails: \(currentQuestionDetails?.query_id ?? "nil")")
        print("[Quiz] - currentQuestionNumber: \(currentQuestionNumber)")
        print("[Quiz] - currentSelectedAnswers: \(currentSelectedAnswers)")
        print("[Quiz] - currentTextAnswer: '\(currentTextAnswer)'")
        
        // Only submit if we have a current question
        guard let questionDetails = currentQuestionDetails,
              currentQuestionNumber > 0 else {
            print("[Quiz] ❌ No current question to submit answer for")
            return
        }
        
        let hasAnswer = !currentSelectedAnswers.isEmpty || !currentTextAnswer.isEmpty
        print("[Quiz] ✅ Auto-submitting answer for question \(currentQuestionNumber) before moving to next (hasAnswer: \(hasAnswer))")
        
        // Calculate time spent on this question
        let timeSpent = calculateTimeSpent()
        print("[Quiz] Time spent on question: \(timeSpent) seconds")
        
        // Save and submit the answer
        var answerIds = Array(currentSelectedAnswers)
        
        // For text-only questions (type = 5), add first answer ID
        if questionDetails.query_type == .text,
           let firstAnswerId = questionDetails.answers?.first?.id {
            answerIds = [firstAnswerId]
            print("[Quiz] Text question - using first answer ID: \(firstAnswerId)")
        }
        
        saveAnswer(queryId: questionDetails.query_id, answerIds: answerIds, textAnswer: currentTextAnswer)
        
        let request = QuizUserAnswerRequest(
            query_id: questionDetails.query_id,
            query_time_left: timeSpent,
            answers_id: answerIds,
            answer_text: currentTextAnswer.isEmpty ? nil : currentTextAnswer
        )
        
        do {
            try await quizService.submitAnswers(answers: request)
            print("[Quiz] Successfully auto-submitted answer for query \(questionDetails.query_id)")
        } catch {
            print("[Quiz] ERROR auto-submitting answer: \(error.localizedDescription)")
            // Don't block progression on error
        }
        
        // Clear current answers and reset timer
        currentSelectedAnswers.removeAll()
        currentTextAnswer = ""
        questionStartTime = nil
    }
    
    // Update current answers (called from view)
    public func updateCurrentAnswers(selectedAnswers: Set<String>, textAnswer: String) {
        print("[ViewModel] updateCurrentAnswers called")
        print("[ViewModel] - selectedAnswers: \(selectedAnswers)")
        print("[ViewModel] - textAnswer: '\(textAnswer)'")
        currentSelectedAnswers = selectedAnswers
        currentTextAnswer = textAnswer
        print("[ViewModel] - currentSelectedAnswers updated to: \(currentSelectedAnswers)")
        print("[ViewModel] - currentTextAnswer updated to: '\(currentTextAnswer)'")
    }
    
    // Start timing for current question
    public func startQuestionTimer() {
        questionStartTime = Date()
        print("[Quiz] Started timer for question \(currentQuestionNumber)")
    }
    
    // Calculate time spent on current question (in seconds)
    private func calculateTimeSpent() -> Int {
        guard let startTime = questionStartTime else {
            return 0
        }
        let timeSpent = Int(Date().timeIntervalSince(startTime))
        return timeSpent
    }
    
    private func loadAndHandleQuestion(queryId: String) async {
        await MainActor.run {
            isLoading = true
        }
        
        if let details = await loadQuestionDetailsIfNeeded(queryId: queryId, forceReload: isSequentialQuiz) {
            await MainActor.run {
                isLoading = false
            }
            
            if isSequentialQuiz {
                await handleQuestionStatus(details: details)
                if details.status == .before {
                    startPolling(queryId: queryId)
                } else if details.status == .active {
                    // Start timer for active question
                    startQuestionTimer()
                }
            } else {
                // Regular quiz - just show the question
                await MainActor.run {
                    currentQuestionDetails = details
                }
                // Start timer for regular quiz
                startQuestionTimer()
            }
        } else {
            await MainActor.run {
                errorMessage = "Failed to load question details"
                hasError = true
                isLoading = false
            }
        }
    }
    
    private var isSequentialQuiz: Bool {
        return quiz?.sequential == .sequential
    }
    
    public func handleNextButton() async {
        guard let quiz = quiz else { return }
        print("[Quiz] handleNextButton - current: \(currentQuestionNumber), total: \(quiz.queries.count)")
        
        if currentQuestionNumber == 0 {
            // Start quiz - load first question
            if let firstQuery = quiz.queries.first {
                print("[Quiz] Starting quiz, loading first question: \(firstQuery.id)")
                
                await MainActor.run {
                    currentQuestionNumber = 1
                    buttonTitle = FeaturesLocalizedStrings.quizNextButton
                }
                
                await loadAndHandleQuestion(queryId: firstQuery.id)
            } else {
                print("[Quiz] Failed to start quiz - no questions available")
            }
        } else if currentQuestionNumber <= quiz.queries.count {
            // Submit current answer before moving
            await submitCurrentAnswerIfNeeded()
            
            // Move to next question or complete
            let nextQuestionNumber = currentQuestionNumber + 1
            
            if nextQuestionNumber <= quiz.queries.count {
                // Load next question
                let queryIndex = nextQuestionNumber - 1
                let query = quiz.queries[queryIndex]
                print("[Quiz] Moving to question \(nextQuestionNumber), queryId: \(query.id)")
                
                await MainActor.run {
                    currentQuestionNumber = nextQuestionNumber
                    if currentQuestionNumber == quiz.queries.count {
                        buttonTitle = FeaturesLocalizedStrings.quizCompleteButton
                    }
                }
                
                await loadAndHandleQuestion(queryId: query.id)
            } else {
                // Complete quiz
                await MainActor.run {
                    isQuizCompleted = true
                }
            }
        }
    }
    
    public var totalQuestions: Int {
        return quiz?.queries.count ?? 0
    }
    
    public func saveAnswer(queryId: String, answerIds: [String], textAnswer: String = "") {
        userAnswers[queryId] = answerIds
        if !textAnswer.isEmpty {
            userTextAnswers[queryId] = textAnswer
        }
    }
    
    public func canProceedToNext(selectedAnswers: Set<String>, textAnswer: String) -> Bool {
        guard let questionDetails = currentQuestionDetails else { return false }
        
        let hasText = !textAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasValidAnswers = questionDetails.answers?.contains(where: { $0.answer != nil && !($0.answer?.isEmpty ?? true) }) ?? false
        
        switch questionDetails.query_type {
        case .text:
            // For text questions, only text is required
            return hasText
            
        case .radio_text, .checkbox_text:
            // If there are valid answers, both selection and text are required
            // If no valid answers (all null), only text is required
            if hasValidAnswers {
                return !selectedAnswers.isEmpty && hasText
            } else {
                return hasText
            }
            
        case .radio, .checkbox:
            // For regular choice questions, only selection is required
            return !selectedAnswers.isEmpty
        }
    }
    
    public func submitAnswer(selectedAnswers: Set<String>, textAnswer: String) async -> Bool {
        guard let questionDetails = currentQuestionDetails else { return false }
        
        print("[ViewModel] submitAnswer - current: \(currentQuestionNumber), total: \(totalQuestions)")
        
        // Calculate time spent on this question
        let timeSpent = calculateTimeSpent()
        print("[ViewModel] Time spent on question: \(timeSpent) seconds")
        
        // Save the answer locally
        var answerIds = Array(selectedAnswers)
        
        // For text-only questions (type = 5), add first answer ID
        if questionDetails.query_type == .text,
           let firstAnswerId = questionDetails.answers?.first?.id {
            answerIds = [firstAnswerId]
            print("[ViewModel] Text question - using first answer ID: \(firstAnswerId)")
        }
        
        saveAnswer(queryId: questionDetails.query_id, answerIds: answerIds, textAnswer: textAnswer)
        
        // Submit answer to server immediately
        let request = QuizUserAnswerRequest(
            query_id: questionDetails.query_id,
            query_time_left: timeSpent,
            answers_id: answerIds,
            answer_text: textAnswer.isEmpty ? nil : textAnswer
        )
        
        do {
            print("[ViewModel] Submitting answer for query \(questionDetails.query_id)")
            try await quizService.submitAnswers(answers: request)
            print("[ViewModel] Successfully submitted answer for query \(questionDetails.query_id)")
            
            // If this is the last question, calculate statistics
            if currentQuestionNumber == totalQuestions {
                print("[ViewModel] This is the last question - calculating statistics")
                await calculateQuizStatistics()
                await MainActor.run {
                    isQuizCompleted = true
                }
            }
            
            return true
        } catch {
            print("[ViewModel] ERROR submitting answer for query \(questionDetails.query_id): \(error.localizedDescription)")
            await MainActor.run {
                errorMessage = error.localizedDescription
                hasError = true
            }
            return false
        }
    }
    
    private func calculateQuizStatistics() async {
        var totalCorrect = 0
        var userCorrect = 0
        
        // Count all correct answers (number_of_points = 1)
        for (queryId, details) in allQuestionDetails {
            if let answers = details.answers {
                let correctAnswers = answers.filter { $0.number_of_points == 1 }
                totalCorrect += correctAnswers.count
                
                // Count user's correct answers
                if let userAnswerIds = userAnswers[queryId] {
                    let userCorrectCount = correctAnswers.filter { correctAnswer in
                        userAnswerIds.contains(correctAnswer.id)
                    }.count
                    userCorrect += userCorrectCount
                }
            }
        }
        
        let percentage = totalCorrect > 0 ? (Double(userCorrect) / Double(totalCorrect)) * 100.0 : 0.0
        
        await MainActor.run {
            totalCorrectAnswers = totalCorrect
            userCorrectAnswers = userCorrect
            quizPercentage = percentage
            
            print("[Quiz] Statistics - Total correct: \(totalCorrect), User correct: \(userCorrect), Percentage: \(percentage)%")
        }
    }
    
    // Get all questions with details for summary view
    public func getAllQuestionsWithAnswers() -> [(question: QuizQueryAnswerResponse, userAnswers: [String], textAnswer: String)] {
        guard let quiz = quiz else { return [] }
        
        return quiz.queries.compactMap { query in
            guard let details = allQuestionDetails[query.id] else { return nil }
            let answers = userAnswers[query.id] ?? []
            let textAnswer = userTextAnswers[query.id] ?? ""
            return (question: details, userAnswers: answers, textAnswer: textAnswer)
        }
    }
}