public struct QuizForEvent : Hashable, Decodable, Encodable {
    public let sequential: QuizTypeEnum
    public let queries: [QuizQuery]

    public init(sequential: QuizTypeEnum, queries: [QuizQuery] = []) {
        self.sequential = sequential
        self.queries = queries
    }
}
