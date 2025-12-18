import Foundation
import Combine
import MagnusDomain

@MainActor
public class MessagesListViewModel: ObservableObject {
    @Published public var messages: [ConferenceMessage] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false
    @Published public var showToast: Bool = false
    
    private var messagesService: ApiMessagesService?
    private var loadTask: Task<Void, Never>?

    public init(messagesService: ApiMessagesService? = nil) {
        self.messagesService = messagesService
    }
    
    private func getMessagesService() -> ApiMessagesService? {
        if messagesService == nil {
            messagesService = DIContainer.shared.resolve(ApiMessagesService.self)
        }
        return messagesService
    }
    
    deinit {
        loadTask?.cancel()
    }

    // MARK: - Public Methods
    
    /// Load messages data
    public func loadData() {
        loadTask?.cancel()
        
        loadTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.isLoading = true
                self.hasError = false
                self.errorMessage = ""
            }
            
            do {
                guard let service = self.getMessagesService() else {
                    print("[MessagesListViewModel] MessagesService not available")
                    await MainActor.run {
                        self.isLoading = false
                        self.errorMessage = "Service not available"
                        self.hasError = true
                    }
                    return
                }
                
                let data: GetMessagesListResponse = try await service.getMessagesList()
                print("[MessagesListViewModel] Messages loaded: \(data.messages.count)")
                
                // Check if task was cancelled
                try Task.checkCancellation()
                
                await MainActor.run {
                    self.messages = data.messages
                    self.isLoading = false
                }
            } catch is CancellationError {
                print("[MessagesListViewModel] Load task was cancelled")
                return
            } catch {
                print("[MessagesListViewModel] Error loading messages: \(error)")
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.hasError = true
                    self.showToast = true
                }
            }
        }
    }
}