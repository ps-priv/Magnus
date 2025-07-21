import SwiftUI

struct EventsListView: View {
    @State private var events: [Event] = EventMockData.sampleEvents
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(alignment: .leading) {
            if events.isEmpty {
                EventListEmptyStateView()
            } else {
                EventListPanel(items: events)
            }
        }
    }
}

struct EventsListLink: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                FAIcon(
                    FontAwesome.Icon.box_archive,
                    type: .thin,
                    size: 21,
                    color: Color.novoNordiskBlue
                )
                Text(LocalizedStrings.eventsListLinkToArchive)
                    .font(.system(size: 16))
                    .foregroundColor(Color.novoNordiskBlue)
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}

struct EventListPanel: View {
    var items: [Event]
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
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0 ..< min(items.count, 3), id: \.self) { index in
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
            EventsListLink(action: {
                navigationManager.navigate(to: .eventsList)
                print("eventsListLink tapped")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}

struct EventListPanel2: View {
    var items: [Event]
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { outerGeometry in
            GeometryReader { geometry in
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, event in
                            EventCardView(event: event) {
                                navigationManager.navigateToEventDetail(eventId: event.id)
                            }
                            .frame(height: geometry.size.height - 200)
                            .padding(.horizontal, 20)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                    HStack(spacing: 8) {
                        ForEach(0 ..< min(items.count, 3), id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.novoNordiskBlue : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    // .padding(.top, 8)
                    // .padding(.bottom, 20)
                }
                .background(Color.red)
            }
            .frame(height: outerGeometry.size.height * 0.8)
        }
        .background(Color(.systemGray6))
    }
}

struct EventListEmptyStateView: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            FAIcon(.calendar, type: .light, size: 60, color: .novoNordiskBlue)
            Text(LocalizedStrings.eventsListEmptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.novoNordiskBlue)

            Text(LocalizedStrings.eventsListEmptyStateDescription)
                .font(.body)
                .foregroundColor(.novoNordiskBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            EventsListLink(action: {
                navigationManager.navigate(to: .eventsList)
                print("eventsListLink tapped")
            })
        }
    }
}

// MARK: - Event Card View

struct EventCardView: View {
    let event: Event
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    // Image section - 60% of screen height
                    if let imageUrl = event.imageUrl {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    FAIcon(.calendar, type: .light, size: 40, color: .gray)
                                )
                        }
                        .frame(height: geometry.size.height * 0.6)
                        .clipped()
                    }

                    // Content section - remaining space
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)

                        HStack {
                            FAIcon(.clock, type: .light, size: 14, color: .novoNordiskBlue)
                            Text(event.formattedDate)
                                .font(.caption)
                                .foregroundColor(.novoNordiskBlue)

                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Mock Data

enum EventMockData {
    static let sampleEvents: [Event] = [
        Event(
            id: "1",
            title: "Konferencja Novo Nordisk 2024",
            description: "Główna konferencja poświęcona najnowszym osiągnięciom w diabetologii i endokrynologii. Spotka się z nami ponad 200 specjalistów z całego kraju.",
            startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            endDate: Calendar.current.date(byAdding: .day, value: 8, to: Date())!,
            location: "Warszawa, Hotel Marriott",
            imageUrl: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800",
            isRegistered: true,
            maxParticipants: 200,
            currentParticipants: 156
        ),
        Event(
            id: "2",
            title: "Warsztat: Nowoczesne technologie w diabetologii",
            description: "Praktyczne szkolenie z wykorzystania najnowszych technologii w leczeniu cukrzycy. Poznaj systemy CGM i pompy insulinowe nowej generacji.",
            startDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            endDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            location: "Kraków, Centrum Konferencyjne",
            imageUrl: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800",
            isRegistered: false,
            maxParticipants: 50,
            currentParticipants: 32
        ),
        Event(
            id: "2",
            title: "Warsztat: Nowoczesne technologie w diabetologii 2",
            description: "Praktyczne szkolenie z wykorzystania najnowszych technologii w leczeniu cukrzycy. Poznaj systemy CGM i pompy insulinowe nowej generacji.",
            startDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            endDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            location: "Kraków, Centrum Konferencyjne",
            imageUrl: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800",
            isRegistered: false,
            maxParticipants: 50,
            currentParticipants: 32
        ),
    ]
}

// MARK: - SwiftUI Previews

#Preview("EventCardView") {
    VStack {
        EventCardView(event: EventMockData.sampleEvents[0], onTap: {
            // Action when tapped
        })
    }
    .background(Color(.systemGray6))
}

#Preview("EventListPanel") {
    EventListPanel(items: EventMockData.sampleEvents)
        .environmentObject(NavigationManager())
}
