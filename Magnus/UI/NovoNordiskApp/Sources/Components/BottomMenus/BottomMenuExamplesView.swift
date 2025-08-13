import SwiftUI
import MagnusDomain

// MARK: - Bottom Menu Examples View
struct BottomMenuExamplesView: View {
    var body: some View {
        BottomMenuContainer { selectedTab in
            TabContentView(selectedTab: selectedTab)
        }
    }
}

// MARK: - Tab Content View
struct TabContentView: View {
    let selectedTab: BottomMenuTab
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(selectedTab: selectedTab)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    switch selectedTab {
                    case .start:
                        StartTabContent()
                    case .news:
                        NewsTabContent()
                    case .events:
                        EventsTabContent()
                    case .materials:
                        MaterialsTabContent()
                    case .academy:
                        AcademyTabContent()
                    case .eventDetails:
                        EventDetailView(eventId: "1")
                    case .eventsAgenda:
                        EventAgendaView(eventId: "1")
                    case .eventsLocation:
                        EventLocationView(eventId: "1")
                    case .eventsDinner:
                        EventDinnerView(eventId: "1")
                    case .eventsSurvey:
                        EventSurveyView(eventId: "1")
                    }
                }
                .padding()
            }
        }
    }
}


// MARK: - Header View
struct HeaderView: View {
    let selectedTab: BottomMenuTab
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.novoNordiskBlue)
                .frame(height: 0)
                .ignoresSafeArea(edges: .top)
            
            HStack {
                Text(selectedTab.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                
                Spacer()
                
                FAIcon(
                    selectedTab.icon,
                    type: .solid,
                    size: 24,
                    color: Color.novoNordiskBlue
                )
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Tab Content Views
struct StartTabContent: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Witaj w aplikacji Novo Nordisk!")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.novoNordiskBlue)
            
            Text("To jest główny ekran aplikacji. Tutaj możesz znaleźć najważniejsze informacje i szybki dostęp do funkcji.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            // Quick access buttons
            VStack(spacing: 12) {
                QuickAccessButton(
                    title: "Najnowsze aktualności",
                    icon: .newspaper,
                    color: .blue
                )
                
                QuickAccessButton(
                    title: "Nadchodzące wydarzenia",
                    icon: .calendar,
                    color: .green
                )
                
                QuickAccessButton(
                    title: "Materiały szkoleniowe",
                    icon: .fileAlt,
                    color: .orange
                )
            }
        }
    }
}

struct NewsTabContent: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<5) { index in
                NewsItemCard(
                    title: "Aktualność \(index + 1)",
                    description: "To jest przykładowy opis aktualności. Zawiera ważne informacje dla użytkowników aplikacji.",
                    date: "2024-01-\(String(format: "%02d", index + 1))"
                )
            }
        }
    }
}

struct EventsTabContent: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<4) { index in
                EventItemCard(
                    title: "Wydarzenie \(index + 1)",
                    location: "Sala konferencyjna \(index + 1)",
                    date: "2024-02-\(String(format: "%02d", (index + 1) * 5))",
                    time: "\(9 + index):00 - \(10 + index):30"
                )
            }
        }
    }
}

struct MaterialsTabContent: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<6) { index in
                MaterialItemCard(
                    title: "Materiał \(index + 1)",
                    type: index % 2 == 0 ? "PDF" : "Video",
                    size: "\(index + 1).5 MB"
                )
            }
        }
    }
}

struct AcademyTabContent: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<3) { index in
                AcademyItemCard(
                    title: "Kurs \(index + 1)",
                    description: "Szkolenie dotyczące ważnych aspektów pracy.",
                    duration: "\(30 + index * 15) min",
                    progress: Double(index + 1) * 0.3
                )
            }
        }
    }
}

// MARK: - Card Components
struct QuickAccessButton: View {
    let title: String
    let icon: FontAwesome.Icon
    let color: Color
    
    var body: some View {
        HStack {
            FAIcon(icon, type: .solid, size: 20, color: color)
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            FAIcon(.forward, type: .light, size: 16, color: .secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct NewsItemCard: View {
    let title: String
    let description: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Text(date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct EventItemCard: View {
    let title: String
    let location: String
    let date: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(location)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("\(date) • \(time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            FAIcon(.calendar, type: .solid, size: 24, color: Color.novoNordiskBlue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct MaterialItemCard: View {
    let title: String
    let type: String
    let size: String
    
    var body: some View {
        HStack {
            FAIcon(.fileAlt, type: .solid, size: 24, color: .orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(type) • \(size)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            FAIcon(.forward, type: .light, size: 16, color: .secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct AcademyItemCard: View {
    let title: String
    let description: String
    let duration: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                FAIcon(.graduationCap, type: .solid, size: 24, color: Color.novoNordiskBlue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Postęp")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.novoNordiskBlue))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview {
    BottomMenuExamplesView()
} 
