import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsGroupsCardView: View {

    let groups: [NewsGroup]
    let navigateToNewsInGroup: (String) -> Void

    init(groups: [NewsGroup], navigateToNewsInGroup: @escaping (String) -> Void) {
        self.groups = groups
        self.navigateToNewsInGroup = navigateToNewsInGroup
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(groups, id: \ .id) { group in
                NewsGroupRowItem(group: group, navigateToNewsInGroup: {
                    navigateToNewsInGroup(group.id)
                })
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    let response = ApiNewsMock.getGroups()

    NewsGroupsCardView(groups: response.groups, navigateToNewsInGroup: { _ in })
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskLighGreyForPanelBackground)
}
