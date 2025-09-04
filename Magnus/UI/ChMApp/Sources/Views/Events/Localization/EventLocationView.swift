import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventLocationView: View {

    @StateObject private var viewModel: EventLocationViewModel

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventLocationViewModel(eventId:eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let event = viewModel.event {
                    EventLocationCardView(location: event.location, event_name: event.name)
                } else {
                   EventDetailErrorMessageView(errorMessage: viewModel.errorMessage, errorTitle: LocalizedStrings.eventDetailsNotFoundTitle)
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}