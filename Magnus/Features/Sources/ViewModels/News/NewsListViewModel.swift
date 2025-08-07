import Foundation
import Combine
import MagnusDomain
import MagnusFeatures

@MainActor
public class NewsListViewModel: ObservableObject {
    @Published public var news: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    private let newsService: ApiNewsService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService) {
        self.newsService = newsService

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
            let data: GetNewsResponse = try await newsService.getNews()
            print("data: \(data)")

            await MainActor.run {
                print("data: \(data)")
                news = data.news
                isLoading = false
                print("news: \(news)")  
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsListViewModel.loadDashboard")
        }
    }
    
} 