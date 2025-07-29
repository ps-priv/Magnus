import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct ArchivedEventsView: View {
    @State var events: [ConferenceEvent]

    var body: some View {
        VStack(spacing: 0) {
            titleSection
            VStack(alignment: .leading, spacing: 4) {
                if !events.isEmpty {
                    ArchivedEventsListPanel(items: events)
                } else {
                    ArchivedEmptyEventsListPanel()
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            Button(action: {
                // TODO: Implement
            }) {
                FAIcon(
                    FontAwesome.Icon.circle_arrow_left,
                    type: .regular,
                    size: 24,
                    color: Color.novoNordiskBlue
                )
                Text(LocalizedStrings.archivedEventTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
    }
}

struct ArchivedEventsListPanel: View {
    @State var items: [ConferenceEvent]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    ArchivedEventRow(item: items[index])
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

struct ArchivedEventRow: View {
    var item: ConferenceEvent

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .fontWeight(.bold)

            HStack {
                Text(PublishedDateHelper.formatDateRangeForEvent(item.dateFrom, item.dateTo, LocalizedStrings.months))
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)

                if item.isFinished {
                    FinishedEventIndicatorView()
                }

                Spacer()
            }
            .padding(.top, 3)
        }
        .padding(.horizontal, 5)
        .padding(.top, 20)
    }
}

struct ArchivedEmptyEventsListPanel: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            FAIcon(.calendar, type: .light, size: 60, color: .novoNordiskBlue)
            Text(LocalizedStrings.eventsListEmptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.novoNordiskBlue)

            Text(LocalizedStrings.archivedEventEmptyListMessage)
                .font(.body)
                .foregroundColor(.novoNordiskBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
    }
}

#Preview("ArchivedEventsListPanel") {
    let items = EventMockGenerator.createPastEvents(count: 20)

    return ArchivedEventsListPanel(items: items)
}

#Preview("ArchivedEmptyEventsListPanel") {
    ArchivedEmptyEventsListPanel()
}

#Preview("ArchivedEventsView") {
    let events = EventMockGenerator.createPastEvents(count: 20)
    VStack {
        ArchivedEventsView(events: events)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 10)
    .background(Color(.systemGray6))
}
