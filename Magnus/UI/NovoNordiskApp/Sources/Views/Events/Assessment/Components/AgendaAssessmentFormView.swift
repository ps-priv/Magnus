import SwiftUI

struct AgendaAssessmentFormView: View {
    let assessment: Int
    @Binding var description: String
    let isSubmitting: Bool
    let errorMessage: String?
    let onSelectStar: (Int) -> Void
    let onSubmit: () -> Void

    @FocusState private var isDescriptionFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(LocalizedStrings.agendaAssessmentHeader)
                .font(.novoNordiskHeadline)
                .foregroundColor(Color.novoNordiskTextGrey)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)

            AssessmentStarRatingView(rating: assessment, onSelect: onSelectStar)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.agendaAssessmentDescriptionLabel)
                    .font(.novoNordiskCaption)
                    .foregroundColor(Color.novoNordiskTextGrey)

                TextField(LocalizedStrings.agendaAssessmentDescriptionPlaceholder, text: $description, axis: .vertical)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .lineLimit(3...10)
                    .focused($isDescriptionFocused)
                    .disabled(isSubmitting)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.novoNordiskCaption)
                    .foregroundColor(.red)
            }

            Spacer()

            NovoNordiskButton(
                title: isSubmitting ? "" : LocalizedStrings.agendaAssessmentSubmitButton,
                isEnabled: !isSubmitting
            ) {
                isDescriptionFocused = false
                onSubmit()
            }
            .overlay {
                if isSubmitting {
                    ProgressView().tint(.white)
                }
            }
        }
        .padding(20)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(LocalizedStrings.close) {
                    isDescriptionFocused = false
                }
            }
        }
    }
}

#Preview("Pusty") {
    AgendaAssessmentFormView(
        assessment: 0, description: .constant(""), isSubmitting: false, errorMessage: nil,
        onSelectStar: { _ in }, onSubmit: {}
    )
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("Wypełniony") {
    AgendaAssessmentFormView(
        assessment: 3, description: .constant("Bardzo fajne"), isSubmitting: false, errorMessage: nil,
        onSelectStar: { _ in }, onSubmit: {}
    )
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("Wysyłanie") {
    AgendaAssessmentFormView(
        assessment: 4, description: .constant("Bardzo fajne"), isSubmitting: true, errorMessage: nil,
        onSelectStar: { _ in }, onSubmit: {}
    )
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("Błąd") {
    AgendaAssessmentFormView(
        assessment: 4, description: .constant("Bardzo fajne"), isSubmitting: false,
        errorMessage: LocalizedStrings.agendaAssessmentError,
        onSelectStar: { _ in }, onSubmit: {}
    )
    .background(Color.novoNordiskBackgroundGrey)
}
