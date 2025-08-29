import Foundation
import Combine
import MagnusDomain

@MainActor
public class EventGalleryViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var gallery: [ConferenceEventPhotoBooth]?

    private let eventsService: ApiEventsService
    private let storageService: MagnusStorageService

    public init(eventId: String, 
        eventsService: ApiEventsService = DIContainer.shared.eventsService,
        storageService: MagnusStorageService = DIContainer.shared.storageService) {
        self.eventId = eventId
        self.eventsService = eventsService
        self.storageService = storageService

        Task {
            await loadData()
        }
    }

    public func loadData() async {
        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await eventsService.getEventGallery(id: eventId)
            await MainActor.run {
                gallery = data.photo_booth
                isLoading = false
            }
        } catch let error {
            await MainActor.run {
                errorMessage = error.localizedDescription
                hasError = true
                isLoading = false
            }
        }
    }
}