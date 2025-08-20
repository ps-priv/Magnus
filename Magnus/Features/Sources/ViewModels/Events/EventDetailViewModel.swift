import MagnusDomain
import Foundation   
import Combine

@MainActor
public class EventDetailViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var event: ConferenceEventDetails?
    @Published public var isArchivedEventsViewVisible = false
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

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
            let data: ConferenceEventDetails = try await eventsService.getEventDetails(id: eventId)
            
            try storageService.saveEventDetails(data)

            await MainActor.run {
                event = data
                isLoading = false
            }
        } catch let error {
            print("Error loading event details: \(error)")
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                hasError = true
            }
        }
    }
}
