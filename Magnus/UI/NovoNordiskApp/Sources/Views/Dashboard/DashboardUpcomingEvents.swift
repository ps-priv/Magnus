import SwiftUI
import MagnusFeatures
import MagnusDomain
import MagnusApplication
#if DEBUG
import Inject
#endif

struct DashboardUpcomingEventsPanel: View {

    #if DEBUG
    @ObserveInjection var inject
    #endif

    @Binding var items: [ConferenceEvent]
    @State private var currentPage: Int = 0
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            DashboardUpcomingEventsCard(item: items[0], action: {navigationManager.navigate(to: .eventsList)})
            Spacer()
        }
    }
}

struct DashboardUpcomingEventsCard: View {
    let item: ConferenceEvent
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            titleSection
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.novoNordiskBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text(PublishedDateHelper.formatDateRangeForEvent(item.dateFrom, item.dateTo))
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.novoNordiskBlue)
                }
                .padding(.top, 4)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            footerSection
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(10)
    }
    
    @ViewBuilder
    var titleSection: some View {
        HStack {
            FAIcon(
                FontAwesome.Icon.calendar,
                type: .thin,
                size: 21,
                color: Color.novoNordiskBlue
            )
            Text(LocalizedStrings.dashboardUpcomingEventsTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .lineLimit(1)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    var footerSection: some View {
        HStack {
            Spacer()
            NovoNordiskLinkButton(icon: FontAwesome.Icon.circle_arrow_right,
                title: LocalizedStrings.dashboardEventsSectionLoadMore,
                style: .small) {
                    action()
                }
             .padding(.bottom, 10)
             .padding(.top, 10)
             .padding(.trailing, 10)
        }
        .background(Color(.systemGray6))
        
    }
}

#Preview("DashboardUpcomingEventsCard") {
    DashboardUpcomingEventsCard(item: EventMockGenerator.createUpcomingEvents(count: 1)[0], action: {})
    Spacer()
}
