import Foundation

public protocol NewsServiceProtocol {
    func getNews() async throws -> GetNewsResponse
    func getBookmarks() async throws -> GetNewsResponse
    func getNewsById(id: String) async throws -> NewsDetails
    func changeNewsBookmarkStatus(id: String) async throws -> Void
    func sendNewsReaction(id: String, reaction: ReactionEnum) async throws -> Void
    func markNewsAsRead(id: String) async throws -> Void
    func addCommentToNews(id: String, comment: String) async throws -> Void
    func getGroups() async throws -> GetGroupsResponse
    func addNews(title: String, content: String, image: Data?, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String]) async throws -> Void
}