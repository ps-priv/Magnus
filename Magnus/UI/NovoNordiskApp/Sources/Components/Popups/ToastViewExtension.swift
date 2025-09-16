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
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        type: ToastType = .info,
        autohideIn: Double? = 5,
        verticalPadding: CGFloat = 30,
        horizontalPadding: CGFloat = 16
    ) -> some View {
        self.popup(isPresented: isPresented) {
            ToastView.createToast(message: message, type: type)
        } customize: {
            $0
                .type(.floater(
                    verticalPadding: verticalPadding,
                    horizontalPadding: horizontalPadding,
                    useSafeAreaInset: true
                ))
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .position(.bottom)
                .autohideIn(autohideIn)
        }
    }

    /// Convenience: success toast
    func successToast(
        isPresented: Binding<Bool>,
        message: String,
        autohideIn: Double? = 3
    ) -> some View {
        toast(isPresented: isPresented, message: message, type: .success, autohideIn: autohideIn)
    }

    /// Convenience: error toast
    func errorToast(
        isPresented: Binding<Bool>,
        message: String,
        autohideIn: Double? = 3
    ) -> some View {
        toast(isPresented: isPresented, message: message, type: .error, autohideIn: autohideIn)
    }
}
