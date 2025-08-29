import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsInGroupListViewModel: ObservableObject {

    let groupId: String
    @Published public var news: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    private let newsService: ApiNewsService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, groupId: String) {
        self.newsService = newsService
        self.groupId = groupId

        Task {
            await loadData()
        }
    }

    // MARK: - Setup
    /// Load dashboard data
    public func loadData() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetNewsResponse = try await newsService.getNewsInGroup(groupId: groupId)

            await MainActor.run {
                news = data.news
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsListViewModel.loadData")
        }
    }

    public func changeNewsBookmarkStatus(id: String) async {
        do {
            try await newsService.changeNewsBookmarkStatus(id: id)
        } catch let error {
            SentryHelper.capture(error: error, action: "NewsListViewModel.changeNewsBookmarkStatus")
        }
    }

    public func deleteNews(id: String) async {
        // do {
        //     try await newsService.deleteNews(id: id)
        // } catch let error {
        //     SentryHelper.capture(error: error, action: "NewsListViewModel.deleteNews")
        // }
    }  
} 