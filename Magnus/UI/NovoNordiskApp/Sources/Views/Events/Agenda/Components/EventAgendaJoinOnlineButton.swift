import SwiftUI

struct EventAgendaJoinOnlineButton: View {
    let isOnline: Int
    let action: () -> Void

    init(isOnline: Int, action: @escaping () -> Void) {
        self.isOnline = isOnline
        self.action = action
    }

    var body: some View {
        Button(action: isOnline == 1 ? action : {}) {
            HStack {
                FAIcon(.circle_play, type: .light, size: 15, color: Color.white)
                Text(LocalizedStrings.eventAgendaJoinOnline)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(isOnline == 1 ? Color.novoNordiskOrangeRed : Color.novoNordiskOrangeRed.opacity(0.3))
            .cornerRadius(16)
            .shadow(radius: 2)
        }
        .disabled(isOnline == 0)
    }
}

#Preview("EventAgendaJoinOnlineButton - disabled") {
    VStack {
        EventAgendaJoinOnlineButton(isOnline: 0, action: {})
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("EventAgendaJoinOnlineButton - enabled") {
    VStack {
        EventAgendaJoinOnlineButton(isOnline: 1, action: {})
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
