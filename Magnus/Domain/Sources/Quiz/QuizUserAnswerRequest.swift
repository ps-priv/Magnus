public struct QuizUserAnswerRequest : Hashable, Decodable, Encodable {
    public let query_id: String
    public let query_time_left: Int
    public let answers_id: [String]

    public init(query_id: String, query_time_left: Int, answers_id: [String]) {
        self.query_id = query_id
        self.query_time_left = query_time_left
        self.answers_id = answers_id
    }
}   