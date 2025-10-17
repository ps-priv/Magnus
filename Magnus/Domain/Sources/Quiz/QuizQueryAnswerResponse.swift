
public struct QuizQueryAnswerResponse : Hashable, Decodable, Encodable {
    public let query_id: String
    public let query_no: Int
    public let query_type: QuizQueryType
    public let query_text: String
    public let query_time: String
    public let answers: [QuizAnswer]
    public let user_answers: [QuizUserAnswer]

    public init(query_id: String, query_no: Int, query_type: QuizQueryType, query_text: String, query_time: String, answers: [QuizAnswer], user_answers: [QuizUserAnswer]) {
        self.query_id = query_id
        self.query_no = query_no
        self.query_type = query_type
        self.query_text = query_text
        self.query_time = query_time
        self.answers = answers
        self.user_answers = user_answers
    }
}