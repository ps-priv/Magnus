import MagnusDomain
import Foundation   
import Combine

@MainActor
public class EventAgendaItemViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var agenda: ConferenceEventAgendaContent?
    @Published public var location: ConferenceEventLocation?

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
            let agendaItem = try storageService.getAgendaItem()
            let locationItem: ConferenceEventLocation? = try storageService.getLocation()

            await MainActor.run {
                if let agendaItem  {
                    agenda = agendaItem
                    isLoading = false
                } else {
                    isLoading = false
                    hasError = true
                    errorMessage = "No cached agenda item found."
                }

                if let locationItem {
                    location = locationItem
                }else {
                    isLoading = false
                    hasError = true
                    errorMessage = "No cached location item found."
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
