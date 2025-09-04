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

    private let messagesService: ApiMessagesService

    public init(messagesService: ApiMessagesService = DIContainer.shared.messagesService) {
        self.messagesService = messagesService

        Task {
            await loadData()
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

        print("Loading messages...")

        do {
            let data: GetMessagesListResponse = try await messagesService.getMessagesList()

            print("Messages: \(data)")

            await MainActor.run {
                messages = data.messages
                isLoading = false
            }
        } catch let error {
            print("Error loading messages: \(error)")
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
            showToast = true
        }
    }
}