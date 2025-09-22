public struct SurveyQueryAnswer : Hashable, Decodable, Encodable {
    public let query_id: String?
    public let answer: String
    public let number_of_points: Int

    public init(query_id: String? = nil, answer: String, number_of_points: Int) {
        self.query_id = query_id
        self.answer = answer
        self.number_of_points = number_of_points
    }
}