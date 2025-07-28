import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventsListView: View {
    @State private var events: [ConferenceEvent] = EventMockGenerator.createRandomEvents(count: 4)
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
    var items: [ConferenceEvent]
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
            EventsListLink(action: {
                navigationManager.navigate(to: .eventsList)
                print("eventsListLink tapped")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    let event: ConferenceEvent
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    // Image section - 60% of screen height
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: event.image)) { image in
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


                        HStack {
                            Spacer()
                            Button(action: {
                            }) {
                                Text("Transmisja")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.red)
                                    .cornerRadius(16)
                                    .shadow(radius: 2)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 12)
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
                            Text(event.dateFrom)
                                .font(.caption)
                                .foregroundColor(.novoNordiskBlue)

                            Spacer()

                            FAIcon(.calendar, type: .light, size: 14, color: .novoNordiskBlue)
                            Text(event.location)
                                .font(.caption)
                                .foregroundColor(.novoNordiskBlue)
                                .lineLimit(1)
                        }

                        // Seats info
                        HStack {
                            FAIcon(.users, type: .light, size: 14, color: .orange)
                            Text("\(event.occupiedSeats)/\(event.totalSeats) miejsc")
                                .font(.caption)
                                .foregroundColor(.orange)

                            if event.isOnline {
                                Spacer()
                                FAIcon(.filePdf, type: .light, size: 14, color: .green)
                                Text("Online")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
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
        EventCardView(event: EventMockGenerator.createSingle(), onTap: {
            // Action when tapped
        })
    }
    .background(Color(.systemGray6))
}

#Preview("EventListPanel") {
    EventListPanel(items: EventMockGenerator.createRandomEvents(count: 4))
        .environmentObject(NavigationManager())
}
