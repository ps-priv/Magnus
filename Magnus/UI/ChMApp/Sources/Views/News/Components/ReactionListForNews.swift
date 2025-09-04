import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct ReactionListForNews: View {
    let reactions: [Reaction]

    var body: some View {
            LazyVStack(alignment: .leading) {
                ForEach(reactions, id: \.self) { reaction in
                    ReactionRowItemView(reaction: reaction)
                        .padding(.vertical, 4)
                }
            }
    }
}