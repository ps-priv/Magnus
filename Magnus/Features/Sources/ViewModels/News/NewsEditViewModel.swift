import Foundation
import Combine
import MagnusDomain
import CryptoKit

@MainActor
public class NewsEditViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var message: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false

    @Published public var id: String = ""
    @Published public var title: String = ""
    @Published public var content: String = ""
    @Published public var image: Data?
    @Published public var selectedGroups: [NewsGroup] = []
    @Published public var attachments: [NewsAttachment] = []
    @Published public var tags: [String] = []
    @Published public var groups: [NewsGroup] = []
    @Published public var allowComments: Bool = false

    private let newsService: ApiNewsService
    private let storageService: MagnusStorageService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService, 
                storageService: MagnusStorageService = DIContainer.shared.storageService,
                id: String) {
        self.newsService = newsService
        self.storageService = storageService
        self.id = id

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
            let newsData: NewsDetails = try await newsService.getNewsById(id: id)
            let imageData = ImageReaderHelper.readImage(from: newsData.image)

            await MainActor.run {
                groups = data.groups
                id = newsData.id
                title = newsData.title
                content = newsData.description
                image = imageData
                selectedGroups = newsData.groups
                attachments = NewsMaterialToNewsAttachmentConverter.convert(newsMaterials: newsData.attachments)
                tags = newsData.tags
                allowComments = newsData.allow_comments
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            SentryHelper.capture(error: error, action: "NewsListViewModel.loadData")
        }
    }

    public func saveChanges() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            //checkAttachments(attachments: attachments)

            try await newsService.updateNews(id: id, title: title, content: content, image: image, selectedGroups: selectedGroups, attachments: attachments, tags: tags, allow_comments: allowComments)

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

            //checkAttachments(attachments: attachments)

            try storageService.saveNewsRequest(news: AddNewsRequest(title: title, message: content, image: imageString, tags: tags, user_groups: selectedGroups.map { $0.id }, attachments: attachments, allow_comments: allowComments))

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

    public func deleteNews() async {
        do {
            try await newsService.deleteNews(id: id)
        } catch let error {
            print(error)
            SentryHelper.capture(error: error, action: "NewsEditViewModel.deleteNews")
        }
    }  

    public var canSendNews: Bool {  
        return !title.isEmpty && !content.isEmpty && image != nil && !(image?.isEmpty == true)
    }

    private func checkAttachments( attachments: [NewsAttachment]) {
        print("attachments count: \(attachments.count)")

        for attachment in attachments {
            print("title: \(attachment.title)")
            print("type: \(attachment.type)")
            
            // Obliczanie SHA256 hash z contentu
            if !attachment.content.isEmpty {
                let contentData = Data(attachment.content.utf8)
                let hash = SHA256.hash(data: contentData)
                let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
                print("content SHA256: \(hashString)")
            }
            
            print("url: \(attachment.url)")
            print("----------------\n")
        }
    }
}