import SwiftUI

// MARK: - NovoNordiskLinkButton
struct NovoNordiskLinkButton: View {
    let title: String
    let action: () -> Void
    let style: NovoNordiskLinkButtonStyle
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    init(
        title: String,
        style: NovoNordiskLinkButtonStyle = .standard,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(style.font)
                .foregroundColor(isEnabled ? style.textColor : style.disabledTextColor)
                .underline(style.showUnderline)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - NovoNordiskLinkButtonStyle
enum NovoNordiskLinkButtonStyle {
    case standard
    case small
    case large
    case underlined
    case subtitle
    
    var font: Font {
        switch self {
        case .standard:
            return .system(size: 16, weight: .medium)
        case .small:
            return .system(size: 14, weight: .medium)
        case .large:
            return .system(size: 18, weight: .semibold)
        case .underlined:
            return .system(size: 16, weight: .medium)
        case .subtitle:
            return .system(size: 14, weight: .regular)
        }
    }
    
    var textColor: Color {
        switch self {
        case .standard, .small, .large, .underlined:
            return Color("NovoNordiskBlue")
        case .subtitle:
            return Color("NovoNordiskBlue").opacity(0.8)
        }
    }
    
    var disabledTextColor: Color {
        return Color.gray.opacity(0.6)
    }
    
    var showUnderline: Bool {
        switch self {
        case .underlined:
            return true
        case .standard, .small, .large, .subtitle:
            return false
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("NovoNordisk Link Buttons")
            .font(.title2)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 15) {
            // Standard link button
            NovoNordiskLinkButton(title: "Standard Link", style: .standard) {
                print("Standard link tapped")
            }
            
            // Small link button
            NovoNordiskLinkButton(title: "Small Link", style: .small) {
                print("Small link tapped")
            }
            
            // Large link button
            NovoNordiskLinkButton(title: "Large Link", style: .large) {
                print("Large link tapped")
            }
            
            // Underlined link button
            NovoNordiskLinkButton(title: "Underlined Link", style: .underlined) {
                print("Underlined link tapped")
            }
            
            // Subtitle link button
            NovoNordiskLinkButton(title: "Subtitle Link", style: .subtitle) {
                print("Subtitle link tapped")
            }
            
            // Disabled link button
            NovoNordiskLinkButton(title: "Disabled Link", style: .standard, isEnabled: false) {
                print("Disabled link tapped")
            }
        }
        
        Divider()
        
        // Przykład użycia w kontekście
        VStack(spacing: 10) {
            Text("Nie masz konta?")
                .font(.body)
            
            NovoNordiskLinkButton(title: "Zarejestruj się tutaj", style: .underlined) {
                print("Register tapped")
            }
        }
        
        VStack(spacing: 10) {
            Text("Masz już konto?")
                .font(.body)
            
            NovoNordiskLinkButton(title: "Zaloguj się", style: .standard) {
                print("Login tapped")
            }
        }
        
        Spacer()
    }
    .padding()
} 