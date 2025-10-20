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
            }
            
            // Load all question details
            print("[Quiz] Loading details for \(data.queries.count) questions")
            await loadAllQuestionDetails(queries: data.queries)
            
            await MainActor.run {
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
    
    private func loadAllQuestionDetails(queries: [QuizQuery]) async {
        for query in queries {
            do {
                let details = try await quizService.getQuizQueryDetails(queryId: query.id)
                print("[Quiz] Loaded details for question \(query.query_no): \(details.query_text)")
                print("[Quiz] Question type: \(details.query_type), answers count: \(details.answers?.count ?? 0)")
                allQuestionDetails[query.id] = details
            } catch {
                print("[Quiz] Failed to load details for question \(query.query_no): \(error.localizedDescription)")
                // Continue loading other questions even if one fails
            }
        }
        print("[Quiz] Loaded \(allQuestionDetails.count) out of \(queries.count) questions")
    }
    
    public func loadQuestionDetails(queryId: String) async throws {
        print("[Quiz] loadQuestionDetails called for queryId: \(queryId)")
        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }
        
        do {
            let details = try await quizService.getQuizQueryDetails(queryId: queryId)
            print("[Quiz] Loaded details for query: \(queryId), text: \(details.query_text)")
            
            await MainActor.run {
                print("[Quiz] About to update currentQuestionDetails to: \(details.query_id)")
                currentQuestionDetails = details
                isLoading = false
                print("[Quiz] currentQuestionDetails updated to: \(details.query_id), text: \(details.query_text), isLoading: \(isLoading)")
            }
        } catch let error {
            print("[Quiz] ERROR loading question details: \(error.localizedDescription)")
            await MainActor.run {
                errorMessage = error.localizedDescription
                hasError = true
                isLoading = false
            }
            throw error
        }
    }
    
    public func handleNextButton() async {
        guard let quiz = quiz else { return }
        print("[Quiz] handleNextButton - current: \(currentQuestionNumber), total: \(quiz.queries.count)")
        
        if currentQuestionNumber == 0 {
            // Start quiz
            if let firstQuery = quiz.queries.first,
               let details = allQuestionDetails[firstQuery.id] {
                print("[Quiz] Starting quiz with first question: \(firstQuery.id)")
                await MainActor.run {
                    currentQuestionDetails = details
                    currentQuestionNumber = 1
                    buttonTitle = FeaturesLocalizedStrings.quizNextButton
                    print("[Quiz] Started - now at question \(currentQuestionNumber)")
                }
            } else {
                print("[Quiz] Failed to start quiz - no details available for first question")
            }
        } else if currentQuestionNumber <= quiz.queries.count {
            // Move to next question or complete
            let nextQuestionNumber = currentQuestionNumber + 1
            
            if nextQuestionNumber <= quiz.queries.count {
                // Load next question from cache
                let queryIndex = nextQuestionNumber - 1
                let query = quiz.queries[queryIndex]
                print("[Quiz] Moving to question \(nextQuestionNumber), queryId: \(query.id)")
                
                if let details = allQuestionDetails[query.id] {
                    await MainActor.run {
                        currentQuestionDetails = details
                        currentQuestionNumber = nextQuestionNumber
                        print("[Quiz] Moved to question \(currentQuestionNumber)")
                        
                        if currentQuestionNumber == quiz.queries.count {
                            buttonTitle = FeaturesLocalizedStrings.quizCompleteButton
                        }
                    }
                } else {
                    print("[Quiz] ⚠️ No details available for question \(nextQuestionNumber)")
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
    
    public func saveAnswer(queryId: String, answerIds: [String]) {
        userAnswers[queryId] = answerIds
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
        saveAnswer(queryId: questionDetails.query_id, answerIds: answerIds)
        
        // If this is the last question, submit all answers
        if currentQuestionNumber == totalQuestions {
            print("[ViewModel] This is the last question - submitting all answers")
            let success = await submitAllAnswers()
            if success {
                print("[ViewModel] All answers submitted successfully - setting isQuizCompleted = true")
                await MainActor.run {
                    isQuizCompleted = true
                    print("[ViewModel] isQuizCompleted set to true")
                }
            } else {
                print("[ViewModel] Failed to submit all answers")
            }
            return success
        }
        
        print("[ViewModel] Not the last question - returning true")
        return true
    }
    
    private func submitAllAnswers() async -> Bool {
        guard let quiz = quiz else { return false }
        
        // Create submission request for each question
        for query in quiz.queries {
            if let answerIds = userAnswers[query.id] {
                let request = QuizUserAnswerRequest(
                    query_id: query.id,
                    query_time_left: 0, // You may want to track time
                    answers_id: answerIds
                )
                
                do {
                    try await quizService.submitAnswers(answers: request)
                } catch {
                    await MainActor.run {
                        errorMessage = error.localizedDescription
                        hasError = true
                    }
                    return false
                }
            }
        }
        
        return true
    }
}