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

    public init(agendaId: String, 
        quizService: QuizService = DIContainer.shared.quizService) {
        self.agendaId = agendaId
        self.quizService = quizService

        Task {
            await loadData()
        }
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
        } catch let error {
            await MainActor.run {
                errorMessage = error.localizedDescription
                hasError = true
                isLoading = false
            }
        }
    }
    
    private func loadQuestionDetailsIfNeeded(queryId: String) async -> QuizQueryAnswerResponse? {
        // Check if already loaded
        if let cached = allQuestionDetails[queryId] {
            print("[Quiz] Using cached details for query: \(queryId)")
            return cached
        }
        
        // Load from service
        do {
            print("[Quiz] Loading details for query: \(queryId)")
            let details = try await quizService.getQuizQueryDetails(queryId: queryId)
            print("[Quiz] Loaded details: \(details.query_text)")
            print("[Quiz] Question type: \(details.query_type), answers count: \(details.answers?.count ?? 0)")
            allQuestionDetails[queryId] = details
            return details
        } catch {
            print("[Quiz] Failed to load details for query \(queryId): \(error.localizedDescription)")
            return nil
        }
    }
    
    public func handleNextButton() async {
        guard let quiz = quiz else { return }
        print("[Quiz] handleNextButton - current: \(currentQuestionNumber), total: \(quiz.queries.count)")
        
        if currentQuestionNumber == 0 {
            // Start quiz - load first question
            if let firstQuery = quiz.queries.first {
                print("[Quiz] Starting quiz, loading first question: \(firstQuery.id)")
                
                await MainActor.run {
                    isLoading = true
                }
                
                if let details = await loadQuestionDetailsIfNeeded(queryId: firstQuery.id) {
                    await MainActor.run {
                        currentQuestionDetails = details
                        currentQuestionNumber = 1
                        buttonTitle = FeaturesLocalizedStrings.quizNextButton
                        isLoading = false
                        print("[Quiz] Started - now at question \(currentQuestionNumber)")
                    }
                } else {
                    await MainActor.run {
                        errorMessage = "Failed to load question details"
                        hasError = true
                        isLoading = false
                    }
                    print("[Quiz] Failed to start quiz - could not load first question")
                }
            } else {
                print("[Quiz] Failed to start quiz - no questions available")
            }
        } else if currentQuestionNumber <= quiz.queries.count {
            // Move to next question or complete
            let nextQuestionNumber = currentQuestionNumber + 1
            
            if nextQuestionNumber <= quiz.queries.count {
                // Load next question
                let queryIndex = nextQuestionNumber - 1
                let query = quiz.queries[queryIndex]
                print("[Quiz] Moving to question \(nextQuestionNumber), queryId: \(query.id)")
                
                await MainActor.run {
                    isLoading = true
                }
                
                if let details = await loadQuestionDetailsIfNeeded(queryId: query.id) {
                    await MainActor.run {
                        currentQuestionDetails = details
                        currentQuestionNumber = nextQuestionNumber
                        isLoading = false
                        print("[Quiz] Moved to question \(currentQuestionNumber)")
                        
                        if currentQuestionNumber == quiz.queries.count {
                            buttonTitle = FeaturesLocalizedStrings.quizCompleteButton
                        }
                    }
                } else {
                    await MainActor.run {
                        errorMessage = "Failed to load question details"
                        hasError = true
                        isLoading = false
                    }
                    print("[Quiz] ⚠️ Failed to load details for question \(nextQuestionNumber)")
                }
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
        
        // Save the answer
        let answerIds = Array(selectedAnswers)
        saveAnswer(queryId: questionDetails.query_id, answerIds: answerIds, textAnswer: textAnswer)
        
        // If this is the last question, submit all answers
        if currentQuestionNumber == totalQuestions {
            print("[ViewModel] This is the last question - submitting all answers")
            let success = await submitAllAnswers()
            if !success {
                print("[ViewModel] Failed to submit all answers")
            }
            return success
        }
        
        print("[ViewModel] Not the last question - returning true")
        return true
    }
    
    private func submitAllAnswers() async -> Bool {
        guard let quiz = quiz else {
            print("[ViewModel] submitAllAnswers - quiz is nil")
            return false
        }
        
        print("[ViewModel] submitAllAnswers - starting to submit \(quiz.queries.count) questions")
        print("[ViewModel] submitAllAnswers - userAnswers count: \(userAnswers.count)")
        
        var hasErrors = false
        var lastError: String = ""
        
        // Create submission request for each question
        for (index, query) in quiz.queries.enumerated() {
            print("[ViewModel] Processing question \(index + 1)/\(quiz.queries.count), queryId: \(query.id)")
            
            // Get answers for this query (empty array if none)
            let answerIds = userAnswers[query.id] ?? []
            print("[ViewModel] Found \(answerIds.count) answers for query \(query.id): \(answerIds)")
            
            let request = QuizUserAnswerRequest(
                query_id: query.id,
                query_time_left: 0, // You may want to track time
                answers_id: answerIds
            )
            
            do {
                print("[ViewModel] Submitting answers for query \(query.id)")
                try await quizService.submitAnswers(answers: request)
                print("[ViewModel] Successfully submitted answers for query \(query.id)")
            } catch {
                print("[ViewModel] ERROR submitting answers for query \(query.id): \(error.localizedDescription)")
                print("[ViewModel] Error details: \(error)")
                print("[ViewModel] Continuing despite error to show summary...")
                hasErrors = true
                lastError = error.localizedDescription
                // Don't return false - continue to show summary
            }
        }
        
        if hasErrors {
            print("[ViewModel] Some answers failed to submit, but continuing to show summary")
            await MainActor.run {
                errorMessage = lastError
                hasError = true
            }
        }
        
        print("[ViewModel] All answers processed, calculating statistics...")
        
        // Calculate statistics after all answers are submitted
        await calculateQuizStatistics()
        
        print("[ViewModel] Statistics calculated, setting isQuizCompleted...")
        
        // Set quiz as completed after everything is done
        await MainActor.run {
            isQuizCompleted = true
            print("[ViewModel] Quiz completed - isQuizCompleted set to true")
        }
        
        return true
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