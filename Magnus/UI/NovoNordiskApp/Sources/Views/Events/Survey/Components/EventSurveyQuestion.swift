import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct SurveyAnswerData {
    let questionId: String
    let questionType: QueryTypeEnum
    let selectedAnswers: [String]
    let openAnswer: String?
}

struct EventSurveyQuestion: View {
    let questionDetails: SurveyQueryDetails
    let onAnswerChanged: (SurveyAnswerData) -> Void
    
    @State private var selectedAnswers: Set<String> = []
    @State private var openAnswer: String = ""
    
    private func notifyAnswerChanged() {
        let answerData = SurveyAnswerData(
            questionId: questionDetails.query_id,
            questionType: questionDetails.query_type,
            selectedAnswers: Array(selectedAnswers),
            openAnswer: openAnswer.isEmpty ? nil : openAnswer
        )

        onAnswerChanged(answerData)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Question number and text
            VStack(alignment: .leading, spacing: 8) {        
                Text(questionDetails.query_text)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }
            
            // Answer options based on question type
            switch questionDetails.query_type {
            case .open:
                openQuestionView
            case .single_choice:
                singleChoiceView
            case .multiple_choice:
                multipleChoiceView
            }
        }
    }
    
    @ViewBuilder
    private var openQuestionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(LocalizedStrings.surveyOpenAnswerPlaceholder, text: $openAnswer, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...20)
                .onChange(of: openAnswer) {
                    // For open questions, add the answer_id to selectedAnswers when there's text
                    selectedAnswers.removeAll()
                    if !openAnswer.isEmpty, let firstAnswer = questionDetails.answers.first, let answerId = firstAnswer.answer_id {
                        selectedAnswers.insert(answerId)
                    }
                    notifyAnswerChanged()
                }
        }
    }
    
    @ViewBuilder
    private var singleChoiceView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStrings.surveySelectOneOption)
                .font(.novoNordiskRegularText)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            ForEach(questionDetails.answers, id: \.answer) { answer in
                Button(action: {
                    selectedAnswers.removeAll()
                    if let answerId = answer.answer_id {
                        selectedAnswers.insert(answerId)
                    }
                    notifyAnswerChanged()
                }) {
                    HStack {
                        let isSelected = answer.answer_id.map { selectedAnswers.contains($0) } ?? false
                        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(isSelected ? Color.novoNordiskBlue : Color.gray)
                        
                        Text(answer.answer)
                            .font(.novoNordiskBody)
                            .foregroundColor(Color.novoNordiskTextGrey)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    @ViewBuilder
    private var multipleChoiceView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStrings.surveyMultipleChoicePlaceholder)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            ForEach(questionDetails.answers, id: \.answer) { answer in
                Button(action: {
                    if let answerId = answer.answer_id {
                        if selectedAnswers.contains(answerId) {
                            selectedAnswers.remove(answerId)
                        } else {
                            selectedAnswers.insert(answerId)
                        }
                    }
                    notifyAnswerChanged()
                }) {
                    HStack {
                        let isSelected = answer.answer_id.map { selectedAnswers.contains($0) } ?? false
                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .foregroundColor(isSelected ? Color.novoNordiskBlue : Color.gray)
                        
                        Text(answer.answer)
                            .font(.novoNordiskBody)
                            .foregroundColor(Color.novoNordiskTextGrey)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    let sampleQuestion = SurveyQueryDetails(
        query_id: "1",
        query_no: 1,
        query_type: .single_choice,
        query_text: "How would you rate this event?",
        answers: [
            SurveyQueryAnswer(answer_id: "1", answer: "Excellent", number_of_points: 5),
            SurveyQueryAnswer(answer_id: "2", answer: "Good", number_of_points: 4),
            SurveyQueryAnswer(answer_id: "3", answer: "Average", number_of_points: 3),
            SurveyQueryAnswer(answer_id: "4", answer: "Poor", number_of_points: 2)
        ]
    )
    
    VStack(alignment: .leading) {
        EventSurveyQuestion(questionDetails: sampleQuestion) { answerData in
            print("Answer changed: \(answerData)")
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
    .padding()
}
