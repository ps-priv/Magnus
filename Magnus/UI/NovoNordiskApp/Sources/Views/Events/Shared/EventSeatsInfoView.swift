import SwiftUI

struct EventSeatsInfoView: View {
    let occupiedSeats: Int
    let totalSeats: Int

    var body: some View {
        HStack {
            FAIcon(.users, type: .light, size: 14, color: .novoNordiskBlue)
            Text(LocalizedStrings.eventSeats)
                .font(.caption)
                .foregroundColor(.novoNordiskBlue)
            Text("\(occupiedSeats)/\(totalSeats)")
                .font(.caption)
                .foregroundColor(.novoNordiskBlue)
        }
    }
}
