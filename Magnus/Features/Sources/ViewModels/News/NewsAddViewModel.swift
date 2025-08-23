import Foundation
import Combine
import MagnusDomain

@MainActor
class NewsAddViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var title: String = ""
    @Published public var content: String = ""
    @Published public var image: Data?
    @Published public var selectedGroups: [NewsGroup] = []
    @Published public var attachments: [NewsAttachment] = []
    @Published public var tags: [String] = []

    private let newsService: ApiNewsService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService) {
        self.newsService = newsService
    }

    public func addNews() async {
        // await MainActor.run {
        //     isLoading = true
        //     hasError = false
        //     errorMessage = ""
        // }

        // do {
        //     let data: GetNewsResponse = try await newsService.getNews()

        //     await MainActor.run {
        //         news = data.news
        //         isLoading = false
        //     }
        // } catch let error {
        //     isLoading = false
        //     errorMessage = error.localizedDescription
        //     hasError = true
        //     SentryHelper.capture(error: error, action: "NewsListViewModel.loadData")
        // }
    }
}
