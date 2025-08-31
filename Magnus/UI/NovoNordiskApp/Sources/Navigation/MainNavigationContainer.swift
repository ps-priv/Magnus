import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MainNavigationContainer: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    private let allowedFunctions = AllowedFunctions()

    private let authStorageService: AuthStorageService

    @State private var allowEdit: Bool = false

    public init(
        authStorageService: AuthStorageService = DIContainer.shared.authStorageService
    ) {
        self.authStorageService = authStorageService
        checkIfUserCanEdit()
    }

    public func checkIfUserCanEdit() {
        do {
            let userData = try authStorageService.getUserData()
            let role = userData?.role
            allowEdit = (role == .przedstawiciel)
        } catch {
            allowEdit = false
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Bar
                if navigationManager.currentScreen.shouldShowTopBar {
                    RoundedTopBar(
                        title: navigationManager.currentScreen.title,
                        canGoBack: navigationManager.canGoBack && navigationManager.currentScreen.shouldShowBackButton,
                        showSearchButton: navigationManager.currentScreen.shouldShowSearchButton,
                        showNotificationButtons: navigationManager.currentScreen.shouldShowNotificationButtons,
                        showProfileButton: navigationManager.currentScreen.shouldShowProfileButton,
                        showSettingsButton: navigationManager.currentScreen.shouldShowSettingsButton,
                        isMessagesActive: navigationManager.currentScreen == .messagesList,
                        onBackTap: {
                            navigationManager.goBack()
                        },
                        onProfileTap: {
                            navigationManager.navigate(to: .profile)
                        },
                        onSettingsTap: {
                            navigationManager.navigate(to: .settings)
                        },
                        onMessagesTap: {
                            navigationManager.navigate(to: .messagesList)
                        }
                    )
                }

                // Main Content Area
                currentScreenView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // .frame(
                //     width: geometry.size.width,
                //     height: geometry.size.height - topBarHeight - (navigationManager.currentScreen.shouldShowBottomMenu ? bottomMenuHeight(geometry: geometry) : 0)
                // )

                // Bottom Menu - Show conditionally
                if navigationManager.currentScreen.shouldShowBottomMenu {
                    BottomMenu(
                        selectedTab: $navigationManager.selectedBottomTab,
                        visibleTabs: visibleBottomTabs,
                        onTabSelected: { tab in
                            if let eventId = currentEventId() {
                                switch tab {
                                case .eventDetails:
                                    navigationManager.navigate(to: .eventDetail(eventId: eventId))
                                case .eventsAgenda:
                                    navigationManager.navigate(to: .eventAgenda(eventId: eventId))
                                case .eventsLocation:
                                    navigationManager.navigate(to: .eventLocation(eventId: eventId))
                                case .eventsDinner:
                                    navigationManager.navigate(to: .eventDinner(eventId: eventId))
                                case .eventsSurvey:
                                    navigationManager.navigate(to: .eventSurvey(eventId: eventId))
                                default:
                                    navigationManager.navigateToTabRoot(tab)
                                }
                            } else {
                                navigationManager.navigateToTabRoot(tab)
                            }
                        }
                    )
                    .frame(height: bottomMenuHeight(geometry: geometry))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }    
        .onAppear {
            checkIfUserCanEdit()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .scrollDismissesKeyboard(.interactively) 
        .environmentObject(navigationManager)
        .environmentObject(userProfileViewModel)
        .animation(.easeInOut(duration: 0.3), value: navigationManager.currentScreen)
        .animation(.easeInOut(duration: 0.3), value: navigationManager.currentScreen.shouldShowBottomMenu)
    }

    @ViewBuilder
    private func currentScreenView() -> some View {
        switch navigationManager.currentScreen {
        case .dashboard:
            DashboardMainView()
        case .eventsList:
            EventsListView()
        case let .eventDetail(eventId):
            EventDetailView(eventId: eventId)
        case let .eventQrCode(eventId):
            EventQrCodeView(eventId: eventId)
        case .materialsList:
            MaterialsListView()
        case let .materialDetail(materialId):
            MaterialDetailView(materialId: materialId)
        case .newsList:
            NewsListView()
        case let .newsInGroup(groupId):
            NewsInGroupListView(groupId: groupId)
        case let .newsDetail(newsId):
            NewsDetailView(newsId: newsId)
        case .newsCreate:
            NewsAddView()
        case let .newsEdit(newsId):
            NewsEditView(newsId: newsId)
        case .newsEditDraft:
            NewsEditDraftView()
        case .newsBookmarks:
            NewsBookmarksView()
        case .newsDrafts:
            NewsDraftsListView()
        case .newsGroups:
            NewsGroupsView()
        case .profile:
            UserProfileView()
        case .settings:
            SettingsView()
        case .academy:
            AcademyView()
        case let .academyCategory(categoryId):
            AcademyCategoryView(categoryId: categoryId)
        case .messagesList:
            MessagesListView()
        case let .messageDetail(messageId):
            MessageDetailView(messageId: messageId)
        case let .eventAgenda(eventId):
            EventAgendaView(eventId: eventId)
        case let .eventLocation(eventId):
            EventLocationView(eventId: eventId)
        case let .eventDinner(eventId):
            EventDinnerView(eventId: eventId)
        case let .eventSurvey(eventId):
            EventSurveyView(eventId: eventId)
        case let .eventMaterials(eventId):
            EventMaterialsView(eventId: eventId)
        case let .eventPhoto(photoId, photoUrl):
            EventPhotoView(photoId: photoId, photoUrl: photoUrl)
        case let .eventGallery(eventId):
            EventGalleryView(eventId: eventId)
        case let .eventAddPhoto(eventId):
            EventAddPhotoView(eventId: eventId)
        }
    }

    private var topBarHeight: CGFloat { 54 + 44 }

    private func bottomMenuHeight(geometry: GeometryProxy) -> CGFloat {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let menuHeight: CGFloat = 30
        return menuHeight + safeAreaBottom
    }

    // MARK: - Bottom Menu Helpers

    private func currentEventId() -> String? {
        switch navigationManager.currentScreen {
        case let .eventDetail(eventId):
            return eventId
        case let .eventAgenda(eventId):
            return eventId
        case let .eventLocation(eventId):
            return eventId
        case let .eventDinner(eventId):
            return eventId
        case let .eventSurvey(eventId):
            return eventId
        case let .eventMaterials(eventId):
            return eventId
        default:
            return nil
        }
    }

    private func currentNewsId() -> String? {
        switch navigationManager.currentScreen {
        case .newsList:
            return "news_list"
        case let .newsDetail(newsId):
            return newsId
        case .newsGroups:
            return "news_groups"
        case .newsBookmarks:
            return "news_bookmarks"
        case .newsCreate:
            return "news_create"
        case .newsDrafts:
            return "news_drafts"
        case let .newsEdit(newsId):
            return "news_edit_\(newsId)"
        case .newsEditDraft:
            return "news_edit_draft"
        default:
            return nil
        }
    }

    private var visibleBottomTabs: [BottomMenuTab] {
        if currentEventId() != nil {
            return [.eventDetails, .eventsAgenda, .eventsLocation, .eventsDinner, .eventsSurvey]
        } else if currentNewsId() != nil {

            var tabs: [BottomMenuTab] = [.start]

            if allowedFunctions.allowNews {
                tabs.append(.news)
                tabs.append(.newsGroups)
                tabs.append(.newsBookmarks)
            }

            if allowedFunctions.allowNewsCreate && allowEdit {
                tabs.append(.newsCreate)
            }

            return tabs
        } else {
            var tabs: [BottomMenuTab] = [.start]

            if allowedFunctions.allowNews {
                tabs.append(.news)
            }

            if allowedFunctions.allowEvents {
                tabs.append(.events)
            }

            if allowedFunctions.allowMaterials {
                tabs.append(.materials)
            }

            if allowedFunctions.allowAcademy {
                tabs.append(.academy)
            }
            return tabs
        }
    }
}
