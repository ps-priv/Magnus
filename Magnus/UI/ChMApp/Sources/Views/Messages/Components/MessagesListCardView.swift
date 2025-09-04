import SwiftUI
import MagnusFeatures
import MagnusDomain


struct MessagesListCardView: View {

    let messages: [ConferenceMessage]
    @EnvironmentObject var navigationManager: NavigationManager

    init(messages: [ConferenceMessage]) {
        self.messages = messages
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(messages.indices, id: \.self) { index in
                   MessageRowView(message: messages[index], action: {
                       navigationManager.navigateToMessageDetail(messageId: messages[index].id)
                   })
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}



#Preview {
    MessagesListCardView(messages: MessagesMockGenerator.createMany(count: 14))
        .environmentObject(NavigationManager())
}