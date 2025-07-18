import SwiftUI

// MARK: - NovoNordiskErrorView
struct NovoNordiskErrorView: View {
    let error: ErrorDisplayModel
    let onDismiss: (() -> Void)?
    let style: NovoNordiskErrorStyle
    
    @State private var shakeOffset: CGFloat = 0
    @State private var isVisible: Bool = false
    
    init(
        error: ErrorDisplayModel,
        style: NovoNordiskErrorStyle = .standard,
        onDismiss: (() -> Void)? = nil
    ) {
        self.error = error
        self.style = style
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        HStack(spacing: style.iconSpacing) {
            // Error icon
            if style.showIcon {
                FAIcon(
                    error.type.icon,
                    size: style.iconSize,
                    color: error.type.iconColor
                )
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.3).delay(0.1), value: error.type.icon)
            }
            
            // Error content
            VStack(alignment: .leading, spacing: 4) {
                if let title = error.title {
                    Text(title)
                        .font(style.titleFont)
                        .foregroundColor(error.type.titleColor)
                }
                
                Text(error.message)
                    .font(style.messageFont)
                    .foregroundColor(error.type.messageColor)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Dismiss button
            if onDismiss != nil {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onDismiss?()
                    }
                }) {
                    FAIcon(
                        .close,
                        size: style.dismissButtonSize,
                        color: error.type.messageColor.opacity(0.6)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(1.0)
                .onHover { isHovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        // Hover effect for dismiss button
                    }
                }
            }
        }
        .padding(style.padding)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(error.type.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(error.type.borderColor, lineWidth: style.borderWidth)
                )
        )
        .shadow(
            color: error.type.shadowColor,
            radius: style.shadowRadius,
            x: 0,
            y: style.shadowOffset
        )
        .offset(x: shakeOffset)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale),
            removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale)
        ))
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
                isVisible = true
            }
            
            // Shake effect for critical errors
            if error.type == .error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    shakeAnimation()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func shakeAnimation() {
        withAnimation(.easeInOut(duration: 0.1)) {
            shakeOffset = -5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = -3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 0
            }
        }
    }
}

// MARK: - ErrorDisplayModel
struct ErrorDisplayModel {
    let type: ErrorType
    let title: String?
    let message: String
    
    init(type: ErrorType = .error, title: String? = nil, message: String) {
        self.type = type
        self.title = title
        self.message = message
    }
}

// MARK: - ErrorType
enum ErrorType {
    case error
    case warning
    case info
    case success
    
    var icon: FontAwesome.Icon {
        switch self {
        case .error:
            return .exclamationTriangle
        case .warning:
            return .exclamation
        case .info:
            return .info
        case .success:
            return .check
        }
    }
    
    var iconColor: Color {
        switch self {
        case .error:
            return .red
        case .warning:
            return .orange
        case .info:
            return Color("NovoNordiskBlue")
        case .success:
            return .green
        }
    }
    
    var titleColor: Color {
        switch self {
        case .error:
            return .red
        case .warning:
            return .orange
        case .info:
            return Color("NovoNordiskBlue")
        case .success:
            return .green
        }
    }
    
    var messageColor: Color {
        switch self {
        case .error:
            return .red.opacity(0.8)
        case .warning:
            return .orange.opacity(0.8)
        case .info:
            return Color("NovoNordiskBlue").opacity(0.8)
        case .success:
            return .green.opacity(0.8)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .error:
            return .red.opacity(0.1)
        case .warning:
            return .orange.opacity(0.1)
        case .info:
            return Color("NovoNordiskBlue").opacity(0.1)
        case .success:
            return .green.opacity(0.1)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .error:
            return .red.opacity(0.3)
        case .warning:
            return .orange.opacity(0.3)
        case .info:
            return Color("NovoNordiskBlue").opacity(0.3)
        case .success:
            return .green.opacity(0.3)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .error:
            return .red.opacity(0.2)
        case .warning:
            return .orange.opacity(0.2)
        case .info:
            return Color("NovoNordiskBlue").opacity(0.2)
        case .success:
            return .green.opacity(0.2)
        }
    }
}

