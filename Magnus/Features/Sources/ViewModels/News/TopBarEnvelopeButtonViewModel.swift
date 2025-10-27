
import Foundation
import Combine
import MagnusDomain

@MainActor
public class TopBarEnvelopeButtonViewModel: ObservableObject {
    @Published public var unreadMessagesCount: Int = 0

    private let messagesService: ApiMessagesService
    private let authStorageService: AuthStorageService
    private var timer: Timer?
    
    public init(messagesService: ApiMessagesService = DIContainer.shared.messagesService, authStorageService: AuthStorageService = DIContainer.shared.authStorageService) {
        self.messagesService = messagesService
        self.authStorageService = authStorageService
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.getUnreadMessagesCount()
            }
        }
    }

    public func getUnreadMessagesCount() async {

        do {
            let data: GetUnreadMessagesResponse = try await messagesService.getUnreadMessagesCount()

            await MainActor.run {
                unreadMessagesCount = data.unreadMessages
                print("[TopBarEnvelopeButtonViewModel] unreadMessagesCount: \(unreadMessagesCount)")
            }

        } catch let error {
            SentryHelper.capture(error: error, action: "TopBarEnvelopeButtonViewModel.getUnreadMessagesCount")
        }
    }
}