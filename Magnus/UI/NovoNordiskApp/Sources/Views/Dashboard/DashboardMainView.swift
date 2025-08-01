import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

#if DEBUG
    import Inject
#endif

struct DashboardMainView: View {

    @StateObject private var viewModel = DashboardViewModel()

    @State private var newsItems: [NewsItem] = NewsItemMockGenerator.createMany(count: 3)
    @State private var events: [ConferenceEvent] = EventMockGenerator.createUpcomingEvents(count: 3)
    @State private var materials: [ConferenceMaterial] =
        ConferenceMaterialsMockGenerator.createRandomMany(count: 3)
    @State private var academy: [ConferenceMaterial] =
        ConferenceMaterialsMockGenerator.createRandomMany(count: 1)
    @EnvironmentObject var navigationManager: NavigationManager
    #if DEBUG
        @ObserveInjection var inject
    #endif

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                DashboardNewsPanel(items: $newsItems)
                DashboardUpcomingEventsPanel(items: $events)
                DashboardMaterialsPanel(items: $materials)
                DashboardAcademyPanel(items: $academy)
                Spacer()
            }
            .padding()
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}

// MARK: - SwiftUI Previews

#Preview {
    DashboardMainView()
        .environmentObject(NavigationManager())
}
