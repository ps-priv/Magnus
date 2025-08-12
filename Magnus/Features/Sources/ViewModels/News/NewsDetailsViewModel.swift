import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsDetailsViewModel: ObservableObject {

    let id: String
    @Published public var news: NewsDetails?

    @Published public var isLoading: Bool = false
    @Published public var isCommentsEnabled: Bool = true
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var showPopup: Bool = false
    @Published public var popupMessage: String = ""

    private let newsService: ApiNewsService
    private let authStorageService: AuthStorageService

    public init(id: String, 
        newsService: ApiNewsService = DIContainer.shared.newsService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService) {

        self.id = id
        self.newsService = newsService
        self.authStorageService = authStorageService

        Task {
            await loadData(id: id)
        }
    }

    public func loadData(id: String) async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: NewsDetails = try await newsService.getNewsById(id: id)

            try await newsService.markNewsAsRead(id: id)

            checkIfUserCanComment()

            await MainActor.run {
                news = data
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.loadData")
        }
    }

    public func sendNewsReaction(reaction: ReactionEnum) async {
        do {
            try await newsService.sendNewsReaction(id: id, reaction: reaction)

            await loadData(id: id)

            showPopup = true
            popupMessage = FeaturesLocalizedStrings.newsReactionSentSuccessfully
        } catch let error {
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.sendNewsReaction")
        }
    }

    public func checkIfUserCanComment() {

        do {
            let userData = try authStorageService.getUserData()

            if let newsComments = news?.comments {
                isCommentsEnabled = !newsComments.contains(where: { $0.author.id == userData?.id })
            }
        } catch {
            isCommentsEnabled = false
        }
    }

    public func addCommentToNews(comment: String) async {
        do {
            try await newsService.addCommentToNews(id: id, comment: comment)

            await loadData(id: id)

            showPopup = true
            popupMessage = FeaturesLocalizedStrings.newsCommentSentSuccessfully
        } catch let error {
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.addCommentToNews")
        }
    }
}