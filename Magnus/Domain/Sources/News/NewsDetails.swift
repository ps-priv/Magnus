struct NewsDetails {
    let id, publishDate, title: String
    let image: String
    let highlightEntry, blockComments, blockReactions: Int
    let author: Author
    let isBookmarked: Bool
    let readCount, reactionsCount, commentsCount: Int
    let comments, reactions, read, attachments: [Any?]
    let tags, groups: [Any?]
}