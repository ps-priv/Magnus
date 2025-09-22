public struct SurveyQueryAnswer : Hashable, Decodable, Encodable {
    public let answer_id: String?
    public let answer: String
    public let number_of_points: Int

    public init(answer_id: String? = nil, answer: String, number_of_points: Int) {
        self.answer_id = answer_id
        self.answer = answer
        self.number_of_points = number_of_points
    }
}