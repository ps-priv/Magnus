public protocol QuizService {
    func getQuizForAgenda(agendaId: String) async throws -> QuizForAgenda
    func getQuizQueryDetails(queryId: String) async throws -> QuizQueryAnswerResponse
    func submitAnswers(answers: QuizUserAnswerRequest) async throws
}