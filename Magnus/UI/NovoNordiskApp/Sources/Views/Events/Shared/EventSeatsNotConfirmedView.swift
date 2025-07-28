import SwiftUI

struct EventSeatsNotConfirmedView: View {
    let notConfirmedSeats: Int

    var body: some View {
        if notConfirmedSeats > 0 {
            HStack {
                FAIcon(.user_clock, type: .light, size: 14, color: .novoNordiskOrangeRed)
                Text(LocalizedStrings.eventSeatsNotConfirmed)
                    .font(.caption)
                    .foregroundColor(.novoNordiskBlue)
                Text("\(notConfirmedSeats)")
                    .font(.caption)
                    .foregroundColor(.novoNordiskBlue)
                Spacer()
            }
        }
    }
}
