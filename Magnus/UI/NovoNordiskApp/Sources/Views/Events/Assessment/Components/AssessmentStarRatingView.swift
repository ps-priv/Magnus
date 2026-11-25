import SwiftUI

struct AssessmentStarRatingView: View {
    let rating: Int
    var maxRating: Int = 5
    var size: CGFloat = 40
    let onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...maxRating, id: \.self) { star in
                Button {
                    onSelect(star)
                } label: {
                    FAIcon(.star, type: star <= rating ? .solid : .regular, size: size, color: .novoNordiskBlue)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(format: LocalizedStrings.agendaAssessmentStarAccessibility, star))
                .accessibilityAddTraits(star <= rating ? .isSelected : [])
            }
        }
        .animation(.easeInOut(duration: 0.15), value: rating)
    }
}

#Preview("0, 3 i 5 gwiazdek") {
    VStack(spacing: 24) {
        AssessmentStarRatingView(rating: 0) { _ in }
        AssessmentStarRatingView(rating: 3) { _ in }
        AssessmentStarRatingView(rating: 5) { _ in }
    }
    .padding()
}

#Preview("Interaktywny") {
    @Previewable @State var rating = 2
    AssessmentStarRatingView(rating: rating) { rating = $0 == rating ? 0 : $0 }
        .padding()
}
