import SwiftUI

// MARK: - NovoNordiskTextBox
struct NovoNordiskTextBox: View {
    let placeholder: String
    @Binding var text: String
    let style: NovoNordiskTextBoxStyle
    let isSecure: Bool
    let isEnabled: Bool
    
    @FocusState private var isFocused: Bool
    
    init(
        placeholder: String,
        text: Binding<String>,
        style: NovoNordiskTextBoxStyle = .standard,
        isSecure: Bool = false,
        isEnabled: Bool = true
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.isSecure = isSecure
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !style.title.isEmpty {
                Text(style.title)
                    .font(style.titleFont)
                    .foregroundColor(isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskTextGrey)
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .novoNordiskTextFieldStyle(isEnabled: isEnabled)
                } else {
                    TextField(placeholder, text: $text)
                        .novoNordiskTextFieldStyle(isEnabled: isEnabled)
                }
            }
            .focused($isFocused)
            .disabled(!isEnabled)
            
            if !style.helperText.isEmpty {
                Text(style.helperText)
                    .font(.novoNordiskFootnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - TextField Style Extension
private extension View {
    func novoNordiskTextFieldStyle(isEnabled: Bool = true) -> some View {
        self
            .font(.novoNordiskBody)
            .foregroundColor(isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskTextGrey)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(isEnabled ? Color.white : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskGrey
                        , lineWidth: 1.5)
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - NovoNordiskTextBoxStyle
struct NovoNordiskTextBoxStyle {
    let title: String
    let helperText: String
    let isTitleBold: Bool
    
    static let standard = NovoNordiskTextBoxStyle(title: "", helperText: "", isTitleBold: false)
    
    static func withTitle(_ title: String, bold: Bool = false) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: title, helperText: "", isTitleBold: bold)
    }
    
    static func withHelper(_ helperText: String) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: "", helperText: helperText, isTitleBold: false)
    }
    
    static func complete(title: String, helperText: String, boldTitle: Bool = false) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: title, helperText: helperText, isTitleBold: boldTitle)
    }
    
    var titleFont: Font {
        return isTitleBold ? .novoNordiskCaptionBold : .novoNordiskCaption
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Standard text box
        NovoNordiskTextBox(
            placeholder: "Wpisz tekst...",
            text: .constant("")
        )
        
        // With title (bold)
        NovoNordiskTextBox(
            placeholder: "jan.kowalski@email.com",
            text: .constant(""),
            style: .withTitle("Email", bold: true),
        )
        
        // With helper text
        NovoNordiskTextBox(
            placeholder: "Minimum 8 znaków",
            text: .constant(""),
            style: .withHelper("Hasło musi zawierać co najmniej 8 znaków")
        )
        
        // Complete with title and helper (bold title)
        NovoNordiskTextBox(
            placeholder: "Potwierdź hasło",
            text: .constant(""),
            style: .complete(title: "Powtórz hasło", helperText: "Hasła muszą być identyczne", boldTitle: true),
            isSecure: true
        )
        
        // Filled example (normal title)
        NovoNordiskTextBox(
            placeholder: "Nazwa użytkownika",
            text: .constant("jan.kowalski"),
            style: .withTitle("Użytkownik", bold: false)
        )
    }
    .padding()
} 
