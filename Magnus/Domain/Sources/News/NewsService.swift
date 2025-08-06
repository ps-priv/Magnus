public protocol NewsServiceProtocol {
    func getNews() async throws -> GetNewsResponse
    func getNewsById(id: String) async throws -> NewsDetails
}