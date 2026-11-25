import SwiftUI

struct AgendaAssessmentThankYouView: View {
    var autoReturnAfter: Duration = .seconds(5)
    let onReturn: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(LocalizedStrings.agendaAssessmentThankYouTitle)
                .font(.novoNordiskTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            Text(LocalizedStrings.agendaAssessmentThankYouMessage)
                .font(.novoNordiskHeadline)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            FAIcon(.circle_check, type: .light, size: 140, color: .novoNordiskBlue)

            Spacer()

            NovoNordiskButton(title: LocalizedStrings.agendaAssessmentReturnButton, action: onReturn)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        // .task jest anulowany, gdy widok znika (np. po ręcznym „Powrót”).
        .task {
            try? await Task.sleep(for: autoReturnAfter)
            guard !Task.isCancelled else { return }
            onReturn()
        }
    }
}

#Preview {
    AgendaAssessmentThankYouView { print("Powrót") }
        .background(Color.novoNordiskBackgroundGrey)
}
