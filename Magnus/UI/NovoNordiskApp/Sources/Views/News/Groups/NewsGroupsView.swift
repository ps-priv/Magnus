import SwiftUI

struct NewsGroupsView: View {
    var body: some View {
        VStack {
            Text("NewsGroupsView")
            .font(.system(size: 24))
            .foregroundColor(Color.novoNordiskTextGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}

