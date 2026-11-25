import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct EventListPanel: View {
    var items: [ConferenceEvent]
    var action: () -> Void
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, event in
                        EventCardView(event: event) {
                            navigationManager.navigateToEventDetail(eventId: event.id)
                        }
                        // .frame(height: geometry.size.height - 200)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0 ..< min(items.count, 4), id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.novoNordiskBlue : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 10)
            }
            .padding(.top, 20)
            Spacer()
            //EventsListLink(action: action)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novoNordiskBackgroundGrey)
    }
}
