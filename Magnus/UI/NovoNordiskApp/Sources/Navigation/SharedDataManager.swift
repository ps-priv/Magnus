import SwiftUI
import MagnusDomain
import MagnusFeatures

// MARK: - Shared Data Manager
class SharedDataManager: ObservableObject {
    // Selected items for detail views
    @Published var selectedEvent: Event?
    @Published var selectedMaterial: Material?
    @Published var selectedNewsItem: NewsItem?
    @Published var selectedMessage: ConferenceMessage?
    
    // Methods to set selected items
    func selectEvent(_ event: Event) {
        selectedEvent = event
    }
    
    func selectMaterial(_ material: Material) {
        selectedMaterial = material
    }
    
    func selectNewsItem(_ newsItem: NewsItem) {
        selectedNewsItem = newsItem
    }

    func selectMessage(_ message: ConferenceMessage) {
        selectedMessage = message
    }

    // Clear methods
    func clearSelections() {
        selectedEvent = nil
        selectedMaterial = nil
        selectedNewsItem = nil
        selectedMessage = nil
    }
}

// MARK: - Environment Key
struct SharedDataManagerKey: EnvironmentKey {
    static let defaultValue = SharedDataManager()
}

extension EnvironmentValues {
    var sharedDataManager: SharedDataManager {
        get { self[SharedDataManagerKey.self] }
        set { self[SharedDataManagerKey.self] = newValue }
    }
}

// MARK: - Extended Navigation Manager with Shared Data
extension NavigationManager {
    
    // Navigate with object selection
    func navigateToEventDetail(event: Event, sharedDataManager: SharedDataManager) {
        sharedDataManager.selectEvent(event)
        navigate(to: .eventDetail(eventId: event.id))
    }
    
    func navigateToMaterialDetail(material: Material, sharedDataManager: SharedDataManager) {
        sharedDataManager.selectMaterial(material)
        navigate(to: .materialDetail(materialId: material.id))
    }
    
    func navigateToNewsDetail(newsItem: NewsItem, sharedDataManager: SharedDataManager) {
        sharedDataManager.selectNewsItem(newsItem)
        navigate(to: .newsDetail(newsId: newsItem.id))
    }

    func navigateToMessageDetail(message: ConferenceMessage, sharedDataManager: SharedDataManager) {
        sharedDataManager.selectMessage(message)
        navigate(to: .messageDetail(messageId: message.title))
    }
} 
