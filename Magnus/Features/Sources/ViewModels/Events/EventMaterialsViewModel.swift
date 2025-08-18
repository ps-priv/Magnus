import MagnusDomain
import Foundation   
import Combine

@MainActor
public class EventMaterialsViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var event: ConferenceEventDetails?

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
                    event = data
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