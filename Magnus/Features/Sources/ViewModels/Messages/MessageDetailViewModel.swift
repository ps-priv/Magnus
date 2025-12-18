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
    private var loadTask: Task<Void, Never>?

    public init(messageId: String, 
        messagesService: ApiMessagesService = DIContainer.shared.messagesService) {
        self.messageId = messageId
        self.messagesService = messagesService

        loadTask = Task { [weak self] in
            await self?.loadData()
        }
    }
    
    deinit {
        loadTask?.cancel()
    }

    public func loadData() async {
        await MainActor.run {
            self.isLoading = true
            self.hasError = false
            self.errorMessage = ""
        }

        do {
            let data: ConferenceMessageDetails = try await messagesService.getMessageDetails(id: messageId)
            
            // Check if task was cancelled
            try Task.checkCancellation()
            
            await MainActor.run {
                message = data
                isLoading = false
            }
        } catch is CancellationError {
            print("[MessageDetailViewModel] Load task was cancelled")
            return
        } catch let error {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                hasError = true
            }
        }
    }
}
