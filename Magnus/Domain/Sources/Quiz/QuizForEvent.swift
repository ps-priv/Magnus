public struct QuizForEvent : Hashable, Decodable, Encodable {
    public let queries: [QuizQuery]

    public init(queries: [QuizQuery] = []) {
        self.queries = queries
    }
}