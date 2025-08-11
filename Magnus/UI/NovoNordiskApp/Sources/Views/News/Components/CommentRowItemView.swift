import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct CommentRowItemView: View {
    let comment: Comment    

    init(comment: Comment) {
        self.comment = comment
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    FAIcon(
                        FontAwesome.Icon.userCircle,    
                        type: .thin,
                        size: 25,
                        color: Color.novoNordiskBlue
                    )
                    VStack(alignment: .leading) {
                        Text(comment.author.name)
                            .font(.novoNordiskAuthorName)
                        Text(comment.author.groups)
                            .font(.novoNordiskAuthorGroups)
                            .foregroundColor(Color.novoNordiskBlue)
                    }
                }
                Spacer()
                Text(PublishedDateHelper.formatPublishDate(comment.created_at))
                    .font(.system(size: 10))
                    .foregroundColor(Color.novoNordiskBlue)
            }

            HStack {
                Text(comment.message)
                    .font(.novoNordiskRegularText)
            }
        }
    }
}

#Preview {
    let comment: Comment = Comment(id: "1", 
    message: "aaa Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", 
    created_at: "2025-08-07 20:22:37", 
    author: Author(id: "1", name: "Joanna Skarżyńska-Kotyńska", groups: "Kardiologia, Badania i rozwój"))
    VStack {
        CommentRowItemView(comment: comment)
    }
    .background(Color.white)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
