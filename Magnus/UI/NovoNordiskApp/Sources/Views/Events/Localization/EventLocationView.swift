import SwiftUI

struct EventLocationView: View {

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }

    var body: some View {
        Text("Event Location \(eventId)")
    }
}