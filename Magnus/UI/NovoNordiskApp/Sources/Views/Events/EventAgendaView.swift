import SwiftUI

struct EventAgendaView: View {

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }

    var body: some View {
        Text("Event Agenda \(eventId)")

    }
}