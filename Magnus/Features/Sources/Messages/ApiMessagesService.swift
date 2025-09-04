import Foundation
import Combine
import MagnusDomain

public class ApiMessagesService: MessagesServiceProtocol {
    private let messagesNetworkService: MessagesNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(messagesNetworkService: MessagesNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.messagesNetworkService = messagesNetworkService
        self.authStorageService = authStorageService
    }

    public func getMessagesList() async throws -> GetMessagesListResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let messagesList = try await withCheckedThrowingContinuation { continuation in
            messagesNetworkService.getMessagesList(token: token)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }

        return messagesList
    }

}