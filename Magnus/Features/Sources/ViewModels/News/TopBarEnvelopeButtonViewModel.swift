
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
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.getUnreadMessagesCount()
            }
        }
    }

    public func getUnreadMessagesCount() async {
        do {
            // Check if user is authenticated first
            guard try authStorageService.isAuthenticated() else {
                await MainActor.run {
                    unreadMessagesCount = 0
                    print("[TopBarEnvelopeButtonViewModel] User not authenticated, setting unreadMessagesCount to 0")
                }
                return
            }
            
            // Check if token is expired
            guard !authStorageService.isTokenExpired() else {
                await MainActor.run {
                    unreadMessagesCount = 0
                    print("[TopBarEnvelopeButtonViewModel] Token expired, setting unreadMessagesCount to 0")
                }
                return
            }

            let data: GetUnreadMessagesResponse = try await messagesService.getUnreadMessagesCount()

            await MainActor.run {
                unreadMessagesCount = data.unreadMessages
                print("[TopBarEnvelopeButtonViewModel] unreadMessagesCount: \(unreadMessagesCount)")
            }

        } catch let error as AuthStorageError {
            // Handle keychain and other auth storage errors gracefully
            await MainActor.run {
                unreadMessagesCount = 0
                print("[TopBarEnvelopeButtonViewModel] Auth storage error: \(error.localizedDescription), setting unreadMessagesCount to 0")
            }
            // Only capture to Sentry if it's not a simple key not found or expired token scenario
            if case .keychainError(_) = error, error.localizedDescription != "Keychain error: -25300" {
                SentryHelper.capture(error: error, action: "TopBarEnvelopeButtonViewModel.getUnreadMessagesCount")
            }
        } catch {
            SentryHelper.capture(error: error, action: "TopBarEnvelopeButtonViewModel.getUnreadMessagesCount")
        }
    }
}