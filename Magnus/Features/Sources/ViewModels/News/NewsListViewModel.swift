import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsListViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var news: [News] = []
    @Published public var allNews: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var allowEdit: Bool = false
    @Published public var currentUserId: String = ""

    @Published public var userPermissions: UserPermissions

    private let newsService: ApiNewsService
    private let authStorageService: AuthStorageService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, authStorageService: AuthStorageService = DIContainer.shared.authStorageService) {
        self.newsService = newsService
        self.authStorageService = authStorageService

        self.userPermissions = try! authStorageService.getUserData()?.getUserPermissions() ?? UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)
        self.currentUserId = userPermissions.id
        self.allowEdit = false
        
        Task { [weak self] in
            await self?.loadData()
        }
    }

    // func checkIfUserCanEdit() {
    //     do {
    //         let userData = try authStorageService.getUserData()
    //         self.allowEdit = userData?.role == .przedstawiciel
    //         self.currentUserId = userData?.id ?? ""
    //         self.userPermissions = userData?.getUserPermissions() ?? UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)
    //     } catch {
    //         self.allowEdit = false
    //         self.currentUserId = ""
    //         self.userPermissions = UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)
    //     }
    // }

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
                allNews = news
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

    public func searchNews() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        if searchText.isEmpty {
            news = allNews
        } else {
            news = allNews.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }

        await MainActor.run {
            isLoading = false
        }
    }
} 