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

    private let newsService: ApiNewsService

    public init(id: String, newsService: ApiNewsService = DIContainer.shared.newsService) {
        self.id = id
        self.newsService = newsService

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
        } catch let error {
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsDetailsViewModel.sendNewsReaction")
        }
    }

    public func checkIfUserCanComment() {
        //isCommentsEnabled = news?.isCommentEnabled ?? true
    }
}