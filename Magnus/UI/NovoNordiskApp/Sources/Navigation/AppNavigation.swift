import MagnusDomain
import SwiftUI

// MARK: - App Screen Enumeration with Parameters

enum AppScreen: Equatable, Identifiable {
    case dashboard
    case eventsList
    case eventDetail(eventId: String)
    case eventQrCode(eventId: String)
    case eventMaterials(eventId: String)
    case materialsList
    case materialDetail(materialId: String)
    case newsList
    case newsDetail(newsId: String)
    case newsCreate
    case newsBookmarks
    case newsDrafts
    case newsEdit(newsId: String)
    case newsEditDraft(newsId: String)
    case newsGroups
    case profile
    case settings
    case academy
    case academyCategory(categoryId: String)
    case messagesList
    case messageDetail(messageId: String)
    case eventAgenda(eventId: String)
    case eventLocation(eventId: String)
    case eventDinner(eventId: String)
    case eventSurvey(eventId: String)

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
        case let .eventMaterials(eventId):
            return "event_materials_\(eventId)"
        case .materialsList:
            return "materials_list"
        case let .materialDetail(materialId):
            return "material_detail_\(materialId)"
        case .newsList:
            return "news_list"
        case let .newsDetail(newsId):
            return "news_detail_\(newsId)"
        case .newsCreate:
            return "news_create"
        case .newsBookmarks:
            return "news_bookmarks"
        case .newsDrafts:
            return "news_drafts"
        case let .newsEdit(newsId):
            return "news_edit_\(newsId)"
        case let .newsEditDraft(newsId):
            return "news_edit_draft_\(newsId)"
        case .newsGroups:
            return "news_groups"
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
        case let .eventAgenda(eventId):
            return "event_agenda_\(eventId)"
        case let .eventLocation(eventId):
            return "event_location_\(eventId)"
        case let .eventDinner(eventId):
            return "event_dinner_\(eventId)"
        case let .eventSurvey(eventId):
            return "event_survey_\(eventId)"
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
        case .eventMaterials:
            return LocalizedStrings.eventMaterialsScreenTitle
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
        case .newsCreate:
            return LocalizedStrings.newsCreateScreenTitle
        case .newsBookmarks:
            return LocalizedStrings.newsBookmarksScreenTitle
        case .newsDrafts:
            return LocalizedStrings.newsDraftsScreenTitle
        case .newsEdit:
            return LocalizedStrings.newsEditScreenTitle
        case .newsEditDraft:
            return LocalizedStrings.newsEditDraftScreenTitle
        case .newsGroups:
            return LocalizedStrings.newsGroupsScreenTitle
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
        case .eventAgenda:
            return LocalizedStrings.eventAgendaScreenTitle
        case .eventLocation:
            return LocalizedStrings.eventLocationScreenTitle
        case .eventDinner:
            return LocalizedStrings.eventDinnerScreenTitle
        case .eventSurvey:
            return LocalizedStrings.eventSurveyScreenTitle
        }
    }

    var bottomMenuTab: BottomMenuTab? {
        switch self {
        case .dashboard:
            return .start
        case .eventsList:
            return .events
        case .eventDetail:
            return .eventDetails
        case .eventMaterials:
            return .eventDetails
        case .materialsList, .materialDetail:
            return .materials
        case .newsList, .newsDetail:
            return .news
        case .newsCreate:
            return .newsCreate
        case .newsBookmarks:
            return .newsBookmarks
        case .newsGroups:
            return .newsGroups
        case .academy:
            return .academy
        case .profile, .settings, .messagesList, .messageDetail, .eventQrCode, .academyCategory, .newsEdit, .newsEditDraft, .newsDrafts:
            return nil

        case .eventAgenda:
            return .eventsAgenda
        case .eventLocation:
            return .eventsLocation
        case .eventDinner:
            return .eventsDinner
        case .eventSurvey:
            return .eventsSurvey
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
        case .eventQrCode, .materialDetail, .newsDetail:
            return false // Ukryj również na ekranach szczegółów
        case .eventDetail:
            return true // Show bottom menu on event details to access agenda/location/dinner/survey
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
        case .eventsList, .materialsList, .newsList, .messagesList:
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

