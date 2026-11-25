import MagnusApplication
import SwiftUI

/// Wstęp do quizu: treść HTML z pola `description` z API.
struct QuizDescriptionView: View {
    let html: String

    @State private var rendered: AttributedString?

    var body: some View {
        Group {
            if let rendered {
                Text(rendered)
            } else {
                Text(HtmlHelper.plainText(fromHTML: html))
                    .font(.novoNordiskBody)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
        }
        .tint(Color.novoNordiskBlue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .task(id: html) {
            rendered = HtmlHelper.attributedString(
                fromHTML: html,
                fontFamily: "OpenSans-Regular",
                fontSize: 16,
                colorHex: "001423" // NovoNordiskTextGrey
            )
        }
    }
}

// MARK: - Podglądy

private enum QuizDescriptionPreviewData {
    static let short = "Proszę wypełniać <b>powoli</b> i dokładnie"

    static let long = """
    <p>Witamy w quizie podsumowującym <b>sesję poranną</b>.</p>
    <p>Zanim zaczniesz, pamiętaj:</p>
    <ul>
      <li>każde pytanie ma <i>ograniczony czas</i>,</li>
      <li>po przejściu dalej <u>nie można wrócić</u> do poprzedniego pytania,</li>
      <li>w pytaniach wielokrotnego wyboru zaznacz <strong>wszystkie</strong> poprawne odpowiedzi.</li>
    </ul>
    <p>Szczegóły znajdziesz na <a href="https://pro.novonordisk.pl">pro.novonordisk.pl</a>.<br>Powodzenia!</p>
    """
}

#Preview("Krótki") {
    QuizDescriptionView(html: QuizDescriptionPreviewData.short)
        .padding(.vertical, 20)
}

#Preview("Długi") {
    ScrollView {
        QuizDescriptionView(html: QuizDescriptionPreviewData.long)
            .padding(.vertical, 20)
    }
}

#Preview("W karcie quizu") {
    VStack(alignment: .leading, spacing: 0) {
        HStack {
            Text(LocalizedStrings.eventQuizScreenTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.novoNordiskLighGreyForPanelBackground)

        ScrollView {
            QuizDescriptionView(html: QuizDescriptionPreviewData.long)
                .padding(.vertical, 20)
        }

        Text("Rozpocznij quiz")
            .font(.novoNordiskBody)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.novoNordiskBlue)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
    .background(Color.white)
    .cornerRadius(25)
    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
    .background(Color.novoNordiskBackgroundGrey)
}
