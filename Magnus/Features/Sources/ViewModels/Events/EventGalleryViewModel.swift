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

    private let storageService: MagnusStorageService

    public init(eventId: String, 
        storageService: MagnusStorageService = DIContainer.shared.storageService) {

        self.eventId = eventId
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
            let data = try storageService.getEventDetails()
            await MainActor.run {
                if let data  {
                    gallery = data.photo_booth
                    isLoading = false
                } else {
                    isLoading = false
                    hasError = true
                    errorMessage = "No cached event details found."
                }
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