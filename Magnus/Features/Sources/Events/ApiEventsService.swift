
import Foundation
import Combine
import MagnusDomain

public class ApiEventsService: EventsServiceProtocol {
    private let eventsNetworkService: EventsNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(eventsNetworkService: EventsNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.eventsNetworkService = eventsNetworkService
        self.authStorageService = authStorageService
    }

    public func getEvents() async throws -> GetEventsListResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let events = try await withCheckedThrowingContinuation { continuation in
            eventsNetworkService.getEvents(token: token)
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
        return events
    }
}