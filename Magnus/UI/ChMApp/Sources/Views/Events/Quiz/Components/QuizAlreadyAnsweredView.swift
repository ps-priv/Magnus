import SwiftUI

// struct QuizAlreadyAnsweredView: View {
//     let totalQuestions: Int
//     let onClose: () -> Void
    
//     var body: some View {
//         VStack(spacing: 0) {
//             Spacer()
            
//             VStack(spacing: 24) {
//                 FAIcon(.circle_information, type: .regular, size: 120, color: Color.novoNordiskBlue.opacity(0.7))
                
//                 Text(LocalizedStrings.quizAlreadyAnsweredTitle)
//                     .font(.novoNordiskSectionTitle)
//                     .fontWeight(.bold)
//                     .foregroundColor(Color.novoNordiskBlue)
//                     .multilineTextAlignment(.center)
                
//                 Text(LocalizedStrings.quizAlreadyAnsweredMessage)
//                     .font(.novoNordiskBody)
//                     .foregroundColor(Color.novoNordiskTextGrey)
//                     .multilineTextAlignment(.center)
//                     .padding(.horizontal, 20)
//             }
            
//             Spacer()

//             Button(action: onClose) {
//                 Text(LocalizedStrings.quizCloseButton)
//                     .font(.novoNordiskBody)
//                     .fontWeight(.semibold)
//                     .foregroundColor(.white)
//                     .frame(maxWidth: .infinity)
//                     .padding(.vertical, 16)
//                     .background(Color.novoNordiskBlue)
//                     .cornerRadius(12)
//             }
//             .padding(.horizontal, 32)
//             .padding(.bottom, 32)
//         }
//         .frame(maxWidth: .infinity, maxHeight: .infinity)
//         .padding(.top, 32)
//     }
// } 

struct QuizAlreadyAnsweredView: View {
    let totalQuestions: Int
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
                FAIcon(.circle_information, type: .regular, size: 120, color: Color.novoNordiskBlue.opacity(0.7))
                
                Text(LocalizedStrings.quizAlreadyAnsweredTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStrings.quizAlreadyAnsweredMessage)
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

            Spacer()

            Button(action: onClose) {
                Text(LocalizedStrings.quizCloseButton)
                    .font(.novoNordiskBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.novoNordiskBlue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(32)
    }
} 