import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher


struct MessageDetailView: View {
    let messageId: String
    @State private var message: ConferenceMessage? = nil
    @EnvironmentObject var navigationManager: NavigationManager
    

    var body: some View {
        ScrollView {
            if let message = message {
                VStack(alignment: .leading, spacing: 16) {

                    VStack(alignment: .leading) {
                        KFImage(URL(string: message.image))
                            .placeholder {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(1.5)
                                            .tint(.novoNordiskBlue)
                                    )
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                          .frame(height: 250)
                          .clipped()
                          .cornerRadius(25)

                        VStack(alignment: .leading) {
                            Text(message.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.novoNordiskTextGrey)
                                .font(.system(size: 19))
                            
                            Text(message.date)
                                .font(.subheadline)
                                .foregroundColor(Color.novoNordiskBlue)

                            Text(message.content)
                                .font(.body)
                                .foregroundColor(Color.novoNordiskTextGrey)
                                .padding(.top, 10)
                        }
                        .padding(16)
                    }
                    .background(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(25)
                    // .overlay(
                    //     RoundedRectangle(cornerRadius: 25)
                    //         .stroke(Color.white, lineWidth: 3)
                    // )

                        VStack(spacing: 8) {
                            MessageLinkView(
                                icon: .fileAlt,
                                title: "Nazwa udostępnionego pliku.pdf"
                            )
                            
                            MessageLinkView(
                                icon: .fileAlt,
                                title: "Nazwa udostępnionego pliku.docx"
                            )
                        }
                        .background(Color.novoNordiskBackgroundGrey)
                        .padding(.top, 10)
                        .padding(.bottom, 16)


                } 
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .overlay(
                     RoundedRectangle(cornerRadius: 25)
                         .stroke(Color.white, lineWidth: 3)
                 )
            }
        }
        .padding()
        .background(Color.novoNordiskBackgroundGrey)
        .onAppear {
            loadMessage()
        }
    }
    
    private func loadMessage() {
        // Simulate loading message by ID
        let allMessages = MessagesMockGenerator.createMany(count: 20)
        message = allMessages.first { $0.id == messageId }
        
        // If not found, create a mock message
        if message == nil {
            message = MessagesMockGenerator.createSingle()
        }
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
