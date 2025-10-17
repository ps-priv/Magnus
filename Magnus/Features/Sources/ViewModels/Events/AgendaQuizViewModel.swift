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
    
    public func loadQuestionDetails(queryId: String) async {
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
                currentQuestionDetails = details
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
    
    public func handleNextButton() async {
        guard let quiz = quiz else { return }
        print("[Quiz] handleNextButton - current: \(currentQuestionNumber), total: \(quiz.queries.count)")
        
        if currentQuestionNumber == 0 {
            // Start quiz
            if let firstQuery = quiz.queries.first {
                print("[Quiz] Starting quiz with first question: \(firstQuery.id)")
                await loadQuestionDetails(queryId: firstQuery.id)
                await MainActor.run {
                    currentQuestionNumber = 1
                    buttonTitle = FeaturesLocalizedStrings.quizNextButton
                    print("[Quiz] Started - now at question \(currentQuestionNumber)")
                }
            }
        } else if currentQuestionNumber <= quiz.queries.count {
            // Move to next question or complete
            let nextQuestionNumber = currentQuestionNumber + 1
            
            if nextQuestionNumber <= quiz.queries.count {
                // Load next question
                let queryIndex = nextQuestionNumber - 1
                let query = quiz.queries[queryIndex]
                print("[Quiz] Moving to question \(nextQuestionNumber), queryId: \(query.id)")
                await loadQuestionDetails(queryId: query.id)
                
                await MainActor.run {
                    currentQuestionNumber = nextQuestionNumber
                    print("[Quiz] Moved to question \(currentQuestionNumber)")
                    
                    if currentQuestionNumber == quiz.queries.count {
                        buttonTitle = FeaturesLocalizedStrings.quizCompleteButton
                    }
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
        
        // For text questions, check if there's text input
        if questionDetails.query_type == .text {
            return !textAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        // For choice questions, check if at least one answer is selected
        return !selectedAnswers.isEmpty
    }
    
    public func submitAnswer(selectedAnswers: Set<String>, textAnswer: String) async -> Bool {
        guard let questionDetails = currentQuestionDetails else { return false }
        
        // Save the answer
        let answerIds = Array(selectedAnswers)
        saveAnswer(queryId: questionDetails.query_id, answerIds: answerIds)
        
        // If this is the last question, submit all answers
        if currentQuestionNumber == totalQuestions {
            return await submitAllAnswers()
        }
        
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