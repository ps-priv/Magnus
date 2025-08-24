import SwiftUI

struct EventPhotoView: View {
    var eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }

    var body: some View {
        Text("Event Photo")
    }
}

