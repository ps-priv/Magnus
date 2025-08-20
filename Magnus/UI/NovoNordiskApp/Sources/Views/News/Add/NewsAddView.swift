import SwiftUI

struct NewsAddView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            Text("NewsAddView")
            .font(.system(size: 24))
            .foregroundColor(Color.novoNordiskTextGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
