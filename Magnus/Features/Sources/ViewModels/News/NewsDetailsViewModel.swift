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

    @Published public var allowEdit: Bool = false
    @Published public var currentUserId: String = ""

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

        checkIfUserCanEdit()
    }

    public func checkIfUserCanEdit() {
        do {
            let userData = try authStorageService.getUserData()
            allowEdit = userData?.role == .przedstawiciel
            currentUserId = userData?.id ?? ""
        } catch {
            allowEdit = false
            currentUserId = ""
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

            //checkIfUserCanComment()

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
            //updateUserReactions(userReaction: reaction)
            await loadData(id: id)

            showPopup = true
            popupMessage = FeaturesLocalizedStrings.newsReactionSentSuccessfully
        } catch let error {
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.sendNewsReaction")
        }
    }

    private func updateUserReactions(userReaction: ReactionEnum) {
        if let reactions = news?.reactions {
            let updatedReactions = reactions.map { reaction in
                if reaction.author.id == currentUserId {
                    return reaction.copy(reaction: userReaction)
                } else {
                    return reaction
                }  
            }
            news?.reactions = updatedReactions
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

    public func deleteNews() async {
        do {
            try await newsService.deleteNews(id: id)
        } catch let error {
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.deleteNews")
        }
    }  


    public func changeNewsBookmarkStatus() async {
        do {
            try await newsService.changeNewsBookmarkStatus(id: id)
        } catch let error {
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.changeNewsBookmarkStatus")
        }
    }
}