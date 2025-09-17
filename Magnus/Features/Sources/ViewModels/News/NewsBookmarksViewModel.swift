import Foundation
import Combine
import MagnusDomain

@MainActor
public class BookmarksViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var news: [News] = []
    @Published public var allNews: [News] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var allowEdit: Bool = false
    @Published public var currentUserId: String = ""

    @Published public var userPermissions: UserPermissions = UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)

    private let newsService: ApiNewsService
    private let authStorageService: AuthStorageService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, authStorageService: AuthStorageService = DIContainer.shared.authStorageService) {
        self.newsService = newsService
        self.authStorageService = authStorageService

        Task {
            await loadData()
            checkIfUserCanEdit()
        }
    }

    private func checkIfUserCanEdit() {
        do {
            let userData = try authStorageService.getUserData()
            self.allowEdit = userData?.role == .przedstawiciel
            self.currentUserId = userData?.id ?? ""
            self.userPermissions = userData?.getUserPermissions() ?? UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)
        } catch {
            self.allowEdit = false
            self.currentUserId = ""
            self.userPermissions = UserPermissions(id: "", admin: 0, news_editor: 0, photo_booths_editor: 0)
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
            let data: GetNewsResponse = try await newsService.getBookmarks()

            await MainActor.run {
                news = data.news
                allNews = news
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "BookmarksViewModel.loadData")
        }
    }

    public func changeNewsBookmarkStatus(id: String) async {
        do {
            try await newsService.changeNewsBookmarkStatus(id: id)

            Task {
                await loadData()
            }
        } catch let error {
            SentryHelper.capture(error: error, action: "BookmarksViewModel.changeNewsBookmarkStatus")
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