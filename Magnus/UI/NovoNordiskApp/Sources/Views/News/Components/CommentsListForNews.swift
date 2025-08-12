import SwiftUI
import MagnusDomain

struct CommentsListForNews: View {
    let comments: [Comment]

    init(comments: [Comment]) {
        self.comments = comments
    }

    var body: some View {
            LazyVStack(alignment: .leading) {
                ForEach(Array(comments.enumerated()), id: \.offset) { index, comment in
                    CommentRowItemView(comment: comment)
                        .padding(.vertical, 4)
                }
            }
    }
}
