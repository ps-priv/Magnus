import SwiftUI
import PopupView

// Reusable toast presenter built on top of Exyte PopupView
extension View {
    /// Presents a toast using `ToastView` with sensible defaults.
    /// - Parameters:
    ///   - isPresented: Binding that controls toast visibility.
    ///   - message: Message to display in the toast.
    ///   - type: Toast type determining accent color and icon.
    ///   - autohideIn: Seconds before the toast auto-hides. Pass `nil` to keep it persistent.
    ///   - verticalPadding: Vertical safe-area padding for the floater.
    ///   - horizontalPadding: Horizontal padding for the floater.
    /// - Returns: Modified view that can show a toast.
    func showSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.popup(isPresented: isPresented) {
            content()
        } customize: {
            $0
                .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: false))
                .position(.bottom)
                .dragToDismiss(true)
        }
    }
}
