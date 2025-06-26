import SwiftUI

// MARK: - NovoNordiskIconButton
struct NovoNordiskIconButton: View {
    let icon: FontAwesome.Icon
    let title: String?
    let action: () -> Void
    let style: NovoNordiskIconButtonStyle
    let isEnabled: Bool
    
    init(
        icon: FontAwesome.Icon,
        title: String? = nil,
        style: NovoNordiskIconButtonStyle = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: style.spacing) {
                FAIcon(
                    icon, 
                    size: style.iconSize, 
                    color: isEnabled ? style.iconColor : style.disabledIconColor
                )
                
                if let title = title {
                    Text(title)
                        .font(style.textFont)
                        .foregroundColor(isEnabled ? style.textColor : style.disabledTextColor)
                }
            }
            .frame(maxWidth: style.isFullWidth ? .infinity : nil)
            .frame(height: style.height)
            .padding(.horizontal, style.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(isEnabled ? style.backgroundColor : style.disabledBackgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isEnabled ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

// MARK: - NovoNordiskIconButtonStyle
enum NovoNordiskIconButtonStyle {
    case primary
    case secondary
    case outline
    case iconOnly
    case small
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color("NovoNordiskBlue")
        case .secondary:
            return Color.gray.opacity(0.1)
        case .outline, .iconOnly:
            return Color.clear
        case .small:
            return Color("NovoNordiskBlue")
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .small:
            return Color.white
        case .secondary, .outline, .iconOnly:
            return Color("NovoNordiskBlue")
        }
    }
    
    var iconColor: Color {
        switch self {
        case .primary, .small:
            return Color.white
        case .secondary, .outline, .iconOnly:
            return Color("NovoNordiskBlue")
        }
    }
    
    var borderColor: Color {
        switch self {
        case .outline:
            return Color("NovoNordiskBlue")
        case .primary, .secondary, .iconOnly, .small:
            return Color.clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outline:
            return 2
        case .primary, .secondary, .iconOnly, .small:
            return 0
        }
    }
    
    var height: CGFloat {
        switch self {
        case .primary, .secondary, .outline:
            return 50
        case .iconOnly:
            return 44
        case .small:
            return 36
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .primary, .secondary, .outline:
            return 16
        case .iconOnly:
            return 12
        case .small:
            return 12
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .primary, .secondary, .outline:
            return 18
        case .iconOnly:
            return 20
        case .small:
            return 14
        }
    }
    
    var textFont: Font {
        switch self {
        case .primary, .secondary, .outline:
            return .system(size: 16, weight: .semibold)
        case .iconOnly:
            return .system(size: 16, weight: .semibold)
        case .small:
            return .system(size: 14, weight: .medium)
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .primary, .secondary, .outline:
            return 8
        case .iconOnly:
            return 0
        case .small:
            return 6
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .primary, .secondary, .outline:
            return 8
        case .iconOnly:
            return 22
        case .small:
            return 6
        }
    }
    
    var isFullWidth: Bool {
        switch self {
        case .primary, .secondary, .outline:
            return true
        case .iconOnly, .small:
            return false
        }
    }
    
    var disabledBackgroundColor: Color {
        return Color.gray.opacity(0.3)
    }
    
    var disabledTextColor: Color {
        return Color.gray.opacity(0.6)
    }
    
    var disabledIconColor: Color {
        return Color.gray.opacity(0.6)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("NovoNordisk Icon Buttons")
                .font(.title2)
                .fontWeight(.bold)
            
            // Primary buttons with icons
            VStack(spacing: 15) {
                NovoNordiskIconButton(icon: .user, title: "Profil użytkownika", style: .primary) {
                    print("Profile tapped")
                }
                
                NovoNordiskIconButton(icon: .email, title: "Wyślij wiadomość", style: .secondary) {
                    print("Email tapped")
                }
                
                NovoNordiskIconButton(icon: .save, title: "Zapisz zmiany", style: .outline) {
                    print("Save tapped")
                }
            }
            
            // Icon only buttons
            Text("Icon Only")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            HStack(spacing: 15) {
                NovoNordiskIconButton(icon: .home, style: .iconOnly) {
                    print("Home tapped")
                }
                
                NovoNordiskIconButton(icon: .search, style: .iconOnly) {
                    print("Search tapped")
                }
                
                NovoNordiskIconButton(icon: .bell, style: .iconOnly) {
                    print("Notifications tapped")
                }
                
                NovoNordiskIconButton(icon: .menu, style: .iconOnly) {
                    print("Menu tapped")
                }
            }
            
            // Small buttons
            Text("Small Buttons")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            HStack(spacing: 10) {
                NovoNordiskIconButton(icon: .edit, title: "Edytuj", style: .small) {
                    print("Edit tapped")
                }
                
                NovoNordiskIconButton(icon: .delete, title: "Usuń", style: .small) {
                    print("Delete tapped")
                }
            }
            
            // Medical icons (NovoNordisk specific)
            Text("Medical Icons")
                .font(.headline)
                .foregroundColor(Color("NovoNordiskBlue"))
            
            VStack(spacing: 15) {
                NovoNordiskIconButton(icon: .heart, title: "Monitor zdrowia", style: .primary) {
                    print("Health monitor tapped")
                }
                
                NovoNordiskIconButton(icon: .pills, title: "Moje leki", style: .secondary) {
                    print("Medications tapped")
                }
            }
            
            Spacer()
        }
        .padding()
    }
} 