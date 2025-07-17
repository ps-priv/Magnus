import SwiftUI
import MagnusFeatures
import MagnusDomain
#if DEBUG
import Inject
#endif

struct DashboardMainView: View {
    @State private var newsItems: [NewsItem] = NewsItemMockGenerator.createMany(count: 3)
    @EnvironmentObject var navigationManager: NavigationManager
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
                Text("Hello World4")
                .fontWeight(.bold)
                .font(.system(size: 14))
                .foregroundColor(.novoNordiskBlue)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            VStack(spacing: 0) {
                //RoundedTopBar(title: "Start")
                Spacer()
                //BottomMenu(selectedTab: .constant(.start))
            }
        }
        #if DEBUG
        .enableInjection()
        #endif
//        ScrollView {
//            VStack(spacing: 20) {
//                // Welcome Section
//                //welcomeSection
//                
//                // News Panel
//                DashboardNewsPanel(items: $newsItems)
//                
//                // Quick Actions
//                //quickActionsSection
//                
//                Spacer(minLength: 20)
//            }
//            .padding()
//        }
//        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var welcomeSection: some View {
        VStack(spacing: 12) {
            Text("Witaj w aplikacji Novo Nordisk")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.novoNordiskBlue)
            
            Text("Twoje centrum wiedzy medycznej")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Szybki dostęp")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionCard(
                    icon: .calendar,
                    title: "Wydarzenia",
                    color: .orange
                ) {
                    navigationManager.navigate(to: .eventsList)
                }
                
                QuickActionCard(
                    icon: .fileAlt,
                    title: "Materiały",
                    color: .blue
                ) {
                    navigationManager.navigate(to: .materialsList)
                }
                
                QuickActionCard(
                    icon: .newspaper,
                    title: "Aktualności",
                    color: .green
                ) {
                    navigationManager.navigate(to: .newsList)
                }
                
                QuickActionCard(
                    icon: .user,
                    title: "Profil",
                    color: .purple
                ) {
                    navigationManager.navigate(to: .profile)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct QuickActionCard: View {
    let icon: FontAwesome.Icon
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                FAIcon(icon, type: .light, size: 24, color: color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - SwiftUI Previews
#Preview {
    DashboardMainView()
        .environmentObject(NavigationManager())
} 
