import SwiftUI

struct NewsBookmarksView: View {
    var body: some View {
        VStack {
            Text("NewsBookmarksView")
            .font(.system(size: 24))
            .foregroundColor(Color.novoNordiskTextGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}
