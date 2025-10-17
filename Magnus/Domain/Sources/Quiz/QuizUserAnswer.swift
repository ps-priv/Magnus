

public struct QuizUserAnswer : Hashable, Decodable, Encodable {
    public let id: String
    public let user_answer_text: String?
    public let query_time_left: Int
    public let quiz_result: Int
    
    public init(id: String, user_answer_text: String?, query_time_left: Int, quiz_result: Int) {
        self.id = id
        self.user_answer_text = user_answer_text
        self.query_time_left = query_time_left
        self.quiz_result = quiz_result
    }
}