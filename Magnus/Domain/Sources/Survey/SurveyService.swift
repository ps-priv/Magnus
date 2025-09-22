public protocol SurveyService {
    func getSurveyForEvent(eventId: String) async throws -> SurveyForEvent
    func getSurveyQueryDetails(queryId: String) async throws -> SurveyQueryDetails
    func submitAnswers(answers: SurveyAnswer) async throws
}