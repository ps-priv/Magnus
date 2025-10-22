public enum QuizQueryStatusEnum: Int, CaseIterable, Codable {
    case before = 1
    case active = 2
    case after = 3
    case answered = 4
}