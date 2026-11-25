public struct QuizForEvent : Hashable, Decodable, Encodable {
    public let sequential: QuizTypeEnum
    public let queries: [QuizQuery]
    /// Opcjonalny wstęp do quizu w formacie HTML.
    public let description: String?

    public init(sequential: QuizTypeEnum, queries: [QuizQuery] = [], description: String? = nil) {
        self.sequential = sequential
        self.queries = queries
        self.description = description
    }
}
