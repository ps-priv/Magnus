import Foundation
import Combine
import MagnusDomain

public class ApiMessagesService: MessagesServiceProtocol {
    private let messagesNetworkService: MessagesNetworkServiceProtocol
    private let authStorageService: AuthStorageService

    public init(messagesNetworkService: MessagesNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.messagesNetworkService = messagesNetworkService
        self.authStorageService = authStorageService
    }

    public func getMessagesList() async throws -> GetMessagesListResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        var cancellable: AnyCancellable?
        let messagesList = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<GetMessagesListResponse, Error>) in
            cancellable = messagesNetworkService.getMessagesList(token: token)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                        cancellable = nil
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                        cancellable = nil
                    }
                )
        }

        return messagesList
    }

    public func getMessageDetails(id: String) async throws -> ConferenceMessageDetails {        
        let token = try authStorageService.getAccessToken() ?? ""
        var cancellable: AnyCancellable?
        let messageDetails = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ConferenceMessageDetails, Error>) in
            cancellable = messagesNetworkService.getMessageDetails(token: token, id: id)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                        cancellable = nil
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                        cancellable = nil
                    }
                )
        }

        return messageDetails
    }   

    public func getUnreadMessagesCount() async throws -> GetUnreadMessagesResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        var cancellable: AnyCancellable?
        let unreadMessagesCount = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<GetUnreadMessagesResponse, Error>) in
            cancellable = messagesNetworkService.getUnreadMessagesCount(token: token)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                        cancellable = nil
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                        cancellable = nil
                    }
                )
        }

        return unreadMessagesCount
    }

}
