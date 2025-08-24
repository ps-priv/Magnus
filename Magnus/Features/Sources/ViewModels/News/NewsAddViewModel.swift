import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsAddViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var message: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false

    @Published public var title: String = ""
    @Published public var content: String = ""
    @Published public var image: Data?
    @Published public var selectedGroups: [NewsGroup] = []
    @Published public var attachments: [NewsAttachment] = []
    @Published public var tags: [String] = []
    @Published public var groups: [NewsGroup] = []

    private let newsService: ApiNewsService
    private let storageService: MagnusStorageService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, 
                storageService: MagnusStorageService = DIContainer.shared.storageService) {
        self.newsService = newsService
        self.storageService = storageService

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
            print("title: \(title)")
            print("content: \(content)")
            // print("image: \(image)")
            print("selectedGroups: \(selectedGroups)")
            print("attachments: \(attachments)")
            print("tags: \(tags)")


            try await newsService.addNews(title: title, content: content, image: image, selectedGroups: selectedGroups, attachments: attachments, tags: tags)

            await MainActor.run {
                isLoading = false
                showToast = true
                message = FeaturesLocalizedStrings.newsAddSuccessMessage
            }
        } catch let error {
            print(error)
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            showToast = true
            message = FeaturesLocalizedStrings.newsAddErrorMessage

            SentryHelper.capture(error: error, action: "NewsAddViewModel.sendNews")
        }
    }

    public func saveNewsRequest() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let imageString = image?.base64EncodedString() ?? ""

            try await storageService.saveNewsRequest(news: AddNewsRequest(title: title, message: content, image: imageString, tags: tags, user_groups: selectedGroups.map { $0.id }, attachments: attachments))

            await MainActor.run {
                isLoading = false
                showToast = true
                message = FeaturesLocalizedStrings.newsAddSaveToStorage
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsAddViewModel.saveNewsRequest")
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
