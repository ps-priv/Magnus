import MagnusDomain
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var currentScreen: AppScreen = .dashboard
    @Published var navigationStack: [AppScreen] = []
    @Published var selectedBottomTab: BottomMenuTab = .start

    // Navigation method with parameters
    func navigate(to screen: AppScreen) {
        if screen != currentScreen {
            navigationStack.append(currentScreen)
            currentScreen = screen

            // Update bottom tab if needed
            if let tab = screen.bottomMenuTab {
                selectedBottomTab = tab
            }
        }
    }

    // Convenience methods for specific navigation with parameters
    func navigateToEventDetail(eventId: String) {
        navigate(to: .eventDetail(eventId: eventId))
    }

    func navigateToEventMaterials(eventId: String) {
        navigate(to: .eventMaterials(eventId: eventId))
    }

    func navigateToEventQrCode(event: ConferenceEvent) {
        navigate(to: .eventQrCode(eventId: event.id))
    }

    func navigateToMaterialDetail(materialId: String) {
        navigate(to: .materialDetail(materialId: materialId))
    }

    func navigateToNewsDetail(newsId: String) {
        navigate(to: .newsDetail(newsId: newsId))
    }

    func navigateToMessageDetail(messageId: String) {
        navigate(to: .messageDetail(messageId: messageId))
    }

    func navigateToAcademyCategory(categoryId: String) {
        navigate(to: .academyCategory(categoryId: categoryId))
    }

    func navigateToEventPhoto(photoId: String, photoUrl: String) {
        navigate(to: .eventPhoto(photoId: photoId, photoUrl: photoUrl))
    }

    func navigateToEventGallery(eventId: String) {
        navigate(to: .eventGallery(eventId: eventId))
    }

    func navigateToEventAddPhoto(eventId: String) {
        navigate(to: .eventAddPhoto(eventId: eventId))
    }

    // Back navigation
    func goBack() {

        if case let .eventDetail(eventId) = currentScreen, !eventId.isEmpty {
            navigate(to: .eventsList)
        } else
        if case let .eventAgenda(eventId) = currentScreen, !eventId.isEmpty {
            navigate(to: .eventDetail(eventId: eventId))
        } else
        if case let .eventLocation(eventId) = currentScreen, !eventId.isEmpty {
            navigate(to: .eventDetail(eventId: eventId))
        } else
        if case let .eventDinner(eventId) = currentScreen, !eventId.isEmpty {
            navigate(to: .eventDetail(eventId: eventId))
        } else
        if case let .eventSurvey(eventId) = currentScreen, !eventId.isEmpty {
            navigate(to: .eventDetail(eventId: eventId))
        } else {
            if !navigationStack.isEmpty {
                currentScreen = navigationStack.removeLast()

                // Update bottom tab
                if let tab = currentScreen.bottomMenuTab {
                    selectedBottomTab = tab
                }
            }
        } 
    }

    // Navigate to root screen for a tab
    func navigateToTabRoot(_ tab: BottomMenuTab, eventId: String? = nil) {
        let screen: AppScreen
        switch tab {
            case .start:
                screen = .dashboard
            case .news:
                screen = .newsList
            case .events:
                screen = .eventsList
            case .materials:
                screen = .materialsList
            case .academy:
                screen = .academy
            case .eventDetails:
                screen = .eventDetail(eventId: eventId ?? "")
            case .eventsAgenda:
                screen = .eventAgenda(eventId: eventId ?? "")
            case .eventsLocation:
                screen = .eventLocation(eventId: eventId ?? "")
            case .eventsDinner:
                screen = .eventDinner(eventId: eventId ?? "")
            case .eventsSurvey:
                screen = .eventSurvey(eventId: eventId ?? "")
            case .newsCreate:
                screen = .newsCreate
            case .newsGroups:
                screen = .newsGroups
            case .newsBookmarks:
                screen = .newsBookmarks
        }

        // Clear navigation stack and go to tab root
        navigationStack.removeAll()
        currentScreen = screen
        selectedBottomTab = tab
    }

    // Check if can go back
    var canGoBack: Bool {
        !navigationStack.isEmpty
    }
}

struct NavigationManagerKey: EnvironmentKey {
    static let defaultValue = NavigationManager()
}

extension EnvironmentValues {
    var navigationManager: NavigationManager {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}