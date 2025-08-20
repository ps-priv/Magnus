import SwiftUI
import MagnusDomain

struct NewsGroupRowItem: View {

    let group: NewsGroup

    init(group: NewsGroup) {
        self.group = group
    }

    var body: some View {
       VStack {
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
        NewsGroupRowItem(group: NewsGroup(id: "1", name: "Badania i rozwój"))
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskLighGreyForPanelBackground)
}

