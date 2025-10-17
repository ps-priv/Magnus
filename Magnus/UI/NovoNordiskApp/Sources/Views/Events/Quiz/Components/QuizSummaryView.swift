import SwiftUI


// MARK: - Quiz Summary Component
struct QuizSummaryView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color.green)
            
            Text(LocalizedStrings.quizThankYouTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .multilineTextAlignment(.center)
            
            Text(LocalizedStrings.quizThankYouMessage)
                .font(.novoNordiskBody)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Text(LocalizedStrings.quizCompletionInfo)
                .font(.novoNordiskCaption)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .padding(32)
    }
}