import SwiftUI

struct Dashboard: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedTopBar(title: "Start")
                Spacer()
                BottomMenu(selectedTab: .constant(.start))
            }
        }
    }
}

#Preview("Dashboard") {
    Dashboard()
}


