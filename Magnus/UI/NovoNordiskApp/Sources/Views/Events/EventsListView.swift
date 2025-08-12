import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI
import Kingfisher

struct EventsListView: View {
    @State private var events: [ConferenceEvent] = EventMockGenerator.createRandomEvents(count: 4)
    @State var isArchivedEventsViewVisible = false
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(alignment: .leading) {
            if isArchivedEventsViewVisible {
                ArchivedEventsView(events: events, action: toggleArchivedEventsView)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                if events.isEmpty {
                    EventListEmptyStateView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                } else {
                    EventListPanel(items: events, action: toggleArchivedEventsView)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
        .animation(.easeInOut(duration: 0.3), value: isArchivedEventsViewVisible)
    }

    func toggleArchivedEventsView() {
        isArchivedEventsViewVisible.toggle()
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
            EventsListLink(action: action)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novoNordiskBackgroundGrey)
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
    @EnvironmentObject var navigationManager: NavigationManager
    let event: ConferenceEvent
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    // Image section - 60% of screen height
                    ZStack(alignment: .bottom) {
                        KFImage(URL(string: event.image))
                            .placeholder {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        VStack {
                                            ProgressView()
                                                .scaleEffect(1.2)
                                                .tint(.novoNordiskBlue)
                                            FAIcon(.calendar, type: .light, size: 18, color: .gray)
                                                .padding(.top, 8)
                                        }
                                    )
                            }
                            .resizable()
                            .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                        .clipped()
                        .overlay(
                            QrCodeButtonView(action: {
                                navigationManager.navigateToEventQrCode(event: event)
                            })
                            .padding(.top, 12)
                            .padding(.trailing, 12),
                            alignment: .topTrailing
                        )

                        HStack {
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    FAIcon(.circle_play, type: .light, size: 15, color: .novoNordiskOrangeRed)
                                    Text(LocalizedStrings.eventAvailableTransmission)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.4))
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
                            .foregroundColor(Color.novoNordiskTextGrey)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 3)

                        HStack {
                            Text(PublishedDateHelper.formatDateRangeForEvent(event.dateFrom, event.dateTo, LocalizedStrings.months))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.novoNordiskBlue)
                                .padding(.bottom, 3)

                            if event.isOnline {
                                EventInProgressView()
                                Spacer()
                            }
                        }

                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.novoNordiskTextGrey)

                        // Seats info
                        HStack {
                            EventSeatsInfoView(occupiedSeats: event.occupiedSeats, totalSeats: event.totalSeats)
                                .padding(.trailing, 10)
                            EventSeatsNotConfirmedView(notConfirmedSeats: event.unconfirmedSeats)
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
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
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview("EventListPanel") {
    EventListPanel(items: EventMockGenerator.createRandomEvents(count: 4), action: {})
        .environmentObject(NavigationManager())
}

#Preview("EventListEmptyStateView") {
    EventListEmptyStateView()
        .environmentObject(NavigationManager())
}