// MARK: - NovoNordiskErrorStyle
struct NovoNordiskErrorStyle {
    let showIcon: Bool
    let iconSize: CGFloat
    let iconSpacing: CGFloat
    let titleFont: Font
    let messageFont: Font
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let dismissButtonSize: CGFloat
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    
    static let standard = NovoNordiskErrorStyle(
        showIcon: true,
        iconSize: 20,
        iconSpacing: 12,
        titleFont: .novoNordiskCaptionBold,
        messageFont: .novoNordiskCaption,
        padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
        cornerRadius: 8,
        borderWidth: 1,
        dismissButtonSize: 16,
        shadowRadius: 2,
        shadowOffset: 1
    )
    
    static let compact = NovoNordiskErrorStyle(
        showIcon: true,
        iconSize: 16,
        iconSpacing: 8,
        titleFont: .novoNordiskCaption,
        messageFont: .novoNordiskFootnote,
        padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
        cornerRadius: 6,
        borderWidth: 1,
        dismissButtonSize: 14,
        shadowRadius: 1,
        shadowOffset: 0.5
    )
    
    static let minimal = NovoNordiskErrorStyle(
        showIcon: false,
        iconSize: 0,
        iconSpacing: 0,
        titleFont: .novoNordiskCaption,
        messageFont: .novoNordiskCaption,
        padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
        cornerRadius: 4,
        borderWidth: 0,
        dismissButtonSize: 12,
        shadowRadius: 0,
        shadowOffset: 0
    )
    
    static let animated = NovoNordiskErrorStyle(
        showIcon: true,
        iconSize: 22,
        iconSpacing: 14,
        titleFont: .novoNordiskCaptionBold,
        messageFont: .novoNordiskCaption,
        padding: EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20),
        cornerRadius: 12,
        borderWidth: 1.5,
        dismissButtonSize: 18,
        shadowRadius: 4,
        shadowOffset: 2
    )
}

// MARK: - Convenience Extensions
extension NovoNordiskErrorView {
    // Quick error creation
    static func error(
        _ message: String,
        title: String? = nil,
        style: NovoNordiskErrorStyle = .standard,
        onDismiss: (() -> Void)? = nil
    ) -> NovoNordiskErrorView {
        return NovoNordiskErrorView(
            error: ErrorDisplayModel(type: .error, title: title, message: message),
            style: style,
            onDismiss: onDismiss
        )
    }
    
    static func warning(
        _ message: String,
        title: String? = nil,
        style: NovoNordiskErrorStyle = .standard,
        onDismiss: (() -> Void)? = nil
    ) -> NovoNordiskErrorView {
        return NovoNordiskErrorView(
            error: ErrorDisplayModel(type: .warning, title: title, message: message),
            style: style,
            onDismiss: onDismiss
        )
    }
    
    static func info(
        _ message: String,
        title: String? = nil,
        style: NovoNordiskErrorStyle = .standard,
        onDismiss: (() -> Void)? = nil
    ) -> NovoNordiskErrorView {
        return NovoNordiskErrorView(
            error: ErrorDisplayModel(type: .info, title: title, message: message),
            style: style,
            onDismiss: onDismiss
        )
    }
    
    static func success(
        _ message: String,
        title: String? = nil,
        style: NovoNordiskErrorStyle = .standard,
        onDismiss: (() -> Void)? = nil
    ) -> NovoNordiskErrorView {
        return NovoNordiskErrorView(
            error: ErrorDisplayModel(type: .success, title: title, message: message),
            style: style,
            onDismiss: onDismiss
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Standard error
        NovoNordiskErrorView.error(
            "Nieprawidłowy email lub hasło",
            title: "Błąd logowania"
        ) {
            print("Error dismissed")
        }
        
        // Warning without title
        NovoNordiskErrorView.warning(
            "Sesja wygaśnie za 5 minut"
        )
        
        // Info message
        NovoNordiskErrorView.info(
            "Sprawdź swój email w celu potwierdzenia konta",
            title: "Potwierdź email"
        )
        
        // Success message
        NovoNordiskErrorView.success(
            "Pomyślnie zalogowano",
            title: "Sukces"
        )
        
        // Compact style
        NovoNordiskErrorView.error(
            "Pole jest wymagane",
            style: .compact
        )
        
        // Minimal style
        NovoNordiskErrorView.error(
            "Błąd walidacji",
            style: .minimal
        )
        
        // Animated style
        NovoNordiskErrorView.error(
            "Błąd logowania z animacjami",
            title: "Błąd krytyczny",
            style: .animated
        ) {
            print("Animated error dismissed")
        }
    }
    .padding()
} 
