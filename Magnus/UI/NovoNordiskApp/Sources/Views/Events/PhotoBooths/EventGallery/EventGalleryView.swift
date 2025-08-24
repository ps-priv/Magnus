import SwiftUI

struct EventGalleryView: View {
    var eventId: String

    init(eventId: String) {
        self.eventId = eventId
    }

    var body: some View {
        Text("Event Gallery")
    }
}
