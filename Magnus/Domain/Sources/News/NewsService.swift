public protocol NewsServiceProtocol {
    func getNews() async throws -> GetNewsResponse
    func getNewsById(id: String) async throws -> NewsDetails
    func changeNewsBookmarkStatus(id: String) async throws -> Void
}