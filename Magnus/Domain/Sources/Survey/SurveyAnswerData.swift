public struct SurveyAnswerData {
    public let questionId: String
    public let questionType: QueryTypeEnum
    public let selectedAnswers: [String]
    public let openAnswer: String?
    
    public init(questionId: String, questionType: QueryTypeEnum, selectedAnswers: [String], openAnswer: String?) {
        self.questionId = questionId
        self.questionType = questionType
        self.selectedAnswers = selectedAnswers
        self.openAnswer = openAnswer
    }
}
