import Foundation
import UIKit

public enum HtmlHelper {

    /// Czy HTML zawiera widoczny tekst (po usunięciu znaczników, encji spacji i białych znaków).
    public static func hasVisibleText(_ html: String?) -> Bool {
        guard let html else { return false }
        return !plainText(fromHTML: html).isEmpty
    }

    /// Tekst bez znaczników HTML – fallback, gdy parsowanie się nie uda.
    public static func plainText(fromHTML html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Renderuje HTML do `AttributedString` z podaną czcionką i kolorem tekstu.
    /// Parser HTML `NSAttributedString` wymaga głównego wątku.
    @MainActor
    public static func attributedString(fromHTML html: String,
                                        fontFamily: String,
                                        fontSize: CGFloat,
                                        colorHex: String) -> AttributedString? {
        let styled = """
        <style>body{font-family:'\(fontFamily)',-apple-system;font-size:\(Int(fontSize))px;color:#\(colorHex);}</style>\(html)
        """
        guard let data = styled.data(using: .utf8),
              let ns = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        else { return nil }

        // Parser dokleja końcowy znak nowej linii – usuwamy go.
        while ns.string.hasSuffix("\n") {
            ns.deleteCharacters(in: NSRange(location: ns.length - 1, length: 1))
        }
        return try? AttributedString(ns, including: \.uiKit)
    }
}
