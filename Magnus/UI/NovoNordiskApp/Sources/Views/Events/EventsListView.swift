import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI
import Kingfisher

struct EventsListView: View {
    @StateObject private var viewModel: EventsListViewModel = EventsListViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isArchivedEventsViewVisible {
                ArchivedEventsView(events: viewModel.events, action: toggleArchivedEventsView)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                if viewModel.events.isEmpty {
                    EventListEmptyStateView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                } else {
                    EventListPanel(items: viewModel.events, action: toggleArchivedEventsView)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isArchivedEventsViewVisible)
    }

    func toggleArchivedEventsView() {
        viewModel.isArchivedEventsViewVisible.toggle()
    }
}

// #Preview("EventCardView") {
//     VStack {
//         EventCardView(event: EventMockGenerator.createSingle(), onTap: {
//             // Action when tapped
//         })
//         .padding()
//         .background(Color(.systemGray6))
//     }
// }

// #Preview("EventListPanel") {
//     EventListPanel(items: EventMockGenerator.createRandomEvents(count: 4), action: {})
//         .environmentObject(NavigationManager())
// }

// #Preview("EventListEmptyStateView") {
//     EventListEmptyStateView()
//         .environmentObject(NavigationManager())
// }
