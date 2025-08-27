import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsGroupsCardView: View {

    let groups: [NewsGroup]

    init(groups: [NewsGroup]) {
        self.groups = groups
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(groups, id: \ .id) { group in
                NewsGroupRowItem(group: group)
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    let response = ApiNewsMock.getGroups()

    NewsGroupsCardView(groups: response.groups)
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskLighGreyForPanelBackground)
}
