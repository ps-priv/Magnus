import SwiftUI

struct EventsListView: View {
    @State private var events: [Event] = EventMockData.sampleEvents
    @State private var searchText = ""
    @EnvironmentObject var navigationManager: NavigationManager
    
    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Events List
            if filteredEvents.isEmpty {
                emptyStateView
            } else {
                eventsList
            }
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            FAIcon(.search, type: .light, size: 16, color: .gray)
            
            TextField("Szukaj wydarzeń...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var eventsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEvents) { event in
                    EventCardView(event: event) {
                        navigationManager.navigateToEventDetail(eventId: event.id)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            FAIcon(.calendar, type: .light, size: 60, color: .gray)
            
            Text("Brak wydarzeń")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text("Nie znaleziono wydarzeń spełniających kryteria wyszukiwania")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

// MARK: - Event Card View
struct EventCardView: View {
    let event: Event
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Event Image
                if let imageUrl = event.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                FAIcon(.calendar, type: .light, size: 40, color: .gray)
                            )
                    }
                    .frame(height: 160)
                    .clipped()
                }
                
                // Event Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(event.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        if event.isRegistered {
                            FAIcon(.check, type: .solid, size: 20, color: .green)
                        }
                    }
                    
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
                        
                        FAIcon(.check, type: .light, size: 14, color: .novoNordiskBlue)
                        Text(event.location)
                            .font(.caption)
                            .foregroundColor(.novoNordiskBlue)
                            .lineLimit(1)
                    }
                    
                    // Participants info
                    if let maxParticipants = event.maxParticipants {
                        HStack {
                            FAIcon(.users, type: .light, size: 14, color: .orange)
                            Text("\(event.currentParticipants)/\(maxParticipants) uczestników")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Mock Data
struct EventMockData {
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
            id: "3",
            title: "Webinar: Przyszłość leczenia otyłości",
            description: "Online prezentacja najnowszych badań i terapii w leczeniu otyłości. Eksperci przedstawią najbardziej efektywne metody terapeutyczne.",
            startDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
            endDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
            location: "Online",
            imageUrl: nil,
            isRegistered: true,
            maxParticipants: nil,
            currentParticipants: 0
        )
    ]
}

#Preview {
    EventsListView()
        .environmentObject(NavigationManager())
} 
