import MagnusDomain
import Foundation   
import Combine

@MainActor
public class MessageDetailViewModel: ObservableObject {
    @Published public var messageId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var message: ConferenceMessageDetails?

    private let messagesService: ApiMessagesService

    public init(messageId: String, 
        messagesService: ApiMessagesService = DIContainer.shared.messagesService) {
        self.messageId = messageId
        self.messagesService = messagesService

        Task {
            await loadData()
        }
    }

    public func loadData() async {
        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: ConferenceMessageDetails = try await messagesService.getMessageDetails(id: messageId)
            
            await MainActor.run {
                message = data
                isLoading = false
            }
        } catch let error {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                hasError = true
            }
        }
    }
}
