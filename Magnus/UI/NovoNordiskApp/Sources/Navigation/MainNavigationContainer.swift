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
//                    .frame(
//                        width: geometry.size.width,
//                        height: geometry.size.height - topBarHeight - bottomMenuHeight(geometry: geometry)
//                    )
                Spacer()
                // Bottom Menu
                BottomMenu(
                    selectedTab: $navigationManager.selectedBottomTab,
                    onTabSelected: { tab in
                        navigationManager.navigateToTabRoot(tab)
                    }
                )
                //.frame(height: bottomMenuHeight(geometry: geometry))
            }
        }
        .environmentObject(navigationManager)
        .animation(.easeInOut(duration: 0.3), value: navigationManager.currentScreen)
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
