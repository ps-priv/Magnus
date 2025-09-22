public struct SurveyForEvent : Hashable, Decodable, Encodable {
    public let survey_status: SurveyStatusEnum?
    public let queries: [SurveyQuery]

    public init(survey_status: SurveyStatusEnum? = .before, queries: [SurveyQuery] = []) {
        self.survey_status = survey_status
        self.queries = queries
    }
}