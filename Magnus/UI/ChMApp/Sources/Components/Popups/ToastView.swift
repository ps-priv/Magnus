import SwiftUI

enum ToastType {
    case info
    case success
    case error
}

struct ToastView: View {
    let message: String
    let type: ToastType
    var color: Color = .novoNordiskBlue

    init(message: String, type: ToastType = .info) {
        self.message = message
        self.type = type

        switch type {
            case .info:
                color = .novoNordiskBlue
            case .success:
                color = .novoNordiskLightBlue
            case .error:
                color = .novoNordiskOrangeRed
        }
    }

    var body: some View {

        HStack  {
            if (type == .success) {
                FAIcon(.circle_check, type: .light, size: 24, color: color)
            }

            if (type == .error) {
                FAIcon(.circle_error, type: .light, size: 24, color: color)
            }

            Text(message)
            .foregroundColor(color)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }

    public static func createToast(message: String, type: ToastType = .info) -> ToastView {
        return ToastView(message: message, type: type)
    }

    public static func createSuccessToast(message: String) -> ToastView {
        return ToastView(message: message, type: .success)
    }

    public static func createErrorToast(message: String) -> ToastView {
        return ToastView(message: message, type: .error)
    }
}

#Preview {
    VStack(alignment: .center, spacing: 20) {
        ToastView.createToast(message: "Hello World")

        ToastView.createSuccessToast(message: "Hello World")

        ToastView.createErrorToast(message: "Hello World")
    }
    .padding(50)
}