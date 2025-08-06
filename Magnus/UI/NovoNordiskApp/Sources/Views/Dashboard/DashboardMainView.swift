import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

#if DEBUG
    import Inject
#endif

struct DashboardMainView: View {

    @StateObject private var viewModel = DashboardViewModel()

    @EnvironmentObject var navigationManager: NavigationManager
    #if DEBUG
        @ObserveInjection var inject
    #endif

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                DashboardNewsPanel(items: $viewModel.news)
                DashboardUpcomingEventsPanel(items: $viewModel.events)
                DashboardMaterialsPanel(items: $viewModel.materials)
                // DashboardAcademyPanel(items: viewModel.academy)
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
