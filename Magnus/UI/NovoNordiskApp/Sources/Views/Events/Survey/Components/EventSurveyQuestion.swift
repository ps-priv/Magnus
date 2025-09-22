import MagnusApplication
import MagnusDomain
import SwiftUI

struct EventSurveyQuestion: View {
    let questionDetails: SurveyQueryDetails
    @State private var selectedAnswers: Set<String> = []
    @State private var openAnswer: String = ""
    
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
                    selectedAnswers.insert(answer.answer)
                }) {
                    HStack {
                        Image(systemName: selectedAnswers.contains(answer.answer) ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedAnswers.contains(answer.answer) ? Color.novoNordiskBlue : Color.gray)
                        
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
                    if selectedAnswers.contains(answer.answer) {
                        selectedAnswers.remove(answer.answer)
                    } else {
                        selectedAnswers.insert(answer.answer)
                    }
                }) {
                    HStack {
                        Image(systemName: selectedAnswers.contains(answer.answer) ? "checkmark.square.fill" : "square")
                            .foregroundColor(selectedAnswers.contains(answer.answer) ? Color.novoNordiskBlue : Color.gray)
                        
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
            SurveyQueryAnswer(answer: "Excellent", number_of_points: 5),
            SurveyQueryAnswer(answer: "Good", number_of_points: 4),
            SurveyQueryAnswer(answer: "Average", number_of_points: 3),
            SurveyQueryAnswer(answer: "Poor", number_of_points: 2)
        ]
    )
    
    VStack(alignment: .leading) {
        EventSurveyQuestion(questionDetails: sampleQuestion)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
    .padding()
}
