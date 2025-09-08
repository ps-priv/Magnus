import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher


struct MessageDetailView: View {
    let messageId: String
    @EnvironmentObject var navigationManager: NavigationManager

    @StateObject private var viewModel: MessageDetailViewModel

    init(messageId: String) {
        self.messageId = messageId
        _viewModel = StateObject(wrappedValue: MessageDetailViewModel(messageId: messageId))
    }
    

    var body: some View {
        ScrollView {
            if let message = viewModel.message {
                MessageDetailCardView(message: message)
            }
        }
        .padding()
        .background(Color.novoNordiskBackgroundGrey)
    }
    

    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
    
    private func formatDateWithTime(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            let formattedDate = outputFormatter.string(from: date)
            
            // Add simulated time for presentation
            let hour = Int.random(in: 8...17)
            let minute = Int.random(in: 0...59)
            return "\(formattedDate) | \(String(format: "%02d:%02d", hour, minute))"
        }
        
        return dateString
    }
}

// MARK: - MessageLinkView Component
struct MessageLinkView: View {
    let icon: FontAwesome.Icon
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            FAIcon(icon, type: .regular, size: 16, color: .novoNordiskBlue)
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(.body)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.novoNordiskBackgroundGrey)
        .cornerRadius(6)
    }
}

#Preview {
    MessageDetailView(messageId: "message_1")
        .environmentObject(NavigationManager())
}
