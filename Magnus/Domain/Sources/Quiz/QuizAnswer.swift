public struct QuizAnswer : Hashable, Decodable, Encodable {
    public let id: String
    public let answer: String?
    public let number_of_points: Int?

    public init(id: String, answer: String?, number_of_points: Int?) {
        self.id = id
        self.answer = answer
        self.number_of_points = number_of_points
    }
}

            