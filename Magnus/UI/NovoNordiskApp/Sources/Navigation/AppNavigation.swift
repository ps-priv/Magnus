import MagnusDomain
import SwiftUI

// MARK: - App Screen Enumeration with Parameters

enum AppScreen: Equatable, Identifiable {
    case dashboard
    case eventsList
    case eventDetail(eventId: String)
    case eventQrCode(eventId: String)
    case materialsList
    case materialDetail(materialId: String)
    case newsList
    case newsDetail(newsId: String)
    case profile
    case settings
    case academy
    case academyCategory(categoryId: String)
    case messagesList
    case messageDetail(messageId: String)

    var id: String {
        switch self {
        case .dashboard:
            return "dashboard"
        case .eventsList:
            return "events_list"
        case let .eventDetail(eventId):
            return "event_detail_\(eventId)"
        case let .eventQrCode(eventId):
            return "event_qr_code_\(eventId)"
        case .materialsList:
            return "materials_list"
        case let .materialDetail(materialId):
            return "material_detail_\(materialId)"
        case .newsList:
            return "news_list"
        case let .newsDetail(newsId):
            return "news_detail_\(newsId)"
        case .profile:
            return "profile"
        case .settings:
            return "settings"
        case .academy:
            return "academy"
        case let .academyCategory(categoryId):
            return "academy_category_\(categoryId)"
        case .messagesList:
            return "messages_list"
        case let .messageDetail(messageId):
            return "message_detail_\(messageId)"
        }
    }

    var title: String {
        switch self {
        case .dashboard:
            return LocalizedStrings.dashboardScreenTitle
        case .eventsList:
            return LocalizedStrings.eventsListScreenTitle
        case .eventDetail:
            return LocalizedStrings.eventDetailsScreenTitle
        case .eventQrCode:
            return ""
        case .materialsList:
            return LocalizedStrings.materialsListScreenTitle
        case .materialDetail:
            return LocalizedStrings.materialDetailsScreenTitle
        case .newsList:
            return LocalizedStrings.newsListScreenTitle
        case .newsDetail:
            return LocalizedStrings.newsDetailsScreenTitle
        case .profile:
            return LocalizedStrings.userProfileScreenTitle
        case .settings:
            return LocalizedStrings.settingsScreenTitle
        case .academy:
            return LocalizedStrings.academyScreenTitle
        case .academyCategory:
            return LocalizedStrings.academyScreenTitle
        case .messagesList:
            return LocalizedStrings.messagesListScreenTitle
        case .messageDetail:
            return LocalizedStrings.messageDetailsScreenTitle
        }
    }

    var bottomMenuTab: BottomMenuTab? {
        switch self {
        case .dashboard:
            return .start
        case .eventsList, .eventDetail:
            return .events
        case .materialsList, .materialDetail:
            return .materials
        case .newsList, .newsDetail:
            return .news
        case .academy:
            return .academy
        case .profile, .settings, .messagesList, .messageDetail, .eventQrCode, .academyCategory:
            return nil
        }
    }

    // Helper to check if this is a detail screen
    var isDetailScreen: Bool {
        switch self {
        case .eventDetail, .materialDetail, .newsDetail, .messageDetail:
            return true
        default:
            return false
        }
    }

    // Helper to check if bottom menu should be shown
    var shouldShowBottomMenu: Bool {
        switch self {
        case .profile, .settings:
            return false
        case .eventDetail, .eventQrCode, .materialDetail, .newsDetail:
            return false // Ukryj również na ekranach szczegółów
        default:
            return true
        }
    }

    var shouldShowTopBar: Bool {
        switch self {
        case .eventQrCode:
            return false
        default:
            return true
        }
    }

    // Helper to check if top bar search button should be shown
    var shouldShowSearchButton: Bool {
        switch self {
        case .eventsList, .materialsList, .newsList:
            return true
        default:
            return false
        }
    }

    // Helper to check if top bar notification buttons should be shown
    var shouldShowNotificationButtons: Bool {
        switch self {
        case .dashboard, .eventsList, .materialsList, .newsList, .messagesList:
            return true
        default:
            return false
        }
    }

    // Helper to check if profile button should be shown
    var shouldShowProfileButton: Bool {
        switch self {
        case .profile:
            return false // Don't show profile button on profile screen
        default:
            return true
        }
    }

    // Helper to check if settings button should be shown
    var shouldShowSettingsButton: Bool {
        switch self {
        case .profile:
            return true // Show settings button on profile screen
        case .settings:
            return false // Don't show settings button on settings screen
        default:
            return false
        }
    }

    // Helper to check if back button should be shown
    var shouldShowBackButton: Bool {
        switch self {
        case .messagesList:
            return false // Don't show back button on messages list
        default:
            return true
        }
    }
}

// MARK: - Navigation Manager with Parameter Support

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

    // Back navigation
    func goBack() {
        if !navigationStack.isEmpty {
            currentScreen = navigationStack.removeLast()

            // Update bottom tab
            if let tab = currentScreen.bottomMenuTab {
                selectedBottomTab = tab
            }
        }
    }

    // Navigate to root screen for a tab
    func navigateToTabRoot(_ tab: BottomMenuTab) {
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

// MARK: - Navigation Environment Key

struct NavigationManagerKey: EnvironmentKey {
    static let defaultValue = NavigationManager()
}

extension EnvironmentValues {
    var navigationManager: NavigationManager {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}
