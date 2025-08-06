public struct GetNewsResponse: Hashable, Decodable {
    public let news: [News]

    public init(news: [News]) {
        self.news = news
    }
}