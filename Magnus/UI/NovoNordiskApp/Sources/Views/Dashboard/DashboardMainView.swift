import SwiftUI
import MagnusFeatures
import MagnusDomain
#if DEBUG
import Inject
#endif

struct DashboardMainView: View {
    @State private var newsItems: [NewsItem] = NewsItemMockGenerator.createMany(count: 3)
    @State private var events: [ConferenceEvent] = EventMockGenerator.createUpcomingEvents(count: 3)
    @EnvironmentObject var navigationManager: NavigationManager
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
       ScrollView {
           VStack(alignment: .leading, spacing: 10) {
               DashboardNewsPanel(items: $newsItems)
               DashboardUpcomingEventsPanel(items: $events)
               Spacer()
           }
           .padding()
       }
       .background(Color(.systemGray6))
    }
}



// MARK: - SwiftUI Previews
#Preview {
    DashboardMainView()
        .environmentObject(NavigationManager())
} 
