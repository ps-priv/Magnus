import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct ReactionRowItemView: View {
    let reaction: Reaction    

    init(reaction: Reaction) {
        self.reaction = reaction
    }
    
    var body: some View {
        HStack {
                HStack {
                    FAIcon(
                        FontAwesome.Icon.userCircle,    
                        type: .thin,
                        size: 25,
                        color: Color.novoNordiskBlue
                    )
                    VStack(alignment: .leading) {
                        Text(reaction.author.name)
                            .font(.novoNordiskAuthorName)
                        Text(reaction.author.groups)
                            .font(.novoNordiskAuthorGroups)
                            .foregroundColor(Color.novoNordiskBlue)
                    }
                }
                Spacer()
                FAIcon(
                    ReactionToIconHelper.getIcon(from: reaction.reaction),    
                    type: .thin,
                    size: 25,
                    color: Color.novoNordiskBlue
                )
            }
    }
}

#Preview {
    let reaction: Reaction = Reaction( 
        reaction: ReactionEnum.THUMBS_UP,
        author: Author(id: "1", name: "Joanna Skarżyńska-Kotyńska", groups: "Kardiologia, Badania i rozwój"))
    ReactionRowItemView(reaction: reaction)
    .background(Color.white)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}