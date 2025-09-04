import SwiftUI

// MARK: - NovoNordiskTextArea
struct NovoNordiskTextArea: View {
    let placeholder: String
    @Binding var text: String
    let style: NovoNordiskTextAreaStyle
    let isEnabled: Bool
    
    @FocusState private var isFocused: Bool
    
    init(
        placeholder: String,
        text: Binding<String>,
        style: NovoNordiskTextAreaStyle = .standard,
        isEnabled: Bool = true
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !style.title.isEmpty {
                Text(style.title)
                    .font(style.titleFont)
                    .foregroundColor(isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskTextGrey)

            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .novoNordiskTextAreaStyle(isEnabled: isEnabled)
                    .focused($isFocused)
                    .disabled(!isEnabled)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.novoNordiskBody)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 22)
                        .allowsHitTesting(false)
                }
            }
            
            if !style.helperText.isEmpty {
                Text(style.helperText)
                    .font(.novoNordiskFootnote)
                    .foregroundColor(.gray)
            }
        }
        .background(Color.clear)
    }
}

// MARK: - TextArea Style Extension
private extension View {
    func novoNordiskTextAreaStyle(isEnabled: Bool = true) -> some View {
        self
            .font(.novoNordiskBody)
            .foregroundColor(isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskTextGrey)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .frame(minHeight: 120, alignment: .top)
            //.background(isEnabled ? Color.white : Color.white)
            .scrollContentBackground(.hidden)
            .background(Color.white)
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

// MARK: - NovoNordiskTextAreaStyle
struct NovoNordiskTextAreaStyle {
    let title: String
    let helperText: String
    let isTitleBold: Bool
    
    static let standard = NovoNordiskTextAreaStyle(title: "", helperText: "", isTitleBold: false)
    
    static func withTitle(_ title: String, bold: Bool = false) -> NovoNordiskTextAreaStyle {
        NovoNordiskTextAreaStyle(title: title, helperText: "", isTitleBold: bold)
    }
    
    static func withHelper(_ helperText: String) -> NovoNordiskTextAreaStyle {
        NovoNordiskTextAreaStyle(title: "", helperText: helperText, isTitleBold: false)
    }
    
    static func complete(title: String, helperText: String, boldTitle: Bool = false) -> NovoNordiskTextAreaStyle {
        NovoNordiskTextAreaStyle(title: title, helperText: helperText, isTitleBold: boldTitle)
    }
    
    var titleFont: Font {
        return isTitleBold ? .novoNordiskCaptionBold : .novoNordiskCaption
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        NovoNordiskTextArea(
            placeholder: "Wpisz dłuższy tekst...",
            text: .constant("")
        )
        
        NovoNordiskTextArea(
            placeholder: "Opis...",
            text: .constant(""),
            style: .withTitle("Opis", bold: true)
        )
        
        NovoNordiskTextArea(
            placeholder: "Dodatkowe informacje",
            text: .constant("Jakiś przykładowy tekst"),
            style: .complete(title: "Notatki", helperText: "Możesz tu wpisać dodatkowe uwagi", boldTitle: false)
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.novoNordiskBackgroundGrey)    
    .padding()
}
