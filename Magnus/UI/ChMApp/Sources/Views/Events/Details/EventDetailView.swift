import SwiftUI
import MagnusFeatures
import MagnusDomain

struct EventDetailView: View {
    let eventId: String

    @StateObject private var viewModel: EventDetailViewModel

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(eventId: eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let event = viewModel.event {
                    EventDetailCardView(event: event, eventId: eventId)
                } else {
                    EventDetailsNotFound()
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)

    }
}
