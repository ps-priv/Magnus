import SwiftUI

struct NewsAddView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @State private var chips: [String] = []

    var body: some View {
        VStack {
            ChipView(chips: $chips, placeholder: "#Tag")
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
