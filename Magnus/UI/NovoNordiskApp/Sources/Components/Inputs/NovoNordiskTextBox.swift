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
                    .font(.novoNordiskCaption)
                    .foregroundColor(Color("NovoNordiskBlue"))
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle()
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle()
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
    func textFieldStyle() -> some View {
        self
            .font(.novoNordiskBody)
            .foregroundColor(Color("NovoNordiskBlue"))
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("NovoNordiskBlue"), lineWidth: 1.5)
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - NovoNordiskTextBoxStyle
struct NovoNordiskTextBoxStyle {
    let title: String
    let helperText: String
    
    static let standard = NovoNordiskTextBoxStyle(title: "", helperText: "")
    
    static func withTitle(_ title: String) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: title, helperText: "")
    }
    
    static func withHelper(_ helperText: String) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: "", helperText: helperText)
    }
    
    static func complete(title: String, helperText: String) -> NovoNordiskTextBoxStyle {
        NovoNordiskTextBoxStyle(title: title, helperText: helperText)
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
        
        // With title
        NovoNordiskTextBox(
            placeholder: "jan.kowalski@email.com",
            text: .constant(""),
            style: .withTitle("Email")
        )
        
        // With helper text
        NovoNordiskTextBox(
            placeholder: "Minimum 8 znaków",
            text: .constant(""),
            style: .withHelper("Hasło musi zawierać co najmniej 8 znaków")
        )
        
        // Complete with title and helper
        NovoNordiskTextBox(
            placeholder: "Potwierdź hasło",
            text: .constant(""),
            style: .complete(title: "Powtórz hasło", helperText: "Hasła muszą być identyczne"),
            isSecure: true
        )
        
        // Filled example
        NovoNordiskTextBox(
            placeholder: "Nazwa użytkownika",
            text: .constant("jan.kowalski"),
            style: .withTitle("Użytkownik")
        )
    }
    .padding()
} 