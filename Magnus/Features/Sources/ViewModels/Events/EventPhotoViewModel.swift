import Combine
import Foundation
import MagnusDomain

@MainActor
public class EventPhotoViewModel: ObservableObject {
    @Published public var photoId: String

    private let eventsService: ApiEventsService
    private let authStorageService: AuthStorageService

    @Published public var allowEdit: Bool = false

    public init(
        photoId: String,
        eventsService: ApiEventsService = DIContainer.shared.eventsService,
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.photoId = photoId
        self.eventsService = eventsService
        self.authStorageService = authStorageService

        checkIfUserCanEdit()
    }

    public func checkIfUserCanEdit() {
        do {
            let userData = try authStorageService.getUserData()
            //allowEdit = userData?.role == .przedstawiciel
            allowEdit = userData?.photo_booths_editor == 1
        } catch {
            allowEdit = false
        }
    }

    public func deletePhoto() async {
        do {
            try await eventsService.deleteEventPhoto(photoId: photoId)

        } catch let error {
            print("Error deleting photo: \(error)")
        }
    }
}
