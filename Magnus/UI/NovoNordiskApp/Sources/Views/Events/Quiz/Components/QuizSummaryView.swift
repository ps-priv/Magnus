import SwiftUI
import MagnusDomain

// MARK: - Quiz Summary Component
struct QuizSummaryView: View {
    let percentage: Double
    let questionsWithAnswers: [(question: QuizQueryAnswerResponse, userAnswers: [String])]
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text(LocalizedStrings.quizThankYouTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Subtitle
            Text(LocalizedStrings.quizResultSubtitle)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Circular progress chart
            CircularProgressView(percentage: percentage)
                .padding(.vertical, 20)
            
            // Questions list
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(questionsWithAnswers.enumerated()), id: \.offset) { index, item in
                    QuizQuestionSummaryView(
                        questionNumber: index + 1,
                        question: item.question,
                        userAnswers: item.userAnswers
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Question Summary Item
private struct QuizQuestionSummaryView: View {
    let questionNumber: Int
    let question: QuizQueryAnswerResponse
    let userAnswers: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Question text
            Text("\(questionNumber). \(question.query_text)")
                .font(.novoNordiskBody)
                .fontWeight(.semibold)
                .foregroundColor(Color.novoNordiskBlue)
            
            // Answers (only for radio and checkbox types)
            if question.query_type == .radio || question.query_type == .checkbox ||
               question.query_type == .radio_text || question.query_type == .checkbox_text {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(question.answers ?? [], id: \.id) { answer in
                        if let answerText = answer.answer, !answerText.isEmpty {
                            AnswerItemView(
                                answer: answer,
                                isSelectedByUser: userAnswers.contains(answer.id),
                                hasUserAnswered: !userAnswers.isEmpty
                            )
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Answer Item
private struct AnswerItemView: View {
    let answer: QuizAnswer
    let isSelectedByUser: Bool
    let hasUserAnswered: Bool
    
    private var answerColor: Color {
        let isCorrect = answer.number_of_points == 1
        
        if !hasUserAnswered {
            // User didn't answer - no color
            return Color.novoNordiskTextGrey
        }
        
        if isCorrect && isSelectedByUser {
            // Correct answer selected by user - green
            return Color.green
        } else if isCorrect && !isSelectedByUser {
            // Correct answer NOT selected by user - yellow
            return Color.yellow
        } else if !isCorrect && isSelectedByUser {
            // Incorrect answer selected by user - red
            return Color.red
        } else {
            // Incorrect answer not selected - gray
            return Color.novoNordiskTextGrey
        }
    }
    
    private var iconName: String {
        let isCorrect = answer.number_of_points == 1
        
        if !hasUserAnswered {
            return "circle"
        }
        
        if isCorrect && isSelectedByUser {
            return "checkmark.circle.fill"
        } else if isCorrect && !isSelectedByUser {
            return "exclamationmark.circle.fill"
        } else if !isCorrect && isSelectedByUser {
            return "xmark.circle.fill"
        } else {
            return "circle"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(answerColor)
                .font(.system(size: 20))
            
            Text(answer.answer ?? "")
                .font(.novoNordiskBody)
                .foregroundColor(answerColor)
            
            Spacer()
        }
        .padding(.leading, 8)
    }
}