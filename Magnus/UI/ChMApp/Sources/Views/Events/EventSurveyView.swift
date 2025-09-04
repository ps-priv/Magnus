import SwiftUI

struct EventSurveyView: View {

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }

    var body: some View {
        Text("Event Survey \(eventId)")
    }
}