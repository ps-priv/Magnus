public struct SurveyAnswer : Hashable, Decodable, Encodable {
    public let query_id: String
    public let answer_text: String?
    public let answers_id: [String]?

    public init(query_id: String, answer_text: String? = nil, answers_id: [String]? = nil) {
        self.query_id = query_id
        self.answer_text = answer_text
        self.answers_id = answers_id
    }

    public static func createOpen(query_id: String, answer_text: String) -> SurveyAnswer {
        return SurveyAnswer(query_id: query_id, answer_text: answer_text)
    }

    public static func createChoice(query_id: String, answers_id: [String]) -> SurveyAnswer {
        return SurveyAnswer(query_id: query_id, answers_id: answers_id)
    }
}

public struct SurveyAnswersOpen : Hashable, Decodable, Encodable {
    public let query_id: String
    public let answer_text: String

    public init(query_id: String, answer_text: String) {
        self.query_id = query_id
        self.answer_text = answer_text
    }
}
        
public struct SurveyAnswersChoice : Hashable, Decodable, Encodable {
    public let query_id: String
    public let answers_id: [String]

    public init(query_id: String, answers_id: [String]) {
        self.query_id = query_id
        self.answers_id = answers_id
    }
}
