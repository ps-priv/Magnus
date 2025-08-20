import SwiftUI
import MagnusFeatures
import MagnusDomain


struct MessagesListView: View {
    @State private var messages: [ConferenceMessage] = MessagesMockGenerator.createMany(count: 14)
    @EnvironmentObject var navigationManager: NavigationManager
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(messages.indices, id: \.self) { index in
                    MessageRowView(message: messages[index])
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}

struct MessageRowView: View {
    let message: ConferenceMessage
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Button(action: {
            print("Tapped message: \(message.id)") // Debug print
            navigationManager.navigateToMessageDetail(messageId: message.id)
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(formatDate(message.date))
                        .font(.caption)
                        .foregroundColor(Color.novoNordiskTextGrey)
                }
                
                Spacer()
                
                FAIcon(.circle_arrow_right, type: .regular, size: 24, color: Color.novoNordiskLightBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            let formattedDate = outputFormatter.string(from: date)
            
            // Add time (simulated as we don't have time in the original data)
            let hour = Int.random(in: 8...17)
            let minute = Int.random(in: 0...59)
            return "\(formattedDate) | \(String(format: "%02d:%02d", hour, minute))"
        }
        
        return dateString
    }
}

#Preview {
    MessagesListView()
        .environmentObject(NavigationManager())
}
