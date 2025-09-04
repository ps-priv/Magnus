import SwiftUI
import MagnusDomain

struct EventSeatsInfoView: View {

    let seats: Seats

    init(seats: Seats) {
        self.seats = seats
    }


    var body: some View {
        HStack {
            FAIcon(.users, type: .light, size: 14, color: .novoNordiskBlue)
            Text(LocalizedStrings.eventSeats)
                .font(.caption)
                .foregroundColor(.novoNordiskBlue)
            Text("\(seats.taken)/\(seats.total)")
                .font(.caption)
                .foregroundColor(.novoNordiskBlue)

            if seats.unconfirmed > 0 {
                FAIcon(.user_clock, type: .light, size: 14, color: .novoNordiskOrangeRed)
                Text(LocalizedStrings.eventSeatsNotConfirmed)
                    .font(.caption)
                    .foregroundColor(.novoNordiskOrangeRed)
                Text("\(seats.unconfirmed)")
                    .font(.caption)
                    .foregroundColor(.novoNordiskOrangeRed)
            }
        }
    }
}

#Preview("Obie wartosci niezerowe") {
    let seats = Seats(total: 20, taken: 10, unconfirmed: 5)

    EventSeatsInfoView(seats: seats)
}

#Preview("Niepotwierdzone = 0") {
    let seats = Seats(total: 20, taken: 10, unconfirmed: 0)

    EventSeatsInfoView(seats: seats)
}

