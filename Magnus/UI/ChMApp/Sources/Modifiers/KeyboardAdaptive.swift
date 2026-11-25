import SwiftUI

#if os(iOS)
/// ViewModifier that automatically adjusts view padding when keyboard appears/disappears
struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.easeOut(duration: 0.25)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = 0
                }
            }
    }
}

/// ViewModifier that dismisses keyboard when tapping outside
struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            )
    }
}

/// ViewModifier with reduced padding (half of keyboard height) for views with GeometryReader
struct KeyboardAdaptiveReduced: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight / 2)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.easeOut(duration: 0.25)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = 0
                }
            }
    }
}

/// ViewModifier with medium offset (moves view up by 75% of keyboard height)
struct KeyboardAdaptiveMedium: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: keyboardHeight > 0 ? -keyboardHeight * 0.75 : 0)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.easeOut(duration: 0.25)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = 0
                }
            }
    }
}
#endif

// MARK: - View Extensions
extension View {
    /// Automatically adjusts view padding when keyboard appears/disappears
    func keyboardAdaptive() -> some View {
        #if os(iOS)
        return modifier(KeyboardAdaptive())
        #else
        return self
        #endif
    }
    
    /// Adjusts view padding with reduced amount (half) - for views with GeometryReader
    func keyboardAdaptiveReduced() -> some View {
        #if os(iOS)
        return modifier(KeyboardAdaptiveReduced())
        #else
        return self
        #endif
    }
    
    /// Adjusts view padding with medium amount (75%) - balanced for most cases
    func keyboardAdaptiveMedium() -> some View {
        #if os(iOS)
        return modifier(KeyboardAdaptiveMedium())
        #else
        return self
        #endif
    }
    
    /// Dismisses keyboard when tapping outside text fields
    func dismissKeyboardOnTap() -> some View {
        #if os(iOS)
        return modifier(DismissKeyboardOnTap())
        #else
        return self
        #endif
    }
    
    /// Combines both keyboard adaptive and dismiss on tap
    func keyboardResponsive() -> some View {
        self
            .keyboardAdaptive()
            .dismissKeyboardOnTap()
    }
}
