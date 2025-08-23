import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsAddViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var title: String = ""
    @Published public var content: String = ""
    @Published public var image: Data?
    @Published public var selectedGroups: [NewsGroup] = []
    @Published public var attachments: [NewsAttachment] = []
    @Published public var tags: [String] = []

    @Published public var groups: [NewsGroup] = []

    private let newsService: ApiNewsService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService) {
        self.newsService = newsService

        Task {
            await loadData()
        }
    }

    public func loadData() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetGroupsResponse = try await newsService.getGroups()

            await MainActor.run {
                groups = data.groups
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsListViewModel.loadData")
        }
    }

    public func sendNews() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            try await newsService.addNews(title: title, content: content, image: image, selectedGroups: selectedGroups, attachments: attachments, tags: tags)

            await MainActor.run {
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsAddViewModel.sendNews")
        }
    }

    public func canSendNews() -> Bool {

        if (title.isEmpty || content.isEmpty) {
            return false
        }

        if image == nil {
            return false
        }

        return true
    }
}
