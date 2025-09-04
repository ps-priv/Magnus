import SwiftUI

struct EventAgendaQuizButton: View {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                FAIcon(.bell, type: .regular, size: 15, color: Color.novoNordiskOrange)
                Text(LocalizedStrings.eventAgendaQuiz)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.novoNordiskBlue)
            .cornerRadius(16)
            .shadow(radius: 2)
        }
    }
}

#Preview("EventAgendaQuizButton") {
    VStack {
        EventAgendaQuizButton(action: {})
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}