import SwiftUI

// MARK: - NovoNordiskCheckbox
struct NovoNordiskCheckbox: View {
    let title: String
    @Binding var isChecked: Bool
    let style: NovoNordiskCheckboxStyle
    let isEnabled: Bool
    let onChanged: ((Bool) -> Void)?
    
    init(
        title: String,
        isChecked: Binding<Bool>,
        style: NovoNordiskCheckboxStyle = .standard,
        isEnabled: Bool = true,
        onChanged: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self._isChecked = isChecked
        self.style = style
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }
    
    var body: some View {
        Button(action: {
            if isEnabled {
                isChecked.toggle()
                onChanged?(isChecked)
            }
        }) {
            HStack(spacing: style.spacing) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(
                            checkboxBorderColor,
                            lineWidth: style.borderWidth
                        )
                        .background(
                            RoundedRectangle(cornerRadius: style.cornerRadius)
                                .fill(checkboxBackgroundColor)
                        )
                        .frame(width: style.checkboxSize, height: style.checkboxSize)
                    
                    if isChecked {
                        FAIcon(
                            .check,
                            size: style.checkmarkSize,
                            color: style.checkmarkColor
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isChecked)
                
                // Title
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(isEnabled ? Color.novoNordiskTextGrey : Color.novoNordiskGrey)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(style.padding)
            .background(
                RoundedRectangle(cornerRadius: style.backgroundCornerRadius)
                    .fill(style.backgroundColor)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private var checkboxBorderColor: Color {
        if isChecked {
            return Color("NovoNordiskBlue")
        } else {
            return isEnabled ? Color("NovoNordiskBlue").opacity(0.3) : Color.gray.opacity(0.3)
        }
    }
    
    private var checkboxBackgroundColor: Color {
        if isChecked {
            return Color("NovoNordiskBlue")
        } else {
            return Color.white
        }
    }
}

// MARK: - NovoNordiskCheckboxStyle
enum NovoNordiskCheckboxStyle {
    case standard
    case compact
    case card
    
    var checkboxSize: CGFloat {
        switch self {
        case .standard, .card:
            return 20
        case .compact:
            return 16
        }
    }
    
    var checkmarkSize: CGFloat {
        switch self {
        case .standard, .card:
            return 12
        case .compact:
            return 10
        }
    }
    
    var checkmarkColor: Color {
        return Color.white
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .standard, .compact:
            return 3
        case .card:
            return 4
        }
    }
    
    var borderWidth: CGFloat {
        return 2
    }
    
    var spacing: CGFloat {
        switch self {
        case .standard, .card:
            return 12
        case .compact:
            return 8
        }
    }
    
    var titleFont: Font {
        switch self {
        case .standard, .card:
            return .novoNordiskBody
        case .compact:
            return .novoNordiskCaption
        }
    }
    
    var titleColor: Color {
        return Color.primary
    }
    
    var disabledTitleColor: Color {
        return Color.gray.opacity(0.6)
    }
    
    var backgroundColor: Color {
        switch self {
        case .standard, .compact:
            return Color.clear
        case .card:
            return Color.white
        }
    }
    
    var backgroundCornerRadius: CGFloat {
        switch self {
        case .standard, .compact:
            return 0
        case .card:
            return 8
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .standard, .compact:
            return EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        case .card:
            return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("NovoNordisk Checkbox Examples")
            .font(.title2)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 15) {
            // Standard checkboxes
            Text("Standard Style")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            NovoNordiskCheckbox(
                title: "Wyrażam zgodę na przetwarzanie danych osobowych",
                isChecked: .constant(true),
                style: .standard
            )
            
            NovoNordiskCheckbox(
                title: "Chcę otrzymywać newsletter",
                isChecked: .constant(false),
                style: .standard
            )
            
            // Compact style
            Text("Compact Style")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            NovoNordiskCheckbox(
                title: "Pamiętaj mnie",
                isChecked: .constant(true),
                style: .compact
            )
            
            // Card style
            Text("Card Style")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            NovoNordiskCheckbox(
                title: "Prowadzę działalność gospodarczą",
                isChecked: .constant(false),
                style: .card
            )
            
            // Disabled
            Text("Disabled")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            NovoNordiskCheckbox(
                title: "Opcja niedostępna",
                isChecked: .constant(false),
                style: .standard,
                isEnabled: false
            )
        }
        
        Spacer()
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
}
