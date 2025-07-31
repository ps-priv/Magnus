import SwiftUI
import Kingfisher

struct EventDetailView: View {
    let eventId: String
    @State private var event: Event?
    @State private var isRegistered: Bool = false
    @State private var showingRegistrationAlert = false
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let event = event {
                    // Hero Image
                    heroImageSection(event: event)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Title and basic info
                        titleSection(event: event)
                        
                        // Date and location
                        dateLocationSection(event: event)
                        
                        // Description
                        descriptionSection(event: event)
                        
                        // Participants info
                        participantsSection(event: event)
                        
                        // Action buttons
                        actionButtonsSection(event: event)
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                } else {
                    // Loading state
                    loadingView
                }
            }
        }
        .background(Color(.systemGray6))
        .onAppear {
            loadEvent()
        }
        .alert("Rejestracja", isPresented: $showingRegistrationAlert) {
            Button("Anuluj", role: .cancel) { }
            Button(isRegistered ? "Wyrejestruj" : "Zarejestruj") {
                toggleRegistration()
            }
        } message: {
            Text(isRegistered ? "Czy na pewno chcesz się wyrejestrować z tego wydarzenia?" : "Czy chcesz się zarejestrować na to wydarzenie?")
        }
    }
    
    @ViewBuilder
    private func heroImageSection(event: Event) -> some View {
        if let imageUrl = event.imageUrl {
            KFImage(URL(string: imageUrl))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .tint(.novoNordiskBlue)
                                FAIcon(.calendar, type: .light, size: 80, color: .gray)
                                    .padding(.top, 16)
                            }
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
            .frame(height: 250)
            .clipped()
        }
    }
    
    @ViewBuilder
    private func titleSection(event: Event) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if event.isRegistered {
                    HStack(spacing: 4) {
                        FAIcon(.check, type: .solid, size: 20, color: .green)
                        Text("Zarejestrowany")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    @ViewBuilder
    private func dateLocationSection(event: Event) -> some View {
        VStack(spacing: 12) {
            HStack {
                FAIcon(.clock, type: .light, size: 20, color: .novoNordiskBlue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Data i godzina")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.formattedDateRange)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.novoNordiskBlue)
                }
                Spacer()
            }
            
            HStack {
                FAIcon(.check, type: .light, size: 20, color: .novoNordiskBlue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lokalizacja")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.location)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.novoNordiskBlue)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func descriptionSection(event: Event) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Opis wydarzenia")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(event.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func participantsSection(event: Event) -> some View {
        if let maxParticipants = event.maxParticipants {
            VStack(alignment: .leading, spacing: 12) {
                Text("Uczestnicy")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack {
                    FAIcon(.users, type: .light, size: 20, color: .orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(event.currentParticipants) z \(maxParticipants) miejsc zajętych")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                        
                        ProgressView(value: Double(event.currentParticipants), total: Double(maxParticipants))
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 200)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
    
    @ViewBuilder
    private func actionButtonsSection(event: Event) -> some View {
        VStack(spacing: 12) {
            // Registration button
            NovoNordiskButton(
                title: isRegistered ? "Wyrejestruj się" : "Zarejestruj się",
                style: isRegistered ? .outline : .primary
            ) {
                showingRegistrationAlert = true
            }
            
            // Share button
            NovoNordiskButton(
                title: "Udostępnij wydarzenie",
                style: .outline
            ) {
                shareEvent()
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Ładowanie wydarzenia...")
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    private func loadEvent() {
        // Mock loading event - in real app this would fetch from API
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let foundEvent = EventMockData.sampleEvents.first(where: { $0.id == eventId }) {
                event = foundEvent
                isRegistered = foundEvent.isRegistered
            } else {
                // Fallback to first event if specific ID not found
                event = EventMockData.sampleEvents.first
                isRegistered = event?.isRegistered ?? false
            }
        }
    }
    
    private func toggleRegistration() {
        withAnimation {
            isRegistered.toggle()
            // In real app, this would make API call to register/unregister
            // Update the event object
            if var currentEvent = event {
                currentEvent = Event(
                    id: currentEvent.id,
                    title: currentEvent.title,
                    description: currentEvent.description,
                    startDate: currentEvent.startDate,
                    endDate: currentEvent.endDate,
                    location: currentEvent.location,
                    imageUrl: currentEvent.imageUrl,
                    isRegistered: isRegistered,
                    maxParticipants: currentEvent.maxParticipants,
                    currentParticipants: isRegistered ? currentEvent.currentParticipants + 1 : max(0, currentEvent.currentParticipants - 1)
                )
                event = currentEvent
            }
        }
    }
    
    private func shareEvent() {
        // In real app, this would open share sheet
        print("Sharing event: \(event?.title ?? "Unknown")")
    }
}

#Preview {
    EventDetailView(eventId: "1")
        .environmentObject(NavigationManager())
} 
