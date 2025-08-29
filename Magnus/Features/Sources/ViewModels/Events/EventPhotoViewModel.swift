import Combine
import Foundation
import MagnusDomain

@MainActor
public class EventPhotoViewModel: ObservableObject {
    @Published public var photoId: String

    private let eventsService: ApiEventsService

    public init(
        photoId: String,
        eventsService: ApiEventsService = DIContainer.shared.eventsService,
    ) {
        self.photoId = photoId
        self.eventsService = eventsService
    }

    public func deletePhoto() async {
        do {
            try await eventsService.deleteEventPhoto(photoId: photoId)

        } catch let error {
            print("Error deleting photo: \(error)")
        }
    }
}
