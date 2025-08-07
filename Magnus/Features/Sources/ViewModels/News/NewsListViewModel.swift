import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsListViewModel: ObservableObject {
    @Published public var news: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    private let newsService: NewsServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(newsService: NewsServiceProtocol = DIContainer.shared.newsService) {
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
            let data = try await newsService.getNews()

            await MainActor.run {
                news = data.news
                isLoading = false
   
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsListViewModel.loadDashboard")
        }
    }
    
} 