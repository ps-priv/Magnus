import SwiftUI

struct MainNavigationContainer: View {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Bar
                RoundedTopBar(
                    title: navigationManager.currentScreen.title,
                    canGoBack: navigationManager.canGoBack,
                    showSearchButton: navigationManager.currentScreen.shouldShowSearchButton,
                    showNotificationButtons: navigationManager.currentScreen.shouldShowNotificationButtons,
                    showProfileButton: navigationManager.currentScreen.shouldShowProfileButton,
                    showSettingsButton: navigationManager.currentScreen.shouldShowSettingsButton,
                    onBackTap: {
                        navigationManager.goBack()
                    },
                    onProfileTap: {
                        navigationManager.navigate(to: .profile)
                    },
                    onSettingsTap: {
                        navigationManager.navigate(to: .settings)
                    }
                )
                
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
    }
    
    @ViewBuilder
    private func currentScreenView() -> some View {
        switch navigationManager.currentScreen {
        case .dashboard:
            DashboardMainView()
        case .eventsList:
            EventsListView()
        case .eventDetail(let eventId):
            EventDetailView(eventId: eventId)
        case .materialsList:
            MaterialsListView()
        case .materialDetail(let materialId):
            MaterialDetailView(materialId: materialId)
        case .newsList:
            NewsListView()
        case .newsDetail(let newsId):
            NewsDetailView(newsId: newsId)
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        case .academy:
            AcademyView()
        }
    }
    
    private var topBarHeight: CGFloat { 54 + 44 } // Bar height + safe area top estimate
    
    private func bottomMenuHeight(geometry: GeometryProxy) -> CGFloat {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let menuHeight: CGFloat = 60
        return menuHeight + safeAreaBottom
    }
} 
