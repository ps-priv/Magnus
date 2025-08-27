
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

    public func getEventDetails(id: String) async throws -> ConferenceEventDetails {
        let token = try authStorageService.getAccessToken() ?? ""
        let eventDetails = try await withCheckedThrowingContinuation { continuation in
            eventsNetworkService.getEventDetails(token: token, id: id)
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
        return eventDetails
    }

    public func uploadEventPhoto(eventId: String, image: Data) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""

        // Convert to base64 with resize/compression similar to News
        guard let imageString = ImageToBase64Converter.convert(imageData: image) else {
            throw NSError(domain: "ApiEventsService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]) 
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            eventsNetworkService.uploadEventPhoto(token: token, eventId: eventId, imageBase64: imageString)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.resume(returning: ())
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { _ in
                        // Void response
                    }
                )
                .store(in: &cancellables)
        }
    }
}