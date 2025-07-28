import SwiftUI
#if DEBUG
    import Inject
#endif

struct MainNavigationContainer: View {
    @StateObject private var navigationManager = NavigationManager()
    #if DEBUG
        @ObserveInjection var inject
    #endif

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
                // .frame(
                //     width: geometry.size.width,
                //     height: geometry.size.height - topBarHeight - (navigationManager.currentScreen.shouldShowBottomMenu ? bottomMenuHeight(geometry: geometry) : 0)
                // )

                // Bottom Menu - Show conditionally
                if navigationManager.currentScreen.shouldShowBottomMenu {
                    BottomMenu(
                        selectedTab: $navigationManager.selectedBottomTab,
                        onTabSelected: { tab in
                            navigationManager.navigateToTabRoot(tab)
                        }
                    )
                    .frame(height: bottomMenuHeight(geometry: geometry))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .environmentObject(navigationManager)
        .animation(.easeInOut(duration: 0.3), value: navigationManager.currentScreen)
        .animation(.easeInOut(duration: 0.3), value: navigationManager.currentScreen.shouldShowBottomMenu)
        #if DEBUG
            .enableInjection()
        #endif
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
        case let .newsDetail(newsId):
            NewsDetailView(newsId: newsId)
        case .profile:
            UserProfileView()
        case .settings:
            SettingsView()
        case .academy:
            AcademyView()
        case .messagesList:
            MessagesListView()
        case let .messageDetail(messageId):
            MessageDetailView(messageId: messageId)
        }
    }

    private var topBarHeight: CGFloat { 54 + 44 }

    private func bottomMenuHeight(geometry: GeometryProxy) -> CGFloat {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let menuHeight: CGFloat = 30
        return menuHeight + safeAreaBottom
    }
}
