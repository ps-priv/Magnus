import SwiftUI

struct ActionSheetView<Content: View>: View {

    let content: Content
    let topPadding: CGFloat
    let fixedHeight: Bool
    let bgColor: Color

    init(topPadding: CGFloat = 100, fixedHeight: Bool = false, bgColor: Color = Color.white, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.topPadding = topPadding
        self.fixedHeight = fixedHeight
        self.bgColor = bgColor
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            VStack(spacing: 0) {
                Color.black
                    .opacity(0.2)
                    .frame(width: 30, height: 6)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                    .padding(.bottom, 10)

                content
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
            }
            .background(bgColor)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
}