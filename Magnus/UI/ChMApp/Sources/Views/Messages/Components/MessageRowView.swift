import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MessageRowView: View {
    let message: ConferenceMessage
    let action: () -> Void

    init(message: ConferenceMessage, action: @escaping () -> Void) {
        self.message = message
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.title)
                        .font(.body)
                        .fontWeight(message.is_read ? .regular : .bold)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        Text(formatDate(message.publish_date))
                            .font(.caption)
                            .foregroundColor(Color.novoNordiskTextGrey)
                        Text("|")
                            .font(.caption)
                            .foregroundColor(Color.novoNordiskTextGrey)
                        Text(message.publish_time)
                            .font(.caption)
                            .foregroundColor(Color.novoNordiskTextGrey)
                        Spacer()
                    }
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
            return formattedDate
            //return "\(formattedDate) | \(String(format: "%02d:%02d", hour, minute))"
        }
        
        return dateString
    }
}