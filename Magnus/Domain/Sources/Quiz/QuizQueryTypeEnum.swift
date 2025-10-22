public enum QuizQueryTypeEnum: Int, CaseIterable, Codable {
    case checkbox = 1
    case checkbox_text = 2
    case radio = 3
    case radio_text = 4
    case text = 5
}