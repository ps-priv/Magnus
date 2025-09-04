import SwiftUI

struct QrCodeButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            FAIcon(
                .qrcode,
                type: .light,
                size: 21,
                color: Color.novoNordiskTextGrey
            )
            .frame(width: 40, height: 40)
        }
        .background(Color.novoNordiskLightGrey)
        .clipShape(Circle())
    }
}
