public struct SurveyQueryDetails : Hashable, Decodable, Encodable {
    public let query_id: String
    public let query_no: Int
    public let query_type: QueryTypeEnum
    public let query_text: String
    public let answers: [SurveyQueryAnswer]

    public init(query_id: String, query_no: Int, query_type: QueryTypeEnum, query_text: String, answers: [SurveyQueryAnswer]) {
        self.query_id = query_id
        self.query_no = query_no
        self.query_type = query_type
        self.query_text = query_text
        self.answers = answers
    }
}