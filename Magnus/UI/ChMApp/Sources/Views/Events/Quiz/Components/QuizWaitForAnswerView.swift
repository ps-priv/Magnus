import SwiftUI
import MagnusDomain

struct QuizWaitForAnswerView: View {
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 24) {
            FAIcon(.questionCircle, type: .regular, size: 120, color: Color.novoNordiskBlue.opacity(0.7))
            
            Text(LocalizedStrings.quizWaitForAnswerTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .multilineTextAlignment(.center)
            
            Text(LocalizedStrings.quizWaitForAnswerMessage)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            HStack(spacing: 8) {
                Text("\(LocalizedStrings.quizQuestionsCount) \(totalQuestions)")
                    .font(.novoNordiskBody)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(32)
    }
}