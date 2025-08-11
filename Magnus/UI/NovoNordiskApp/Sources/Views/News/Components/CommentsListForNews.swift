import SwiftUI
import MagnusDomain

struct CommentsListForNews: View {
    let comments: [Comment]

    var body: some View {
            LazyVStack(alignment: .leading) {
                ForEach(comments) { comment in
                    CommentRowItemView(comment: comment)
                    .padding(.vertical, 4)
                }
            }
    }
}
