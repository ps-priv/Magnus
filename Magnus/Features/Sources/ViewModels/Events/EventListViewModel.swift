import Foundation
import Combine
import MagnusDomain

@MainActor
public class EventListViewModel: ObservableObject {
    @Published public var events: [ConferenceEvent] = []

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    private let eventsService: ApiEventsService

    public init(eventsService: ApiEventsService = DIContainer.shared.eventsService) {
        self.eventsService = eventsService

        Task {
            await loadData()
        }
    }

    // MARK: - Setup
    /// Load dashboard data
    public func loadData() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetEventsListResponse = try await eventsService.getEvents()

            await MainActor.run {
                events = data.events
                isLoading = false
            }
        } catch let error {
            isLoading = false
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
}