
public struct QuizQueryAnswerResponse : Hashable, Decodable, Encodable {
    public let query_id: String
    public let query_no: Int
    public let query_type: QuizQueryTypeEnum
    public let query_text: String
    public let query_time: String?
    public let answers: [QuizAnswer]?
    //public let user_answers: [QuizUserAnswer]

    public init(query_id: String, query_no: Int, query_type: QuizQueryTypeEnum, query_text: String, query_time: String?, answers: [QuizAnswer]?) {
        self.query_id = query_id
        self.query_no = query_no
        self.query_type = query_type
        self.query_text = query_text
        self.query_time = query_time
        self.answers = answers
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            query_id = try container.decode(String.self, forKey: .query_id)
            query_no = try container.decode(Int.self, forKey: .query_no)
            query_type = try container.decode(QuizQueryTypeEnum.self, forKey: .query_type)
            query_text = try container.decode(String.self, forKey: .query_text)
            query_time = try? container.decode(String.self, forKey: .query_time)
            answers = try? container.decode([QuizAnswer].self, forKey: .answers)
        } catch {
            print("[QuizQueryAnswerResponse] Decoding error: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("[QuizQueryAnswerResponse] Key '\(key.stringValue)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("[QuizQueryAnswerResponse] Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("[QuizQueryAnswerResponse] Value '\(type)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("[QuizQueryAnswerResponse] Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("[QuizQueryAnswerResponse] Unknown decoding error")
                }
            }
            throw error
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case query_id, query_no, query_type, query_text, query_time, answers
    }
}