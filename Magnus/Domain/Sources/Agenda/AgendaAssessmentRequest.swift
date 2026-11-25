public struct AgendaAssessmentRequest: Hashable, Encodable {
    public let agenda_content_id: String
    public let description: String
    public let assessment: Int

    public init(agenda_content_id: String, description: String, assessment: Int) {
        self.agenda_content_id = agenda_content_id
        self.description = description
        self.assessment = assessment
    }
}
