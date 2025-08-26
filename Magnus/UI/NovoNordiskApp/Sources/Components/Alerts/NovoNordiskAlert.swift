import SwiftUI
import MagnusFeatures

struct NovoNordiskAlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    let title: String
    let message: String?
    let icon: FontAwesome.Icon?

    let primaryTitle: String
    let primaryStyle: NovoNordiskAlertButtonStyle
    let primaryAction: () -> Void

    let secondaryTitle: String?
    let secondaryStyle: NovoNordiskAlertButtonStyle
    let secondaryAction: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
                .blur(radius: isPresented ? 0 : 0)

            if isPresented {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)

                // Alert Card
                alertCard
                    .padding(.horizontal, 28)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }

    @ViewBuilder
    private var alertCard: some View {
        VStack(spacing: 16) {
            if let icon = icon {
                FAIcon(icon, type: .regular, size: 28, color: .novoNordiskBlue)
                    .padding(.top, 8)
            }

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                .multilineTextAlignment(.center)

            if let message = message, !message.isEmpty {
                Text(message)
                    .font(.body)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 10) {
                if let secondaryTitle = secondaryTitle, let secondaryAction = secondaryAction {
                    button(title: secondaryTitle, style: secondaryStyle) {
                        isPresented = false
                        secondaryAction()
                    }
                }

                button(title: primaryTitle, style: primaryStyle) {
                    isPresented = false
                    primaryAction()
                }
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }

    @ViewBuilder
    private func button(title: String, style: NovoNordiskAlertButtonStyle, action: @escaping () -> Void) -> some View {
        switch style {
        case .primary:
            NovoNordiskButton(title: title, style: .primary, action: action)
        case .secondary:
            NovoNordiskButton(title: title, style: .outline, action: action)
        case .destructive:
            NovoNordiskButton(title: title, style: .danger, action: action)
        case .cancel:
            NovoNordiskButton(title: title, style: .outline, action: action)
        }
    }
}

enum NovoNordiskAlertButtonStyle {
    case primary
    case secondary
    case destructive
    case cancel
}

extension View {
    internal func novoNordiskAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: FontAwesome.Icon? = nil,
        primaryTitle: String,
        primaryStyle: NovoNordiskAlertButtonStyle = .primary,
        primaryAction: @escaping () -> Void,
        secondaryTitle: String? = nil,
        secondaryStyle: NovoNordiskAlertButtonStyle = .cancel,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            NovoNordiskAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                icon: icon,
                primaryTitle: primaryTitle,
                primaryStyle: primaryStyle,
                primaryAction: primaryAction,
                secondaryTitle: secondaryTitle,
                secondaryStyle: secondaryStyle,
                secondaryAction: secondaryAction
            )
        )
    }
}
