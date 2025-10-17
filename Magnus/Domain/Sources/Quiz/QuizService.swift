public protocol QuizService {
    func getQuizForAgenda(agendaId: String) async throws -> QuizForEvent
    func getQuizQueryDetails(queryId: String) async throws -> QuizQueryAnswerResponse
    func submitAnswers(answers: QuizUserAnswerRequest) async throws
}