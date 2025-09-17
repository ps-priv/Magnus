import SwiftUI

// MARK: - NovoNordiskButton
struct NovoNordiskButton: View {
    let title: String
    let action: () -> Void
    let style: NovoNordiskButtonStyle
    let isEnabled: Bool
    
    init(
        title: String,
        style: NovoNordiskButtonStyle = .primary,
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
                .font(.novoNordiskButton)
                .foregroundColor(style.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isEnabled ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

// MARK: - NovoNordiskButtonStyle
enum NovoNordiskButtonStyle {
    case primary
    case secondary
    case disabled
    case outline
    case danger
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color("NovoNordiskBlue")
        case .secondary:
            return Color.gray.opacity(0.1)
        case .disabled:
            return Color.gray.opacity(0.3)
        case .outline:
            return Color.clear
        case .danger:
            return Color.red
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary:
            return Color.white
        case .secondary:
            return Color("NovoNordiskBlue")
        case .disabled:
            return Color.gray.opacity(0.6)
        case .outline:
            return Color("NovoNordiskBlue")
        case .danger:
            return Color.white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary:
            return Color.clear
        case .secondary:
            return Color.clear
        case .disabled:
            return Color.clear
        case .outline:
            return Color("NovoNordiskBlue")
        case .danger:
            return Color.clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary, .secondary, .danger:
            return 0
        case .outline:
            return 2
        case .disabled:
            return 0
        }
    }
    
    var disabledBackgroundColor: Color {
        return Color.gray.opacity(0.3)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        NovoNordiskButton(title: "Primary Button", style: .primary) {
            print("Primary tapped")
        }
        
        NovoNordiskButton(title: "Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }
        
        NovoNordiskButton(title: "Outline Button", style: .outline) {
            print("Outline tapped")
        }
        
        NovoNordiskButton(title: "Danger Button", style: .danger) {
            print("Danger tapped")
        }
        
        NovoNordiskButton(title: "Disabled Button", style: .primary, isEnabled: false) {
            print("Disabled tapped")
        }
    }
    .padding()
} 
