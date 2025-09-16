import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsListViewModel: ObservableObject {
    @Published public var news: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var allowEdit: Bool = false
    @Published public var currentUserId: String = ""

    private let newsService: ApiNewsService
    private let authStorageService: AuthStorageService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, authStorageService: AuthStorageService = DIContainer.shared.authStorageService) {
        self.newsService = newsService
        self.authStorageService = authStorageService

        // Safe to use self synchronously after stored properties are initialized
        checkIfUserCanEdit()

        // Start async loading without strongly capturing self during initialization
        Task { [weak self] in
            await self?.loadData()
        }
    }

    private func checkIfUserCanEdit() {
        do {
            let userData = try authStorageService.getUserData()
            self.allowEdit = userData?.role == .przedstawiciel
            self.currentUserId = userData?.id ?? ""
        } catch {
            self.allowEdit = false
            self.currentUserId = ""
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

            await MainActor.run {
                news = data.news.sorted { $0.publish_date > $1.publish_date }
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
        do {
            try await newsService.deleteNews(id: id)
        } catch let error {
            SentryHelper.capture(error: error, action: "NewsListViewModel.deleteNews")
        }
    }  
} 