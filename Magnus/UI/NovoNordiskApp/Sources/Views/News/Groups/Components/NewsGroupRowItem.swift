import SwiftUI
import MagnusDomain

struct NewsGroupRowItem: View {

    let group: NewsGroup
    let navigateToNewsInGroup: () -> Void


    init(group: NewsGroup, navigateToNewsInGroup: @escaping () -> Void) {
        self.group = group
        self.navigateToNewsInGroup = navigateToNewsInGroup
    }

    var body: some View {

        Button(action: navigateToNewsInGroup) {
            Text(group.name)
            .font(.novoNordiskRegularText)
            .fontWeight(.bold)
            .foregroundColor(.novoNordiskTextGrey)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        NewsGroupRowItem(group: NewsGroup(id: "1", name: "Badania i rozwój" ), navigateToNewsInGroup: {})
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskLighGreyForPanelBackground)
}

