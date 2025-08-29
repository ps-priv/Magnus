import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol EventsNetworkServiceProtocol {
    func getEvents(token: String) -> AnyPublisher<GetEventsListResponse, Error>
    func getEventDetails(token: String, id: String) -> AnyPublisher<ConferenceEventDetails, Error>
    func uploadEventPhoto(token: String, eventId: String, imageBase64: String) -> AnyPublisher<Void, Error>
    func getEventGallery(token: String, id: String) -> AnyPublisher<GetEventGalleryResponse, Error>
    func deleteEventPhoto(token: String, photoId: String) -> AnyPublisher<Void, Error>
}

public class EventsNetworkService: EventsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getEvents(token: String) -> AnyPublisher<GetEventsListResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events",
            method: .get,
            responseType: GetEventsListResponse.self,
            bearerToken: token
        )
    }

    public func getEventDetails(token: String, id: String) -> AnyPublisher<ConferenceEventDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events/\(id)",
            method: .get,
            responseType: ConferenceEventDetails.self,
            bearerToken: token
        )
    }

    private struct UploadPhotoRequest: Encodable {
        let image: String
    }

    public func uploadEventPhoto(token: String, eventId: String, imageBase64: String) -> AnyPublisher<Void, Error> {
        // TODO: Confirm the exact endpoint with backend. Using a tentative path for now.
        let endpoint = "/api/events/\(eventId)/photo_booth"
        let body = UploadPhotoRequest(image: imageBase64)
        return networkService.requestWithBearerToken(
            endpoint: endpoint,
            method: .post,
            headers: nil,
            body: body,
            bearerToken: token
        )
    }

    public func getEventGallery(token: String, id: String) -> AnyPublisher<GetEventGalleryResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events/\(id)/photo_booth",
            method: .get,
            responseType: GetEventGalleryResponse.self,
            bearerToken: token
        )
    }

    public func deleteEventPhoto(token: String, photoId: String) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/events/photo_booth/\(photoId)",
            method: .delete,
            bearerToken: token
        )
    }
}
