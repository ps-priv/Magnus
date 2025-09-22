public struct SurveyForEvent : Hashable, Decodable, Encodable {
    public let queries: [SurveyQuery]

    public init(queries: [SurveyQuery]) {
        self.queries = queries
    }
}