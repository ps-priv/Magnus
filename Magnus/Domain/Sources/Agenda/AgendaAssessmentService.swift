public protocol AgendaAssessmentService {
    func submitAssessment(_ request: AgendaAssessmentRequest) async throws
}
